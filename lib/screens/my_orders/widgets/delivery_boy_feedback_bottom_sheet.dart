import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/screens/my_orders/bloc/delivery_boy_feedback/delivery_boy_feedback_bloc.dart';
import 'package:hyper_local/utils/widgets/custom_button.dart';
import 'package:hyper_local/utils/widgets/custom_textfield.dart';
import 'package:hyper_local/utils/widgets/custom_toast.dart';
import 'package:hyper_local/l10n/app_localizations.dart';

import '../../../config/constant.dart';

class DeliveryBoyFeedbackSheet extends StatefulWidget {
  final String orderSlug;
  final int orderId;
  final int deliveryBoyId;
  final int? feedbackId;
  final String? initialTitle;
  final String? initialDescription;
  final int? initialRating;

  const DeliveryBoyFeedbackSheet({
    super.key,
    required this.orderSlug,
    required this.orderId,
    required this.deliveryBoyId,
    this.feedbackId,
    this.initialTitle,
    this.initialDescription,
    this.initialRating,
  });

  @override
  State<DeliveryBoyFeedbackSheet> createState() => _DeliveryBoyFeedbackSheetState();
}

class _DeliveryBoyFeedbackSheetState extends State<DeliveryBoyFeedbackSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initialTitle ?? '');
    _descCtrl = TextEditingController(text: widget.initialDescription ?? '');
    _rating = (widget.initialRating ?? 0).toDouble();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    ToastManager.show(
      context: context,
      message: msg,
      type: ToastType.error,
    );
  }

  void _handleBlocListener(BuildContext ctx, DeliveryBoyFeedbackState state) {
    if (state is DeliveryBoyFeedbackLoaded) {
      ToastManager.show(
        context: ctx,
        message: widget.feedbackId == null ? AppLocalizations.of(context)!.feedbackSubmittedSuccessfully : AppLocalizations.of(context)!.feedbackUpdatedSuccessfully,
        type: ToastType.success,
      );
      Navigator.pop(ctx, true);
    } else if (state is DeliveryBoyFeedbackFailure) {
      ToastManager.show(
        context: ctx,
        message: state.error,
        type: ToastType.error,
      );
    }
  }

  void _submit() {
    if (_rating == 0) return _showError(AppLocalizations.of(context)!.pleaseGiveARating);
    if (_titleCtrl.text.trim().isEmpty) return _showError(AppLocalizations.of(context)!.pleaseEnterATitle);

    final isEdit = widget.feedbackId != null;

    if (isEdit) {
      context.read<DeliveryBoyFeedbackBloc>().add(
        UpdateDeliveryBoyFeedback(
          feedbackId: widget.feedbackId!,
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          rating: _rating.toInt(),
        ),
      );
    } else {
      context.read<DeliveryBoyFeedbackBloc>().add(
        AddDeliveryBoyFeedback(
          deliveryBoyId: widget.deliveryBoyId,
          orderId: widget.orderId,
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          rating: _rating.toInt(),
        ),
      );
    }
  }

  void _delete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteFeedback),
        content: Text(AppLocalizations.of(context)!.areYouSureDeleteFeedback),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<DeliveryBoyFeedbackBloc>().add(
                DeleteDeliveryBoyFeedback(feedbackId: widget.feedbackId!),
              );
            },
            child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.feedbackId != null;
    return BlocListener<DeliveryBoyFeedbackBloc, DeliveryBoyFeedbackState>(
      listener: _handleBlocListener,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 10.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _HeaderSection(
                  isEdit: isEdit,
                  orderSlug: widget.orderSlug,
                ),
                const SizedBox(height: 20),
                _RatingSection(
                  rating: _rating,
                  onChanged: (r) {
                    HapticFeedback.lightImpact();
                    setState(() => _rating = r);
                  },
                ),
                const SizedBox(height: 20),
                _InputSection(
                  titleCtrl: _titleCtrl,
                  descCtrl: _descCtrl,
                ),
                const SizedBox(height: 24),
                _SubmitButton(
                  isLoading: context.watch<DeliveryBoyFeedbackBloc>().state is DeliveryBoyFeedbackLoading,
                  onPressed: _submit,
                  isEdit: isEdit,
                ),
                if (isEdit) ...[
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: _delete,
                      child: Text(
                        AppLocalizations.of(context)!.deleteFeedback,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}



/// ---------------------------------------------------
/// PRIVATE WIDGETS
/// ---------------------------------------------------

class _HeaderSection extends StatelessWidget {
  final bool isEdit;
  final String orderSlug;

  const _HeaderSection({required this.isEdit, required this.orderSlug});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: isTablet(context) ? 18.r : 24.r,
          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          child: Icon(Icons.delivery_dining_rounded,
              color: AppTheme.primaryColor, size: isTablet(context) ? 24.h : 28.w),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? AppLocalizations.of(context)!.editYourFeedback : AppLocalizations.of(context)!.rateDeliveryHero,
                style:
                TextStyle(fontSize: isTablet(context) ? 24 : 18.sp, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                isEdit ? AppLocalizations.of(context)!.updateFeedback : AppLocalizations.of(context)!.howWasTheDelivery,
                style: TextStyle(fontSize: isTablet(context) ? 20 : 13.sp, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RatingSection extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onChanged;

  const _RatingSection({required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            itemCount: 5,
            itemSize: isTablet(context) ? 16.h : 18.w,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
            glow: false,
            itemBuilder: (_, __) =>
            Icon(AppTheme.ratingStarIconFilled, color: AppTheme.ratingStarColor),
            onRatingUpdate: onChanged,
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              rating > 0
                  ? '${rating.toInt()} Star${rating > 1 ? 's' : ''}'
                  : 'Tap to rate',
              key: ValueKey(rating),
              style: TextStyle(fontSize: isTablet(context) ? 18 : 12.sp, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputSection extends StatelessWidget {
  final TextEditingController titleCtrl;
  final TextEditingController descCtrl;

  const _InputSection({required this.titleCtrl, required this.descCtrl});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          controller: titleCtrl,
          textInputAction: TextInputAction.next,
          hintText: AppLocalizations.of(context)!.egSuperFastDelivery,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: descCtrl,
          maxLines: 4,
          hintText: AppLocalizations.of(context)!.shareMoreDetails,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final bool isEdit;

  const _SubmitButton({
    required this.isLoading,
    required this.onPressed,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        onPressed: isLoading ? () {} : onPressed,
        child: isLoading
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              AppLocalizations.of(context)!.submitting,
              style: TextStyle(fontSize: isTablet(context) ? 20 : 14.sp, color: Colors.white),
            ),
          ],
        )
            : Text(
          isEdit ? AppLocalizations.of(context)!.updateFeedback : AppLocalizations.of(context)!.submitFeedback,
          style: TextStyle(
            fontSize: isTablet(context) ? 20 : 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}