import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _authService = AuthService();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final email = _emailCtrl.text.trim().toLowerCase();

    try {
      await _authService.forgotPasswordRequest(email: email);
      if (!mounted) return;
      context.push('/forgot-password/verify', extra: {'email': email});
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Error de conexión. Intenta de nuevo.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
          'Olvidé mi contraseña',
          style: TextStyle(
            color: context.colorTextPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ingresa tu correo institucional y te\nenviamos un código para recuperar tu acceso.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.colorTextSecondary,
            fontSize: 14,
            height: 1.4,
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              style: TextStyle(color: context.colorTextPrimary),
              decoration: InputDecoration(
                labelText: 'Correo institucional',
                hintText: 'usuario@alumnos.ubiobio.cl',
                prefixIcon:
                    Icon(Icons.email_outlined, color: context.colorTextMuted),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Ingresa tu correo';
                if (!AuthService.isValidUbbEmail(v.trim())) {
                  return 'Debe ser @alumnos.ubiobio.cl o @ubiobio.cl';
                }
                return null;
              },
            ),
            if (_error != null) ...[
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
                        _error!,
                        style: const TextStyle(
                            color: AppColors.accentSecondary, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Enviar código'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
