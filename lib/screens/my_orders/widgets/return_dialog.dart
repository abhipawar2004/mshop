import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/utils/widgets/custom_button.dart';
import 'package:hyper_local/utils/widgets/custom_textfield.dart';
import 'package:hyper_local/utils/widgets/custom_toast.dart';
import 'package:hyper_local/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/theme.dart';
import '../../../utils/widgets/dashed_container.dart';
import '../bloc/return_order_item/return_order_item_bloc.dart';
import '../model/order_detail_model.dart';

class ReturnItemsDialog extends StatefulWidget {
  final List<OrderItems> items;
  final String orderSlug;
  final bool isDelivered;

  const ReturnItemsDialog({
    super.key,
    required this.items,
    required this.orderSlug,
    required this.isDelivered,
  });

  @override
  State<ReturnItemsDialog> createState() => _ReturnItemsDialogState();
}

class _ReturnItemsDialogState extends State<ReturnItemsDialog> {
  OrderItems? _selectedItem;

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 50.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(context),
          Expanded(
            child: _selectedItem == null
                ? _buildListView()
                : returnForm(),
          ),

          if(_selectedItem != null)
            _footerActions()
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = _selectedItem == null ? l10n.myOrders : l10n.cancelReturnRequest;
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Row(
        children: [
          Icon(TablerIcons.package_export, color: AppTheme.primaryColor),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: isTablet(context) ? 24 : 16.sp, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // LIST VIEW (first screen)
  // -------------------------------------------------------------------------
  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.all(12.sp),
      itemCount: widget.items.length,
      itemBuilder: (context, i) {
        final item = widget.items[i];
        return _ProductReturnCard(
          item: item,
          onReturn: () => setState(() => _selectedItem = item),
          onCancelItem: () => _confirmCancelItem(item),
          onCancelReturnRequest: () => _confirmCancelReturnRequest(item),
          isDelivered: widget.isDelivered,
        );
      },
    );
  }

  // -------------------------------------------------------------------------
  // FORM VIEW (second screen)
  // -------------------------------------------------------------------------
  final TextEditingController _reasonCtrl = TextEditingController();
  final List<XFile> _images = [];
  bool _submitting = false;

  Future<void> _pickImages() async {
    const int maxImages = 5;
    final remaining = maxImages - _images.length;

    if (remaining <= 0) {
      ToastManager.show(
        context: context,
        message: AppLocalizations.of(context)!.youCanUploadUpToImagesOnly(maxImages),
        type: ToastType.warning,
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final List<XFile> selected = await picker.pickMultiImage(imageQuality: 85);

    if (selected.isNotEmpty) {
      final toAdd = selected.take(remaining).toList();
      setState(() {
        _images.addAll(toAdd);
      });

      if (selected.length > remaining) {
        if(mounted){
          ToastManager.show(
            context: context,
            message: AppLocalizations.of(context)!.onlyMoreImagesAddedMaxLimit(remaining, maxImages),
            type: ToastType.info,
          );
        }
      }
    }
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _submitting = true);
    try {
      context.read<ReturnOrderItemBloc>().add(ReturnOrderItemRequest(
          orderItemId: _selectedItem!.id!,
          reason: _reasonCtrl.text,
        images: _images
      ));
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _confirmCancelItem(OrderItems item) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(AppLocalizations.of(ctx)!.cancelItem),
          content: Text(AppLocalizations.of(ctx)!.areYouSureYouWantToCancelThisItem),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                AppLocalizations.of(ctx)!.no,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(
                AppLocalizations.of(ctx)!.yes,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary
                ),
              ),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      if(mounted) {
        context.read<ReturnOrderItemBloc>().add(CancelOrderItem(orderItemId: item.id!));
        Navigator.pop(context);
      }

    }
  }

