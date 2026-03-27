/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/config/constant.dart';
import '../../../utils/widgets/price_utils.dart';

class PriceRowWidget extends StatelessWidget {
  final double originalPrice;
  final double? salePrice;
  final double? fontSize;
  final double? originalFontSize;
  final double? discountFontSize;
  final FontWeight? fontWeight;
  final Color? priceColor;
  final Color? originalPriceColor;
  final Color? discountBackgroundColor;
  final Color? discountTextColor;

  const PriceRowWidget({
    super.key,
    required this.originalPrice,
    this.salePrice,
    this.fontSize,
    this.originalFontSize,
    this.discountFontSize,
    this.fontWeight,
    this.priceColor,
    this.originalPriceColor,
    this.discountBackgroundColor,
    this.discountTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePrice = salePrice ?? originalPrice;
    final hasDiscount = PriceUtils.hasDiscount(originalPrice, effectivePrice);
    final discountPercentage = hasDiscount
        ? PriceUtils.calculateDiscountPercentage(originalPrice, effectivePrice)
        : 0;

    return Row(
      children: [
        // Current/Sale Price
        Text(
          PriceUtils.formatPrice(effectivePrice),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),

        if (hasDiscount) ...[
          const SizedBox(width: 8),
          // Original Price (crossed out)
          Text(
            PriceUtils.formatPrice(originalPrice),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: originalPriceColor ?? Colors.grey.shade600,
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.grey.shade600,
              decorationThickness: 1.5,
            ),
          ),
          const SizedBox(width: 8),
          // Discount Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: Text(
              '$discountPercentage% OFF',
              style: TextStyle(
                fontSize: isTablet(context) ? 14 : 10.sp,
                fontWeight: FontWeight.w400,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
*/



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/config/constant.dart';
import '../../../utils/widgets/price_utils.dart';

class PriceRowWidget extends StatelessWidget {
  final double originalPrice;
  final double? salePrice;
  final double? fontSize;
  final double? originalFontSize;
  final double? discountFontSize;
  final FontWeight? fontWeight;
  final Color? priceColor;
  final Color? originalPriceColor;
  final Color? discountBackgroundColor;
  final Color? discountTextColor;

  const PriceRowWidget({
    super.key,
    required this.originalPrice,
    this.salePrice,
    this.fontSize,
    this.originalFontSize,
    this.discountFontSize,
    this.fontWeight,
    this.priceColor,
    this.originalPriceColor,
    this.discountBackgroundColor,
    this.discountTextColor,
  });

  @override
  Widget build(BuildContext context) {
    // ────────────────────────────────────────────────
    // Decide what is the "real" displayed price
    // ────────────────────────────────────────────────
    final displayPrice = salePrice != null && salePrice! > 0 ? salePrice! : originalPrice;

    // Only show discount UI if there's a meaningful discount
    final hasRealDiscount = salePrice != null &&
        salePrice! > 0 &&
        salePrice! < originalPrice &&
        (originalPrice - salePrice!).abs() > 0.01; // avoid floating-point noise

    final discountPercentage = hasRealDiscount
        ? PriceUtils.calculateDiscountPercentage(originalPrice, salePrice!)
        : 0;

    // ────────────────────────────────────────────────
    // Build UI
    // ────────────────────────────────────────────────
    return Row(
      mainAxisSize: MainAxisSize.min,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // Main (effective) price ─ always shown
        Text(
          PriceUtils.formatPrice(displayPrice),
          style: TextStyle(
            fontSize: 18,
            fontWeight: fontWeight ?? FontWeight.bold,
            color: priceColor ?? Theme.of(context).colorScheme.tertiary,
            letterSpacing: 0.2,
          ),
        ),

        // Only show crossed price + badge when there is a real discount
        if (hasRealDiscount) ...[
          const SizedBox(width: 8),

          // Original (struck-through) price
          Text(
            PriceUtils.formatPrice(originalPrice),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: originalPriceColor ?? Colors.grey.shade600,
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.grey.shade600,
              decorationThickness: 1.5,
            ),
          ),

          const SizedBox(width: 8),

          // Discount badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: discountBackgroundColor ?? Colors.red.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              '$discountPercentage% OFF',
              style: TextStyle(
                fontSize: isTablet(context) ? 14 : 10.sp,
                fontWeight: FontWeight.w500,
                color: discountTextColor ?? Colors.red.shade700,
                height: 1.1,
              ),
            ),
          ),
        ],
      ],
    );
  }
}