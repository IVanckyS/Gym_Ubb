import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/services/auth_service.dart';

class ResetPasswordVerifyScreen extends StatefulWidget {
  const ResetPasswordVerifyScreen({super.key, required this.email});

  final String email;

  @override
  State<ResetPasswordVerifyScreen> createState() =>
      _ResetPasswordVerifyScreenState();
}

class _ResetPasswordVerifyScreenState
    extends State<ResetPasswordVerifyScreen> {
  final List<TextEditingController> _pinControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _pinFocusNodes = List.generate(6, (_) => FocusNode());

  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final _authService = AuthService();
  bool _loading = false;
  String? _error;
  String? _resendError;
  String? _resendSuccess;
  bool _resending = false;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _startCooldown();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinFocusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _pinControllers) { c.dispose(); }
    for (final f in _pinFocusNodes) { f.dispose(); }
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _resendCooldown = 60);
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendCooldown <= 1) {
        t.cancel();
        if (mounted) setState(() => _resendCooldown = 0);
      } else {
        if (mounted) setState(() => _resendCooldown--);
      }
    });
  }

  String get _currentCode =>
      _pinControllers.map((c) => c.text).join();

  void _onBoxChanged(int index, String value) {
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
      for (int i = 0; i < 6 && i < digits.length; i++) {
        _pinControllers[i].text = digits[i];
      }
      final nextFocus = digits.length < 6 ? digits.length : 5;
      _pinFocusNodes[nextFocus].requestFocus();
      return;
    }
    if (value.isNotEmpty && index < 5) {
      _pinFocusNodes[index + 1].requestFocus();
    } else if (value.isNotEmpty && index == 5) {
      _pinFocusNodes[index].unfocus();
    }
  }

  void _onBoxKeyDown(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _pinControllers[index].text.isEmpty &&
        index > 0) {
      _pinFocusNodes[index - 1].requestFocus();
      _pinControllers[index - 1].clear();
    }
  }

  Future<void> _submit() async {
    final code = _currentCode;
    if (code.length != 6) return;

    final newPassword = _passwordCtrl.text;
    if (newPassword.isEmpty) {
      setState(() => _error = 'Ingresa tu nueva contraseña');
      return;
    }
    if (newPassword != _confirmCtrl.text) {
      setState(() => _error = 'Las contraseñas no coinciden');
      return;
    }
    if (newPassword.length < 8) {
      setState(() => _error = 'La contraseña debe tener al menos 8 caracteres');
      return;
    }
    if (!RegExp(r'[A-Z]').hasMatch(newPassword)) {
      setState(() => _error = 'Debe contener al menos una mayúscula');
      return;
    }
    if (!RegExp(r'[0-9]').hasMatch(newPassword)) {
      setState(() => _error = 'Debe contener al menos un número');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _authService.forgotPasswordVerify(
        email: widget.email,
        code: code,
        newPassword: newPassword,
      );
      if (!mounted) return;
      _showSuccessAndGoLogin();
    } on AuthException catch (e) {
      if (mounted) {
        setState(() => _error = e.message);
        if (e.code == 'INVALID_CODE' || e.code == 'TOO_MANY_ATTEMPTS') {
          for (final c in _pinControllers) { c.clear(); }
          _pinFocusNodes[0].requestFocus();
        }
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'Error de conexión. Intenta de nuevo.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSuccessAndGoLogin() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('¡Contraseña actualizada!'),
        content: const Text(
          'Tu contraseña fue cambiada correctamente. Inicia sesión con tu nueva contraseña.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/login');
            },
            child: const Text('Ir al inicio de sesión'),
          ),
        ],
      ),
    );
  }

  Future<void> _resendCode() async {
    if (_resendCooldown > 0 || _resending) return;
    setState(() {
      _resending = true;
      _resendError = null;
      _resendSuccess = null;
    });
    try {
      await _authService.forgotPasswordRequest(email: widget.email);
      if (mounted) {
        setState(() {
          _resendSuccess = 'Nuevo código enviado a ${widget.email}';
          _resending = false;
        });
        _startCooldown();
      }
    } on AuthException catch (e) {
      if (mounted) {
        setState(() {
          _resendError = e.message;
          _resending = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _resendError = 'No se pudo reenviar el código.';
          _resending = false;
        });
      }
    }
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final local = parts[0];
    if (local.length <= 2) return email;
    return '${local[0]}${'*' * (local.length - 2)}${local[local.length - 1]}@${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorBgPrimary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildCard(),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(
                      'Volver al inicio de sesión',
                      style: TextStyle(
                          color: context.colorTextSecondary, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFFf97316).withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_reset_rounded,
            color: Color(0xFFf97316),
            size: 36,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Restablecer contraseña',
          style: TextStyle(
            color: context.colorTextPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
                color: context.colorTextSecondary, fontSize: 14, height: 1.4),
            children: [
              const TextSpan(text: 'Enviamos un código de 6 dígitos a\n'),
              TextSpan(
                text: _maskEmail(widget.email),
                style: const TextStyle(
                  color: Color(0xFFf97316),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: context.colorBgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorBorder),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── PIN boxes ───────────────────────────────────────────────────────
          Text('Código de verificación',
              style: TextStyle(
                  color: context.colorTextSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) => _buildPinBox(i)),
          ),
          const SizedBox(height: 8),
          Text(
            'El código expira en 10 minutos',
            style: TextStyle(color: context.colorTextMuted, fontSize: 12),
          ),

          const SizedBox(height: 24),

          // ── Nueva contraseña ─────────────────────────────────────────────────
          Text('Nueva contraseña',
              style: TextStyle(
                  color: context.colorTextSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passwordCtrl,
            obscureText: _obscurePassword,
            style: TextStyle(color: context.colorTextPrimary),
            decoration: InputDecoration(
              hintText: '••••••••',
              prefixIcon:
                  Icon(Icons.lock_outline, color: context.colorTextMuted),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: context.colorTextMuted,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),

          const SizedBox(height: 12),

          TextFormField(
            controller: _confirmCtrl,
            obscureText: _obscureConfirm,
            style: TextStyle(color: context.colorTextPrimary),
            decoration: InputDecoration(
              hintText: 'Confirmar contraseña',
              prefixIcon:
                  Icon(Icons.lock_outline, color: context.colorTextMuted),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: context.colorTextMuted,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
          ),

          // ── Error ────────────────────────────────────────────────────────────
          if (_error != null || _resendError != null) ...[
            const SizedBox(height: 16),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.accentSecondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColors.accentSecondary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.accentSecondary, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error ?? _resendError!,
                      style: const TextStyle(
                          color: AppColors.accentSecondary, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── Éxito reenvío ────────────────────────────────────────────────────
          if (_resendSuccess != null) ...[
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColors.accentGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline,
                      color: AppColors.accentGreen, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_resendSuccess!,
                        style: const TextStyle(
                            color: AppColors.accentGreen, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  (_loading || _currentCode.length != 6) ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Cambiar contraseña'),
            ),
          ),

          const SizedBox(height: 12),

          TextButton(
            onPressed: (_resendCooldown > 0 || _resending) ? null : _resendCode,
            child: _resending
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    _resendCooldown > 0
                        ? 'Reenviar código (${_resendCooldown}s)'
                        : 'Reenviar código',
                    style: TextStyle(
                      color: _resendCooldown > 0
                          ? context.colorTextMuted
                          : AppColors.accentPrimary,
                      fontSize: 14,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinBox(int index) {
    return SizedBox(
      width: 44,
      height: 52,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) => _onBoxKeyDown(index, event),
        child: TextFormField(
          controller: _pinControllers[index],
          focusNode: _pinFocusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 6,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: TextStyle(
            color: context.colorTextPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: context.colorBorder, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFFf97316), width: 2),
            ),
            filled: true,
            fillColor: context.colorBgTertiary,
          ),
          onChanged: (v) => _onBoxChanged(index, v),
        ),
      ),
    );
  }
}
