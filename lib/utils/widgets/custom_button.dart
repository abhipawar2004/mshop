import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;                     // NEW: simple text version
  final Widget? child;                  // keep old child support
  final VoidCallback? onPressed;        // nullable when disabled
  final bool isDisabled;                // existing
  final bool isLoading;                 // NEW: show spinner
  final double? height;                 // optional styling
  final double? width;                  // optional styling

   CustomButton({
    super.key,
    this.text = '',
    this.child,
    this.onPressed,
    this.isDisabled = false,
    this.isLoading = false,
    this.height,
    this.width,
  }) : assert(text.isNotEmpty || child != null,
  'Either text or child must be provided');

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = (isDisabled || isLoading) ? null : onPressed;

    return SizedBox(
      height: height ?? (isTablet(context) ? 40.h : 48),
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          disabledBackgroundColor: AppTheme.primaryColor.withValues(alpha: 0.5),
        ),
        onPressed: effectiveOnPressed,
        child: isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : (child ?? Text(text)),
      ),
    );
  }
}