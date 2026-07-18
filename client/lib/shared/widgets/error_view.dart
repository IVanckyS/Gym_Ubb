import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/error_messages.dart';

/// Vista de error reutilizable: ícono + mensaje amigable + botón "Reintentar"
/// opcional. Reemplaza a los `_ErrorView` privados duplicados en cada screen.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isConnectionError(error) ? Icons.wifi_off : Icons.error_outline,
              color: AppColors.accentSecondary,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              humanizeError(error),
              style: TextStyle(color: context.colorTextSecondary),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
            ],
          ],
        ),
      ),
    );
  }
}

/// Muestra un SnackBar con el mensaje amigable de [error].
void showErrorSnackBar(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(humanizeError(error)),
      backgroundColor: AppColors.accentSecondary,
    ),
  );
}
