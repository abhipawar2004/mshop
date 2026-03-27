import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/constant.dart';
import '../../config/theme.dart';

class DeliveryTimeWidget extends StatelessWidget {
  final String time;
  const DeliveryTimeWidget({
    super.key,
    required this.time
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.h,
      alignment: Alignment.topLeft,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          left: 3,
          right: 3,
          top: 1,
          bottom: 2
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.deliveryTimeWidgetColor,
              AppTheme.deliveryTimeWidgetColor,
              AppTheme.deliveryTimeWidgetColor,
              AppTheme.deliveryTimeWidgetColor,
              AppTheme.deliveryTimeWidgetColor,
              AppTheme.deliveryTimeWidgetColor.withValues(alpha: 0.1),
              AppTheme.deliveryTimeWidgetColor.withValues(alpha: 0.01),
              Colors.transparent,
            ],
            begin: Directionality.of(context) == TextDirection.rtl
                ? Alignment.topRight
                : Alignment.topLeft,
            end: Directionality.of(context) == TextDirection.rtl
                ? Alignment.bottomLeft
                : Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/icons/clock.png',
              height: isTablet(context) ? 18 : 12,
            ),
            const SizedBox(width: 3),
            Text(
              '$time min',
              style: TextStyle(
                color: Color(0xFF004487),
                fontSize: isTablet(context) ? 16 : 10,
                fontFamily: AppTheme.fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}