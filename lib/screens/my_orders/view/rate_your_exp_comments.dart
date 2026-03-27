import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/screens/my_orders/bloc/order_detail/order_detail_bloc.dart';
import 'package:hyper_local/screens/my_orders/model/order_detail_model.dart';
import 'package:hyper_local/l10n/app_localizations.dart';
import 'package:hyper_local/screens/product_detail_page/bloc/product_feedback/product_feedback_bloc.dart';
import 'package:hyper_local/utils/widgets/custom_button.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'package:hyper_local/utils/widgets/custom_textfield.dart';
import 'package:hyper_local/utils/widgets/custom_toast.dart';
import 'package:image_picker/image_picker.dart';
import '../../../config/theme.dart';
import '../../../utils/widgets/dashed_container.dart';

class RateYourExpComments extends StatefulWidget {
  final String orderSlug;
  final List<OrderItems> items;
  const RateYourExpComments({
    super.key,
    required this.orderSlug,
    required this.items,
  });

  @override
  State<RateYourExpComments> createState() => _RateYourExpCommentsState();
}

class _RateYourExpCommentsState extends State<RateYourExpComments> {
  final Map<int, double> _ratings = {};
  final Map<int, TextEditingController> _controllers = {};
  final Map<int, TextEditingController> _titleControllers = {};
  final Set<int> _editing = {};
  final Set<int> _submitting = {};
  late List<OrderItems> _items;
  late Set<int> _originalItemIds;
  final Map<int, List<XFile>> _itemImages = {};
  int? _deletedOrderItemId;