  Future<void> _confirmCancelReturnRequest(OrderItems item) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(AppLocalizations.of(ctx)!.cancelReturnRequest),
          content: Text(AppLocalizations.of(ctx)!.areYouSureYouWantToCancelThisReturnRequest),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                AppLocalizations.of(ctx)!.no,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(
                AppLocalizations.of(ctx)!.yes,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary
                ),
              ),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      if(mounted){
        context.read<ReturnOrderItemBloc>().add(CancelReturnRequest(orderItemId: item.id!));
        Navigator.pop(context);
      }

    }
  }

  Widget returnForm () {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _productHeader(_selectedItem!),
          SizedBox(height: 12.h),
          _reasonField(),
          SizedBox(height: 12.h),
          _imagesSection(),
        ],
      ),
    );
  }

  Widget _productHeader(OrderItems item) {
    final String? imageUrl = item.product?.image;
    final String title = item.title ?? AppLocalizations.of(context)!.product;
    final String qty = item.quantity.toString();
    final String price = item.price!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: SizedBox(
            width: 72.w,
            height: 72.w,
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(imageUrl, fit: BoxFit.cover)
                : Container(
              color: Colors.grey[200],
              child: Icon(Icons.image, color: Colors.grey[500]),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 4.h),
              Text('${AppLocalizations.of(context)!.quantity}: $qty', style: TextStyle(fontSize: 12.sp)),
              Text('${AppLocalizations.of(context)!.price}: ₹$price', style: TextStyle(fontSize: 12.sp)), 
            ],
          ),
        ),
      ],
    );
  }

  Widget _reasonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Text(l10n.reasonForReturn, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600));
          },
        ),
        SizedBox(height: 8),
        Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return CustomTextFormField(
              controller: _reasonCtrl,
              hintText: l10n.describeTheIssue,
              maxLines: 4,
            );
          },
        ),
      ],
    );
  }

  Widget _imagesSection() {
    const int maxImages = 5;
    const String allowedExtensions = 'JPG, JPEG, PNG';
    const String maxSizePerImage = '5 MB';

    final int selectedCount = _images.length;
    final bool canAddMore = selectedCount < maxImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + Counter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upload images',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              '$selectedCount / $maxImages',
              style: TextStyle(
                fontSize: 11.sp,
                color: selectedCount == maxImages
                    ? Colors.red.shade600
                    : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),

        // Dashed Container
        DashedContainer(
          radius: 10.r,
          strokeWidth: 1.5,
          dashWidth: 6,
          dashGap: 4,
          color: AppTheme.primaryColor.withValues(alpha: 0.6),
          padding: EdgeInsets.all(12.w),
          child: _images.isEmpty
              ? _buildEmptyState()
              : _buildImageGridWithAddButton(canAddMore),
        ),

        // File restrictions note (always visible)
        Padding(
          padding: EdgeInsets.only(top: 6.h, left: 2.w),
          child: Text(
            '• Max $maxImages images • $allowedExtensions • $maxSizePerImage per image',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey[600],
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

// Empty State
  Widget _buildEmptyState() {
    return InkWell(
      onTap: _pickImages,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 22.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.6),
              size: 32.sp,
            ),
            SizedBox(height: 10.h),
            Text(
              'Tap to upload photos',
              style: TextStyle(
                fontSize: 13.sp,
                color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Help us understand your experience',
              style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

// Grid with Images + Add Button
  Widget _buildImageGridWithAddButton(bool canAddMore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            // Selected Images
            for (int i = 0; i < _images.length; i++)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.file(
                      File(_images[i].path),
                      width: 76.w,
                      height: 76.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: InkWell(
                      onTap: () => _removeImage(i),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8.r),
                            bottomLeft: Radius.circular(8.r),
                          ),
                        ),
                        padding: EdgeInsets.all(4.w),
                        child: const Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

            // Add More Button (only if limit not reached)
            if (canAddMore)
              SizedBox(
                width: 76.w,
                height: 76.w,
                child: OutlinedButton(
                  onPressed: _pickImages,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.6), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Icon(Icons.add, size: 28.sp, color: AppTheme.primaryColor),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _footerActions() {
    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: _submitting ? null : () {
                setState(() {
                  _selectedItem = null;
                  _reasonCtrl.clear();
                  _images.clear();
                });
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? SizedBox(
                height: 18.h,
                width: 18.h,
                child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : Text(AppLocalizations.of(context)!.submitReturn, style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. PRODUCT CARD (used in list & in form)
// ─────────────────────────────────────────────────────────────────────────────
class _ProductReturnCard extends StatelessWidget {
  final OrderItems item;
  final VoidCallback onReturn;
  final VoidCallback onCancelItem;
  final VoidCallback onCancelReturnRequest;
  final bool isDelivered;

  const _ProductReturnCard({
    required this.item,
    required this.onReturn,
    required this.onCancelItem,
    required this.onCancelReturnRequest,
    required this.isDelivered,
  });

  @override
  Widget build(BuildContext context) {

    // Get status message and color
    final status = getItemStatus(item);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(isTablet(context) ? 8.h  : 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _image(context),
              SizedBox(width: 12.w),
              Expanded(child: _details(context)),
              SizedBox(width: 12.w),
              _actionButton(context),
            ],
          ),

          SizedBox(height: 12.h),

          // 1. Non-cancellable / Non-returnable warnings
          if (item.status != 'delivered' && item.product!.isCancelable == false)
            _warningText(AppLocalizations.of(context)!.thisProductIsNotCancelable, context)
          else if (item.product!.isReturnable == false)
            _warningText(AppLocalizations.of(context)!.thisProductIsNotReturnable, context),

          // 2. Dynamic status message (cancelled, return in progress, refunded, etc.)
          if (status.message != null) ...[
            if (item.product!.isCancelable == false || item.product!.isReturnable == false)
              SizedBox(height: 8.h),
            _statusMessage(status, context),
          ],

          // 3. Cancel Return Request button (only when applicable)
          if (_canCancelReturnRequest())
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onCancelReturnRequest,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(color: Theme.of(context).colorScheme.error),
                  ),
                  child: Text(AppLocalizations.of(context)!.cancelReturnRequest),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context) {
    // Show "Return" button
    if (isDelivered &&
        item.product!.isReturnable == true &&
        (item.returns == null || item.returns!.isEmpty)) {
      return CustomButton(
        onPressed: onReturn,
        child: Text(AppLocalizations.of(context)!.returnButton, style: const TextStyle(color: Colors.white)),
      );
    }

    // Show "Cancel Item" button (before delivery)
    if (!isDelivered &&
        item.product!.isCancelable == true &&
        item.status != 'cancelled') {
      return CustomButton(
        onPressed: onCancelItem,
        child: Text(AppLocalizations.of(context)!.cancelItem),
      );
    }

    return const SizedBox.shrink();
  }

  bool _canCancelReturnRequest() {
    if (item.returns == null || item.returns!.isEmpty) return false;
    final r = item.returns!.first;
    return r.returnStatus == 'requested' ||
        (r.returnStatus != 'seller_approved' && r.returnStatus != 'cancelled' &&
            (r.pickupStatus == null || r.pickupStatus == 'pending'));
  }

  Widget _warningText(String text, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(8.r)
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: isTablet(context) ? 10.sp : 16.sp, color: AppTheme.errorColor),
            SizedBox(width: 6.w),
            Text(
              text,
              style: TextStyle(
                color: AppTheme.errorColor,
                fontSize: isTablet(context) ? 18 : 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusMessage(ItemStatus status, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8.r)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(status.icon, size: isTablet(context) ? 11.sp : 18.sp, color: status.color),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              status.message!,
              style: TextStyle(
                color: status.color,
                fontSize: isTablet(context) ? 18.5 : 13.5.sp,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _image(BuildContext context) {
    final url = item.product?.image;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: SizedBox(
        width: isTablet(context) ? 50.h : 60.h,
        height: isTablet(context) ? 50.h : 60.h,
        child: url != null && url.isNotEmpty
            ? Image.network(url, fit: BoxFit.cover)
            : Container(
          color: Colors.grey[200],
          child: Icon(Icons.image, color: Colors.grey[500]),
        ),
      ),
    );
  }

  Widget _details(BuildContext context) {
    final title = item.title ?? 'Product';
    final qty = item.quantity ?? 1;
    final price = item.price ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
            TextStyle(fontSize: isTablet(context) ? 18 : 12.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 4.h),
        Text('${AppLocalizations.of(context)!.qty}: $qty', style: TextStyle(fontSize: isTablet(context) ? 16 : 10.sp)),
        Text('${AppConstant.currency}$price', style: TextStyle(fontSize: isTablet(context) ? 16 : 10.sp)),
      ],
    );
  }
}