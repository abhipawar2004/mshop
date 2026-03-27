import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../../config/constant.dart';
import '../../../config/theme.dart';

class OrderNoteDisplayWidget extends StatelessWidget {
  final String? orderNote;
  final EdgeInsets? margin;

  const OrderNoteDisplayWidget({
    super.key,
    this.orderNote,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {

    // If no note, show nothing (or optional placeholder)
    if (orderNote == null || orderNote!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode(context)
            ? Theme.of(context).colorScheme.surface
            : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                TablerIcons.note,
                size: 20.sp,
                color: AppTheme.primaryColor,
              ),
              SizedBox(width: 10.w),
              Text(
                "Order Note",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode(context) ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // Note content
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDarkMode(context)
                  ? Colors.grey.shade900.withValues(alpha: 0.4)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              orderNote!.trim(),
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.5,
                color: isDarkMode(context) ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}