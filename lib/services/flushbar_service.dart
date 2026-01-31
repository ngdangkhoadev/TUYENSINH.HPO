import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

enum FlushbarType {
  success,
  error,
  warning,
  info,
}

class FlushbarService {
  static void show({
    required BuildContext context,
    required String message,
    required FlushbarType type,
    String? title,
    Duration duration = const Duration(seconds: 3),
    FlushbarPosition position = FlushbarPosition.TOP,
  }) {
    if (!context.mounted) return;

    final config = _getConfig(type);

    Flushbar(
      title: title,
      message: message,
      messageColor: Colors.white,
      titleColor: Colors.white,
      icon: Icon(
        config.icon,
        size: 28,
        color: Colors.white,
      ),
      backgroundColor: config.backgroundColor,
      duration: duration,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      flushbarPosition: position,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 400),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      leftBarIndicatorColor: config.indicatorColor,
      boxShadows: [
        BoxShadow(
          color: config.shadowColor,
          offset: const Offset(0, 4),
          blurRadius: 8,
        ),
      ],
    ).show(context);
  }

  static _FlushbarConfig _getConfig(FlushbarType type) {
    switch (type) {
      case FlushbarType.success:
        return _FlushbarConfig(
          icon: Icons.check_circle_outline,
          backgroundColor: Colors.green.shade600,
          indicatorColor: Colors.green.shade800,
          shadowColor: Colors.green.withValues(alpha: 0.3),
        );
      case FlushbarType.error:
        return _FlushbarConfig(
          icon: Icons.error_outline,
          backgroundColor: Colors.red.shade600,
          indicatorColor: Colors.red.shade800,
          shadowColor: Colors.red.withValues(alpha: 0.3),
        );
      case FlushbarType.warning:
        return _FlushbarConfig(
          icon: Icons.warning_amber_rounded,
          backgroundColor: Colors.orange.shade600,
          indicatorColor: Colors.orange.shade800,
          shadowColor: Colors.orange.withValues(alpha: 0.3),
        );
      case FlushbarType.info:
        return _FlushbarConfig(
          icon: Icons.info_outline,
          backgroundColor: Colors.blue.shade600,
          indicatorColor: Colors.blue.shade800,
          shadowColor: Colors.blue.withValues(alpha: 0.3),
        );
    }
  }

  // Helper methods for quick access
  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: FlushbarType.success,
      title: title,
      duration: duration,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      message: message,
      type: FlushbarType.error,
      title: title,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: FlushbarType.warning,
      title: title,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: FlushbarType.info,
      title: title,
      duration: duration,
    );
  }
}

class _FlushbarConfig {
  final IconData icon;
  final Color backgroundColor;
  final Color indicatorColor;
  final Color shadowColor;

  _FlushbarConfig({
    required this.icon,
    required this.backgroundColor,
    required this.indicatorColor,
    required this.shadowColor,
  });
}

