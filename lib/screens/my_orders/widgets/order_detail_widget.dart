import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hyper_local/utils/widgets/date_formatter.dart';
import 'package:hyper_local/l10n/app_localizations.dart';

import '../../../config/constant.dart';

class OrderDetailCard extends StatelessWidget {
  final String orderId;
  final String paymentMethod;
  final String deliveryAddress;
  final String orderDate;

  const OrderDetailCard({
    super.key,
    required this.orderId,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.orderDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              AppLocalizations.of(context)!.orderDetails,
              style: TextStyle(
                fontSize: isTablet(context) ? 24 : 18.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 5.h),
            Divider(),
            SizedBox(height: 5.h),

            // Order ID
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.orderId,
                  style: TextStyle(
                    fontSize: isTablet(context) ? 16 : 11.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      orderId,
                      style: TextStyle(
                        fontSize: isTablet(context) ? 18 : 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: orderId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.orderIdCopied),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(8.r),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Icon(
                          TablerIcons.copy,
                          size: isTablet(context) ? 6.sp : 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // Payment
            _simpleLabelValue(
              context,
              label: AppLocalizations.of(context)!.payment,
              value: paymentMethod == 'cod' ? AppLocalizations.of(context)!.cashOnDelivery : paymentMethod == 'wallet' ? AppLocalizations.of(context)!.wallet : AppLocalizations.of(context)!.paidOnline,
            ),
            SizedBox(height: 10.h),

            // Deliver to
            _simpleLabelValue(
              context,
              label: AppLocalizations.of(context)!.deliverTo,
              value: deliveryAddress,
            ),
            SizedBox(height: 10.h),

            // Order placed
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.orderPlaced,
                  style: TextStyle(
                    fontSize: isTablet(context) ? 16 : 11.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    AppLocalizations.of(context)!.orderPlacedOn(DateFormatter.fullDate(orderDate)),
                    style: TextStyle(
                      fontSize: isTablet(context) ? 18 : 13.sp,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _simpleLabelValue(
      BuildContext context, {
        required String label,
        required String value,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet(context) ? 16 : 11.sp,
            color: Colors.grey[600],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isTablet(context) ? 18 : 13.sp,
            ),
          ),
        ),
      ],
    );
  }
}