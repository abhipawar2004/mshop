import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/screens/cart_page/bloc/promo_code/promo_code_bloc.dart';
import 'package:hyper_local/screens/cart_page/bloc/promo_code/promo_code_state.dart';
import 'package:hyper_local/utils/widgets/animated_button.dart';

import '../../../config/constant.dart';
import '../../../utils/widgets/custom_dotted_divider.dart';
import '../../../l10n/app_localizations.dart';

class BillSummaryWidget extends StatelessWidget {
  final double itemsOriginalPrice;
  final double itemsDiscountedPrice;
  final double itemsSavings;
  final double deliveryChargeOriginal;
  final double handlingCharge;
  final double grandTotal;
  final double totalSavings;
  final double? perStoreDropOffFees;
  final bool? isFromOrderDetail;
  final VoidCallback? downloadInvoice;
  final String? promoCode;
  final double? promoDiscount;
  final String? promoError;
  final VoidCallback? removeCoupon;
  final String? promoMode;
  final String? discountAmount;
  final bool? isRushDelivery;

  const BillSummaryWidget({
    super.key,
    required this.itemsOriginalPrice,
    required this.itemsDiscountedPrice,
    required this.itemsSavings,
    required this.deliveryChargeOriginal,
    required this.handlingCharge,
    required this.grandTotal,
    required this.totalSavings,
    this.perStoreDropOffFees,
    this.isFromOrderDetail = false,
    this.downloadInvoice,
    this.promoCode,
    this.promoDiscount,
    this.promoError,
    this.removeCoupon,
    this.promoMode,
    this.discountAmount,
    this.isRushDelivery,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currency = AppConstant.currency;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 12.0.w,
          right: 12.0.w,
          top: 12.h,
          bottom: 12.h
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.billDetails ?? 'Bill details',
              style: TextStyle(
                fontSize: isTablet(context) ? 24 : 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            const SizedBox(height: 20),

            // Items total row
            _buildItemRow(
              context: context,
              icon: Icons.receipt_long,
              label: l10n?.itemsTotal ?? 'Items total',
              originalPrice: itemsOriginalPrice >= 0 ? '$currency${itemsOriginalPrice.toStringAsFixed(2)}' : null,
              finalPrice: '$currency${itemsDiscountedPrice.toStringAsFixed(2)}',
              hasDiscount: itemsOriginalPrice >= 0 ? false : true,
            ),
            const SizedBox(height: 16),

            // Delivery charge row
            _buildItemRow(
              context: context,
              icon: Icons.delivery_dining,
              label: l10n?.deliveryCharge ?? 'Delivery charge',
              originalPrice: deliveryChargeOriginal.toStringAsFixed(2),
              finalPrice: deliveryChargeOriginal <= 0 ? (l10n?.free ?? 'FREE') : '$currency${deliveryChargeOriginal.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 16),

            // Rush Delivery Indicator
            if (isRushDelivery == true) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.1),
                      AppTheme.primaryColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.bolt,
                      size: 18,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      l10n?.rushDeliveryActive ?? 'Rush Delivery Active',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        l10n?.on ?? 'ON',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (perStoreDropOffFees != null)
              _buildItemRow(
                context: context,
                icon: Icons.shopping_bag,
                label: l10n?.perStoreDropOffFees ?? 'Per store drop off fees',
                finalPrice: perStoreDropOffFees! <= 0 ? (l10n?.free ?? 'FREE') : '$currency${perStoreDropOffFees!.toStringAsFixed(2)}',
              ),

            if (perStoreDropOffFees != null) const SizedBox(height: 16),

            // Handling charge row
            _buildItemRow(
              context: context,
              icon: Icons.shopping_bag,
              label: l10n?.handlingCharge ?? 'Handling charge',
              finalPrice: handlingCharge <= 0 ? (l10n?.free ?? 'FREE') : '$currency${handlingCharge.toStringAsFixed(2)}',
            ),

            const SizedBox(height: 16),
            /// For Cart Bill Promo Preview
            if(isFromOrderDetail == false) ...[
              // Enhanced Promo code section
              if (promoCode != null && promoCode!.isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _getPromoGradientColors(promoMode),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getPromoBorderColor(promoMode),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _getPromoIconColor(promoMode),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getPromoIcon(promoMode),
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getPromoTitle(promoMode, l10n),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getPromoTextColor(promoMode),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      promoCode!.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: _getPromoMainTextColor(promoMode),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(width: 8),

                                  ],
                                ),
                                SizedBox(height: 4),
                                if (promoMode != null && discountAmount != null)
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _getPromoBadgeColor(promoMode),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      _getDiscountText(promoMode!, discountAmount!, currency),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '-$currency${(promoDiscount ?? 0).toInt()}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _getPromoMainTextColor(promoMode),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<PromoCodeBloc, PromoCodeState>(
                  builder: (BuildContext context, PromoCodeState state) {
                    return AnimatedButton(
                      onTap: removeCoupon,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.shade300,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.red.shade700,
                            ),
                            SizedBox(width: 6),
                            Text(
                              l10n?.removeCoupon ?? 'Remove Coupon',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Promo error message (if present)
              if (promoError != null && promoError!.isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.red.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 18,
                        color: Colors.red.shade700,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          promoError!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],

            /// For Order Detail Page Promo Preview
            if(isFromOrderDetail == true) ...[
              if(promoCode != null && promoCode!.isNotEmpty && promoDiscount != null && promoDiscount! >= 0.0) ...[
                _buildItemRow(
                  context: context,
                  icon: TablerIcons.discount_filled,
                  label: l10n?.promoDiscount ?? 'Promo Discount',
                  finalPrice: promoDiscount! <= 0 ? (l10n?.free ?? 'FREE') : '-$currency${promoDiscount!.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 16),
              ],
            ],


            // Dotted line separator
            buildDottedLine(context),
            const SizedBox(height: 12),

            // Grand total row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n?.grandTotal ?? 'Grand total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${AppConstant.currency}${grandTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            if (isFromOrderDetail!) ...[
              const SizedBox(height: 10),
              Divider(),
              GestureDetector(
                onTap: downloadInvoice,
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            TablerIcons.download,
                            size: 20,
                            color: AppTheme.primaryColor,
                          ),
                          SizedBox(width: 10),
                          Text(
                            l10n?.downloadInvoice ?? 'Download Invoice',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  String _getDiscountText(String promoMode, String discountAmount, String currency) {
    final mode = promoMode.toLowerCase();
    if (mode == 'percentage' || mode == 'percent') {
      return '$discountAmount% OFF';
    } else if (mode == 'cashback') {
      return '$currency$discountAmount CASHBACK';
    } else if (mode == 'instant') {
      return '$currency$discountAmount INSTANT';
    } else {
      return '$currency$discountAmount OFF';
    }
  }

  List<Color> _getPromoGradientColors(String? promoMode) {
    final mode = promoMode?.toLowerCase() ?? 'instant';
    switch (mode) {
      case 'cashback':
        return [
          Colors.purple.shade50,
          Colors.purple.shade100.withValues(alpha: 0.3),
        ];
      case 'instant':
        return [
          Colors.green.shade50,
          Colors.green.shade100.withValues(alpha: 0.3),
        ];
      default:
        return [
          Colors.blue.shade50,
          Colors.blue.shade100.withValues(alpha: 0.3),
        ];
    }
  }

  Color _getPromoBorderColor(String? promoMode) {
    final mode = promoMode?.toLowerCase() ?? 'instant';
    switch (mode) {
      case 'cashback':
        return Colors.purple.shade300;
      case 'instant':
        return Colors.green.shade300;
      default:
        return Colors.blue.shade300;
    }
  }

  Color _getPromoIconColor(String? promoMode) {
    final mode = promoMode?.toLowerCase() ?? 'instant';
    switch (mode) {
      case 'cashback':
        return Colors.purple.shade600;
      case 'instant':
        return Colors.green;
      default:
        return Colors.blue.shade600;
    }
  }

  IconData _getPromoIcon(String? promoMode) {
    final mode = promoMode?.toLowerCase() ?? 'instant';
    switch (mode) {
      case 'cashback':
        return Icons.account_balance_wallet;
      case 'instant':
        return Icons.check;
      default:
        return Icons.local_offer;
    }
  }

  String _getPromoTitle(String? promoMode, AppLocalizations? l10n) {
    final mode = promoMode?.toLowerCase() ?? 'instant';
    switch (mode) {
      case 'cashback':
        return l10n?.cashbackApplied ?? 'Cashback Applied';
      case 'instant':
        return l10n?.instantDiscountApplied ?? 'Instant Discount Applied';
      default:
        return l10n?.promoApplied ?? 'Promo Applied';
    }
  }

  Color _getPromoTextColor(String? promoMode) {
    final mode = promoMode?.toLowerCase() ?? 'instant';
    switch (mode) {
      case 'cashback':
        return Colors.purple.shade700;
      case 'instant':
        return Colors.green.shade700;
      default:
        return Colors.blue.shade700;
    }
  }

  Color _getPromoMainTextColor(String? promoMode) {
    final mode = promoMode?.toLowerCase() ?? 'instant';
    switch (mode) {
      case 'cashback':
        return Colors.purple.shade900;
      case 'instant':
        return Colors.green.shade900;
      default:
        return Colors.blue.shade900;
    }
  }

  Color _getPromoBadgeColor(String? promoMode) {
    final mode = promoMode?.toLowerCase() ?? 'instant';
    switch (mode) {
      case 'cashback':
        return Colors.purple.shade700;
      case 'instant':
        return Colors.green.shade700;
      default:
        return Colors.blue.shade700;
    }
  }

  Widget _buildItemRow({
    required IconData icon,
    required String label,
    required BuildContext context,
    String? additionalInfo,
    String? originalPrice,
    required String finalPrice,
    bool hasDiscount = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              if (additionalInfo != null)
                Text(
                  additionalInfo,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
        Row(
          children: [
            if (hasDiscount && originalPrice != null) ...[
              Text(
                originalPrice,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.3),
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              finalPrice,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}