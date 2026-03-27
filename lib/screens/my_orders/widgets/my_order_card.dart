import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/utils/widgets/custom_button.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';

import '../../../config/constant.dart';

class OrderDeliveryCard extends StatelessWidget {
  final String status;
  final String dateTime;
  final List<String> productImages;
  final VoidCallback onRateOrder;
  final VoidCallback onTrackOrder;
  final bool isDelivered;
  final bool isDeliveryBoyAssigned;
  final String orderSlug;

  const OrderDeliveryCard({
    super.key,
    required this.status,
    required this.dateTime,
    required this.productImages,
    required this.onRateOrder,
    required this.onTrackOrder,
    required this.isDelivered,
    required this.isDeliveryBoyAssigned,
    required this.orderSlug,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    color: _getStatusColor(status),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  dateTime,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            // Divider above product images
            if (productImages.isNotEmpty) const Divider(),
            const SizedBox(height: 15),

            // Product images - Horizontal ListView
            if (productImages.isNotEmpty)
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < productImages.length - 1 ? 15 : 0,
                      ),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomImageContainer(
                            imagePath:  productImages[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 15),
            // Divider below product images
            if (productImages.isNotEmpty) const Divider(),
            const SizedBox(height: 10),

            if(isDelivered)
              GestureDetector(
              onTap: onRateOrder,
              child: SizedBox(
                height: 45,
                width: double.infinity,
                child: CustomButton(
                  onPressed: onRateOrder,
                  child: Text(
                    'Rate Order',
                    style: TextStyle(
                      fontSize: isTablet(context) ? 18 : 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
            else if(!isDelivered && isDeliveryBoyAssigned)
              GestureDetector(
                onTap: onTrackOrder,
                child: SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: CustomButton(
                    onPressed: onTrackOrder,
                    child: Text(
                      'Track your order',
                      style: TextStyle(
                        fontSize: isTablet(context) ? 18 : 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            else
              Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.05),
                  border: Border.all(
                    color: AppTheme.primaryColor
                  ),
                  borderRadius: BorderRadius.circular(8)
                ),
                alignment: Alignment.center,
                child: Text(
                  removeUnderscores(status),
                  style: TextStyle(
                    fontSize: isTablet(context) ? 18 : 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }


  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'processing':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}