  @override
  void initState() {
    super.initState();
    _items = widget.items;
    _originalItemIds = _items.map((item) => item.id!).toSet();
    _initializeControllersForItems(_items);
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    for (var c in _titleControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImagesForItem(int orderItemId) async {
    const int maxImages = 5;
    final currentImages = _itemImages[orderItemId] ?? [];
    final remaining = maxImages - currentImages.length;

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
        _itemImages[orderItemId] = [
          ...currentImages,
          ...toAdd,
        ];
      });

      if (selected.length > remaining) {
        if(mounted) {
          ToastManager.show(
            context: context,
            message: AppLocalizations.of(context)!.onlyMoreImagesAddedMaxLimit(remaining, maxImages),
            type: ToastType.info,
          );
        }
      }
    }
  }

  void _removeImage(int orderItemId, int index) {
    setState(() {
      _itemImages[orderItemId]?.removeAt(index);
      if (_itemImages[orderItemId]?.isEmpty ?? true) {
        _itemImages.remove(orderItemId);
      }
    });
  }

  void _initializeControllersForItems(List<OrderItems> items) {
    for (var item in items) {
      final orderItemId = item.id!;

      // Initialize title controller if not exists
      if (!_titleControllers.containsKey(orderItemId)) {
        final titleController = TextEditingController();
        titleController.addListener(() {
          if (mounted) setState(() {});
        });
        _titleControllers[orderItemId] = titleController;
      }

      // Initialize description controller if not exists
      if (!_controllers.containsKey(orderItemId)) {
        final descriptionController = TextEditingController();
        descriptionController.addListener(() {
          if (mounted) setState(() {});
        });
        _controllers[orderItemId] = descriptionController;
      }

      _ratings.putIfAbsent(orderItemId, () => 0.0);
    }
  }

  void _submitSingle(int orderItemId, int productId, OrderItems item) {
    final rating = _ratings[orderItemId];
    final title = _titleControllers[orderItemId]?.text.trim() ?? '';
    final description = _controllers[orderItemId]?.text.trim() ?? '';
    // Validation: Rating is required
    if (rating == null || rating == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastManager.show(
          context: context,
          message: AppLocalizations.of(context)!.pleaseGiveARating,
          type: ToastType.error,
        );
      });
      return;
    }

    // Validation: Title is required
    if (title.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastManager.show(
          context: context,
          message: AppLocalizations.of(context)!.pleaseEnterATitle,
          type: ToastType.error,
        );
      });
      return;
    }

    final feedbackId = item.userReview?.id;
    final isUpdate = feedbackId != null;

    setState(() {
      _submitting.add(orderItemId);
    });
    final images = _itemImages[orderItemId] ?? [];

    if (isUpdate) {
      context.read<ProductFeedbackBloc>().add(
        UpdateProductFeedback(
          feedbackId: feedbackId,
          title: title,
          description: description,
          rating: rating.toInt(),
          images: images,
        ),
      );
    }
    else {
      context.read<ProductFeedbackBloc>().add(
        AddProductFeedback(
          orderItemId: orderItemId,
          title: title,
          description: description,
          rating: rating.toInt(),
          images: images,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProductFeedbackBloc, ProductFeedbackState>(
          listener: (context, state) {
            if (state is ProductFeedbackLoaded) {
              final wasDelete = _deletedOrderItemId != null;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                ToastManager.show(
                  context: context,
                  message: wasDelete ? AppLocalizations.of(context)!.feedbackDeletedSuccessfully : AppLocalizations.of(context)!.feedbackUpdatedSuccessfully,
                  type: ToastType.success,
                );
              });

              context.read<ProductFeedbackBloc>().add(ResetProductFeedback());

              setState(() {
                if (wasDelete && _deletedOrderItemId != null) {
                  final orderItemId = _deletedOrderItemId!;

                  _ratings[orderItemId] = 0.0;
                  _titleControllers[orderItemId]?.clear();
                  _controllers[orderItemId]?.clear();
                  _itemImages.remove(orderItemId);
                  _editing.remove(orderItemId);
                  _submitting.remove(orderItemId);

                  _deletedOrderItemId = null;
                } else {
                  _editing.clear();
                  _submitting.clear();
                  _itemImages.clear();
                }
              });
            }
            else if (state is ProductFeedbackFailure) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ToastManager.show(
                  context: context,
                  message: state.error,
                  type: ToastType.error,
                );
              });
              setState(() {
                _submitting.clear();
                _deletedOrderItemId = null;
              });

              context.read<ProductFeedbackBloc>().add(ResetProductFeedback());
            }
          },
        ),
        BlocListener<OrderDetailBloc, OrderDetailState>(
          listener: (context, state) {
            if (state is OrderDetailLoaded) {
              setState(() {
                final allItems = state.cartData.first.data?.items ?? [];
                _items = allItems.where((item) => _originalItemIds.contains(item.id)).toList();
                _initializeControllersForItems(_items);
              });
            } else if (state is OrderDetailFailed) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ToastManager.show(
                  context: context,
                  message: AppLocalizations.of(context)!.failedToRefreshOrderDetails,
                  type: ToastType.error,
                );
              });
            }
          },
        ),
      ],
      child: CustomScaffold(
        showViewCart: false,
        title: AppLocalizations.of(context)!.rateYourExperience,
        showAppBar: true,
        body: _items.isEmpty
            ? Center(child: Text(AppLocalizations.of(context)!.noItemsToDisplay))
            : ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];
            final orderItemId = item.id!;
            final productId = item.productId!;

            final shouldShowEditable = _editing.contains(orderItemId) ||
                item.isUserReviewGiven != true;

            return shouldShowEditable
                ? _buildEditableCard(
              imageUrl: item.product?.image ?? '',
              productName: item.variant?.title ?? item.title ?? 'Unknown Product',
              orderItemId: orderItemId,
              productId: productId,
              item: item,
            )
                : _buildReviewedCard(item);
          },
        ),
      ),
    );
  }

  void _editReview(OrderItems item) {
    final orderItemId = item.id!;
    final review = item.userReview;

    if (review == null) return;

    setState(() {
      _ratings[orderItemId] = review.rating?.toDouble() ?? 0.0;
      _titleControllers[orderItemId]!.text = review.title ?? '';
      _controllers[orderItemId]!.text = review.comment ?? '';
      _editing.add(orderItemId);
    });
  }

  void _deleteReview(OrderItems item, BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteReview),
        content: Text(AppLocalizations.of(context)!.thisActionCannotBeUndone),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final feedbackId = item.userReview?.id;
    if (feedbackId == null) return;

    _deletedOrderItemId = item.id;

    if(context.mounted){
      context.read<ProductFeedbackBloc>().add(
        DeleteProductFeedback(feedbackId: feedbackId),
      );
    }
  }

  // --- READ-ONLY CARD ---
