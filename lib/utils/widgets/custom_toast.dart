import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/utils/widgets/custom_button.dart';
import 'package:hyper_local/l10n/app_localizations.dart';

enum ToastType { success, error, warning, info, authGuard }

class ToastManager {
  static void show({
    required BuildContext context,
    required String message,
    bool fromAuthGuard = false,
    ToastType? type,
    bool showIcon = true,
    Color? backgroundColor,
    Color? textColor,
    double fontSize = 16.0,
    double borderRadius = 12.0,
    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
    StyledToastPosition position = StyledToastPosition.bottom,
    Duration duration = const Duration(seconds: 3),
  }) {
    backgroundColor ??= _getBackgroundColor(type);
    textColor ??= _getTextColor(type);
    final icon = showIcon ? _getIcon(type, textColor) : null;

    final router = GoRouter.of(context);

    showToastWidget(
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  icon,
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(color: textColor, fontSize: fontSize),
                  ),
                ),
                if (fromAuthGuard) ...[
                  CustomButton(
                      onPressed: () {
                        router.go(AppRoutes.login);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.signIn,
                        style: TextStyle(color: Colors.white),
                      ))
                ]
              ],
            ),
          ),
        ),
      ),
      context: context,
      position: position,
      duration: type == ToastType.error ? Duration(seconds: 5) : duration,
      animation: StyledToastAnimation.fade,
      reverseAnimation: StyledToastAnimation.fade,
      animDuration: Duration(milliseconds: fromAuthGuard ? 400 : 200),
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
      isIgnoring: false,
    );
  }

  static Color _getBackgroundColor(ToastType? type) {
    switch (type) {
      case ToastType.success:
        return const Color(0xFF28A745);
      case ToastType.error:
        return const Color(0xFFDC3545);
      case ToastType.warning:
        return const Color(0xFFFFC107);
      case ToastType.info:
        return const Color(0xFF17A2B8);
      case ToastType.authGuard:
        return AppTheme.primaryColor;
      default:
        return const Color(0xCC333333);
    }
  }

  static Color _getTextColor(ToastType? type) {
    switch (type) {
      case ToastType.warning:
        return Colors.black;
      default:
        return Colors.white;
    }
  }

  static Icon? _getIcon(ToastType? type, Color color) {
    switch (type) {
      case ToastType.success:
        return Icon(Icons.check_circle_outline, color: color, size: 20);
      case ToastType.error:
        return Icon(Icons.error, color: color, size: 20);
      case ToastType.warning:
        return Icon(Icons.warning, color: color, size: 20);
      case ToastType.info:
        return Icon(Icons.info, color: color, size: 20);
      default:
        return null;
    }
  }
}
