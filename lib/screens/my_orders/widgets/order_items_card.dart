import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../product_detail_page/view/product_detail_page.dart';
import 'package:hyper_local/l10n/app_localizations.dart';
import '../model/order_detail_model.dart';

Map<String, List<OrderItems>> groupCartItemsByStore(List<OrderItems> items) {
  Map<String, List<OrderItems>> groupedItems = {};

  for (var item in items) {
    String storeKey = item.store?.name ?? 'Unknown Store';
    if (!groupedItems.containsKey(storeKey)) {
      groupedItems[storeKey] = [];
    }
    groupedItems[storeKey]!.add(item);
  }
  return groupedItems;
}


class OrderItemsCard extends StatelessWidget {
  final List<OrderItems> items;
  final String totalItems;
  final VoidCallback? onAddMoreItems;
  final Color? priceColor;
  final Color? originalPriceColor;

  const OrderItemsCard({
    super.key,
    required this.items,
    required this.totalItems,
    this.onAddMoreItems,
    this.priceColor,
    this.originalPriceColor,
  });

  @override
  Widget build(BuildContext context) {
    final groupedItems = groupCartItemsByStore(items);
    return Column(
      children: groupedItems.entries.map((entry) {
        final storeName = entry.key;
        final storeItems = entry.value;

        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: StoreCartSection(
            storeName: storeName,
            items: storeItems,
            deliveryTime: totalItems,
            onAddMoreItems: onAddMoreItems,
            priceColor: priceColor,
            originalPriceColor: originalPriceColor,
          ),
        );
      }).toList(),
    );
  }
}


class StoreCartSection extends StatelessWidget {
  final String storeName;
  final List<OrderItems> items;
  final String deliveryTime;
  final VoidCallback? onAddMoreItems;
  final Color? priceColor;
  final Color? originalPriceColor;