// --- READ-ONLY CARD (Already Reviewed) ---
  Widget _buildReviewedCard(OrderItems item) {
    final rating = item.userReview?.rating?.toDouble() ?? 0.0;
    final titleText = item.userReview?.title ?? '';
    final commentText = item.userReview?.comment ?? '';
    final time = item.userReview?.createdAt.toString() ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: isDarkMode(context) ? Theme.of(context).colorScheme.onSecondary : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CustomImageContainer(
                  imagePath: item.product?.image ?? '',
                  width: isTablet(context) ? 50.h : 60.w,
                  height: isTablet(context) ? 50.h : 60.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.variant?.title ?? item.title ?? 'Unknown Product',
                      style: TextStyle(
                          fontSize: isTablet(context) ? 24 : 16.sp, fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: rating,
                          itemCount: 5,
                          itemSize: isTablet(context) ? 16.h : 18.w,
                          itemBuilder: (context, _) =>
                          Icon(AppTheme.ratingStarIconFilled, color: AppTheme.ratingStarColor),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${rating.toInt()} star${rating > 1 ? 's' : ''}',
                          style: TextStyle(
                              fontSize: isTablet(context) ? 18 : 13.sp, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_outlined,),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.edit),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: AppTheme.errorColor),
                        SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: AppTheme.errorColor)),
                      ],
                    ),
                  ),
                ],
                onSelected: (String value) {
                  switch (value) {
                    case 'edit':
                      _editReview(item);
                      break;
                    case 'delete':
                      _deleteReview(item, context);
                      break;
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                offset: const Offset(0, 48),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Title display
          if (titleText.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.h),
              decoration: BoxDecoration(
                color: isDarkMode(context) ? Theme.of(context).colorScheme.surface : Colors.grey[50],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: isDarkMode(context) ? Theme.of(context).colorScheme.outlineVariant : Colors.grey[300]!),
              ),
              child: Text(
                titleText,
                style: TextStyle(fontSize: isTablet(context) ? 20 : 14.sp, fontWeight: FontWeight.w600),
              ),
            ),
          if (titleText.isNotEmpty && commentText.isNotEmpty)
            SizedBox(height: 8.h),
          // Description display
          if (commentText.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.h),
              decoration: BoxDecoration(
                color: isDarkMode(context) ? Theme.of(context).colorScheme.surface : Colors.grey[50],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: isDarkMode(context) ? Theme.of(context).colorScheme.outlineVariant : Colors.grey[300]!),
              ),
              child: Text(
                commentText,
                style: TextStyle(fontSize: isTablet(context) ? 20 : 14.sp,),
              ),
            ),
          // Review images display
          if (item.userReview?.reviewImages != null && item.userReview!.reviewImages!.isNotEmpty) ...[
            if (titleText.isNotEmpty || commentText.isNotEmpty)
              SizedBox(height: 12.h),
            _buildReviewImagesDisplay(item.userReview!.reviewImages!),
          ],
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              formatIsoDateToCustomFormat(time),
              style: TextStyle(
                fontSize: isTablet(context) ? 16 : 12.sp,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- EDITABLE CARD ---
  Widget _buildEditableCard({
    required String imageUrl,
    required String productName,
    required int orderItemId,
    required int productId,
    required OrderItems item,
  }) {
    final images = _itemImages[orderItemId] ?? [];
    final rating = _ratings[orderItemId] ?? 0.0;
    final isSubmitting = _submitting.contains(orderItemId);

    return Container(
      key: ValueKey(orderItemId),
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: isDarkMode(context) ? Theme.of(context).colorScheme.onSecondary : Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CustomImageContainer(
                  imagePath:  imageUrl,
                  width: isTablet(context) ? 50.h : 60.w,
                  height: isTablet(context) ? 50.h : 60.w,
                  fit: BoxFit.cover,

                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: TextStyle(
                          fontSize: isTablet(context) ? 24 : 16.sp, fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: rating,
                          minRating: 1,
                          itemCount: 5,
                          itemSize: isTablet(context) ? 16.h : 18.w,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.w),
                          itemBuilder: (context, _) => Icon(AppTheme.ratingStarIconFilled, color: AppTheme.ratingStarColor),
                          onRatingUpdate: (newRating) {
                            setState(() => _ratings[orderItemId] = newRating);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Title field
          CustomTextFormField(
            controller: _titleControllers[orderItemId],
            hintText: AppLocalizations.of(context)!.enterReviewTitle,
            maxLines: 1,
            enabled: !isSubmitting,
          ),
          SizedBox(height: 12.h),
          // Description field
          CustomTextFormField(
            controller: _controllers[orderItemId],
            hintText: AppLocalizations.of(context)!.shareYourThoughts,
            maxLines: 3,
            enabled: !isSubmitting,
          ),
          SizedBox(height: 12.h),
          // Show API images when editing, upload section when creating new review
          item.userReview?.id != null
              ? _buildApiImagesSection(item.userReview?.reviewImages ?? [])
              : _imagesSectionForItem(orderItemId, images),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              onPressed: (!isSubmitting)
                  ? () => _submitSingle(orderItemId, productId, item)
                  : () {},
              child: isSubmitting
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: isTablet(context) ? 24.h : 16.w,
                    height: isTablet(context) ? 24.h : 16.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              )
                  : Text(
                      item.userReview?.id != null ? AppLocalizations.of(context)!.update : AppLocalizations.of(context)!.submit,
                      style: TextStyle(
                          fontSize: isTablet(context) ? 20 : 15.sp, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagesSectionForItem(int orderItemId, List<XFile> images) {
    const int maxImages = 5;
    const String allowedExtensions = 'JPG, JPEG, PNG';
    const String maxSizePerImage = '5 MB';

    final int selectedCount = images.length;
    final bool canAddMore = selectedCount < maxImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + Counter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.uploadImages,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              '$selectedCount / $maxImages',
              style: TextStyle(
                fontSize: 11.sp,
                color: selectedCount == maxImages
                    ? AppTheme.errorColor
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
          child: images.isEmpty
              ? _buildEmptyStateForItem(orderItemId)
              : _buildImageGridWithAddButtonForItem(orderItemId, images, canAddMore),
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
  Widget _buildEmptyStateForItem(int orderItemId) {
    return InkWell(
      onTap: () => _pickImagesForItem(orderItemId),
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
              AppLocalizations.of(context)!.tapToUploadPhotos,
              style: TextStyle(
                fontSize: 13.sp,
                color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              AppLocalizations.of(context)!.helpUsUnderstandYourExperience,
              style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Grid with Images + Add Button
  Widget _buildImageGridWithAddButtonForItem(int orderItemId, List<XFile> images, bool canAddMore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            // Selected Images
            for (int i = 0; i < images.length; i++)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.file(
                      File(images[i].path),
                      width: 76.w,
                      height: 76.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: InkWell(
                      onTap: () => _removeImage(orderItemId, i),
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
                  onPressed: () => _pickImagesForItem(orderItemId),
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

  // Display API images (read-only) when editing review
  Widget _buildApiImagesSection(List<String> apiImages) {
    if (apiImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review images',
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 6.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            for (int i = 0; i < apiImages.length; i++)
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.network(
                  apiImages[i],
                  width: 76.w,
                  height: 76.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 76.w,
                    height: 76.w,
                    color: Colors.grey[200],
                    child: Icon(Icons.image, color: Colors.grey[500], size: 24.sp),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // Display review images in reviewed card
  Widget _buildReviewImagesDisplay(List<String> reviewImages) {
    if (reviewImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: [
        for (int i = 0; i < reviewImages.length; i++)
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.network(
              reviewImages[i],
              width: 76.w,
              height: 76.w,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 76.w,
                height: 76.w,
                color: Colors.grey[200],
                child: Icon(Icons.image, color: Colors.grey[500], size: 24.sp),
              ),
            ),
          ),
      ],
    );
  }
}