  const StoreCartSection({
    super.key,
    required this.storeName,
    required this.items,
    required this.deliveryTime,
    this.onAddMoreItems,
    this.priceColor,
    this.originalPriceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStoreHeader(context),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: _buildCartItem(context, item),
        )),
      ],
    );
  }

  Widget _buildStoreHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                storeName,
                style: TextStyle(
                      fontSize: isTablet(context) ? 24 : 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppTheme.fontFamily,
                    ),
              ),
            ],
          ),
          Text(
            '${items.length} Product${items.length != 1 ? 's' : ''}',
            style: TextStyle(
                  fontSize: isTablet(context) ? 18 : 12.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppTheme.fontFamily,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, OrderItems item) {

    final status = getItemStatus(item);

    return OpenContainer(
      clipBehavior: Clip.antiAlias,
      transitionDuration: const Duration(milliseconds: 500),
      transitionType: ContainerTransitionType.fade,
      closedElevation: 0,
      openElevation: 0,
      closedShape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      openShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      closedColor: Colors.transparent,
      openColor: Colors.transparent,
      tappable: true,
      useRootNavigator: true,
      openBuilder: (context, closeContainer) {
        return ProductDetailPage(
          productSlug: item.product!.slug!,
          initialData: ProductInitialData(
            title: item.product!.name!,
            mainImage: item.product!.image!,
          ),
          closeContainer: closeContainer,
        );
      },
      closedBuilder: (context, openContainer) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: 0.5,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main row with image, info, price
              Opacity(
                opacity: 1.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    _buildProductImage(item.product!.image!, item.product!.id!),
                    SizedBox(width: 10.w),

                    // Product Name and Details
                    Expanded(child: _buildProductInfo(item, context)),
                    SizedBox(width: 10.w),

                    // Price Section
                    _buildPriceSection(item, context),
                  ],
                ),
              ),

              SizedBox(height: 8,),

              _buildAttachmentsSection(item, context),


              // Status message below (only if applicable)
              if (status.message != null ) ...[
                SizedBox(height: 14.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(8.r)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          status.icon,
                          size: 18.sp,
                          color: status.color,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            status.message!,
                            style: TextStyle(
                              color: status.color,
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }
    );
  }

  Widget _buildProductImage(String imageUrl, int productId) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Hero(
          tag: 'product-image-${productId.hashCode}',
          child: CustomImageContainer(
            imagePath:  imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(OrderItems item, BuildContext context) {
    return SizedBox(
      width: 125.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.product!.name!,
            style: TextStyle(
                fontSize: isTablet(context) ? 18 : 12.sp,
                fontWeight: FontWeight.w500,
                fontFamily: AppTheme.fontFamily
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5,),

          Text(
            item.variant!.title!,
            style: TextStyle(
              fontSize: isTablet(context) ? 16 : 10.sp,
              color: Colors.grey[500],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5,),

          Text(
            'Qty: ${item.quantity}',
            style: TextStyle(
                fontSize: isTablet(context) ? 16 : 10.sp,
                color: Colors.grey[500],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          if(item.product!.requiresOtp == 1)
            Text(
              'OTP: ${item.otp}',
              style: TextStyle(
                  fontSize: isTablet(context) ? 18 : 12.sp,
                  color: Colors.grey[500],
                  fontFamily: AppTheme.fontFamily
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(OrderItems item, BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${AppConstant.currency}${((item.quantity)! * (double.parse(item.price.toString()))).toInt()}',
            style: TextStyle(
              fontSize: isTablet(context) ? 18 : 12.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsSection(OrderItems item, BuildContext context) {
    // Safety check: no attachments or empty
    if (item.attachments == null || item.attachments!.isEmpty) {
      return const SizedBox.shrink();
    }

    // Flatten all URLs from nested list
    final allUrls = item.attachments!
        .where((url) => url.isNotEmpty && url.trim().isNotEmpty)
        .toList();

    if (allUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDarkMode(context)
            ? Colors.grey.shade800.withValues(alpha: 0.4)
            : Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heade
          Row(
            children: [
              Icon(
                TablerIcons.paperclip,
                size: 16.sp,
                color: Colors.grey.shade500,
              ),
              SizedBox(width: 6.w),
              Text(
                'Attachments (${allUrls.length})',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode(context) ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // List of attachments
          ...allUrls.map((url) {
            final isImage = _isImageUrl(url);
            final fileName = _getFileNameFromUrl(url);

            return GestureDetector(
              onTap: () => _openAttachment(url, context),
              child: Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Preview / Icon
                    if (isImage)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: Image.network(
                          url,
                          width: 50.w,
                          height: 50.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildFileIcon(url),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 50.w,
                              height: 50.w,
                              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            );
                          },
                        ),
                      )
                    else
                      _buildFileIcon(url),

                    SizedBox(width: 12.w),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fileName,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            isImage ? 'Image' : _getFileTypeFromUrl(url),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Open icon
                    Icon(
                      TablerIcons.external_link,
                      size: 18.sp,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Helper Functions ─────────────────────────────────────────────────────────

  Widget _buildFileIcon(String url) {
    final ext = _getExtension(url).toLowerCase();

    IconData icon;
    Color color;

    if (ext.contains('pdf')) {
      icon = TablerIcons.file_type_pdf;
      color = Colors.red;
    } else if (['doc', 'docx'].contains(ext)) {
      icon = TablerIcons.file_type_docx;
      color = Colors.blue;
    } else if (['jpg', 'jpeg', 'png', 'gif'].contains(ext)) {
      icon = TablerIcons.photo;
      color = Colors.green;
    } else {
      icon = TablerIcons.file;
      color = Colors.grey;
    }

    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(icon, color: color, size: 28.sp),
    );
  }

  bool _isImageUrl(String url) {
    final ext = _getExtension(url).toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
  }

  String _getExtension(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return '';
    final path = uri.path;
    final dotIndex = path.lastIndexOf('.');
    return dotIndex != -1 ? path.substring(dotIndex + 1) : '';
  }

  String _getFileNameFromUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return 'Attachment';
    final path = uri.pathSegments.last;
    return Uri.decodeComponent(path);
  }

  String _getFileTypeFromUrl(String url) {
    final ext = _getExtension(url).toUpperCase();
    if (ext.isEmpty) return 'File';
    return ext;
  }

  Future<void> _openAttachment(String url, BuildContext context) async {
    try {
      final uri = Uri.parse(url);

      // If it's a remote URL, try to open in browser/external app
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if(context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.cannotOpenFile(url))),
          );
        }
      }
    } catch (e) {
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorOpeningAttachment(e.toString()))),
        );
      }

    }
  }

}