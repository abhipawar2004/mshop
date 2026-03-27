// lib/screens/rate_your_exp/widgets/seller_feedback_sheet.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hyper_local/config/theme.dart';
// import 'package:hyper_local/screens/seller_page/bloc/seller_feedback/seller_feedback_bloc.dart';
// import 'package:hyper_local/utils/widgets/custom_button.dart';
// import 'package:hyper_local/utils/widgets/custom_toast.dart';
//
// class SellerFeedbackSheet extends StatefulWidget {
//   final String orderSlug;
//   final int orderId;
//   final String storeName;
//   final int sellerId;
//
//   const SellerFeedbackSheet({
//     super.key,
//     required this.orderSlug,
//     required this.orderId,
//     required this.storeName,
//     required this.sellerId,
//   });
//
//   @override
//   State<SellerFeedbackSheet> createState() => _SellerFeedbackSheetState();
// }
//
// class _SellerFeedbackSheetState extends State<SellerFeedbackSheet> {
//   late TextEditingController _titleController;
//   late TextEditingController _descController;
//   double _rating = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController();
//     _descController = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descController.dispose();
//     super.dispose();
//   }
//
//   void _submit() {
//     if (_rating == 0) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ToastManager.show(
//           context: context,
//           message: 'Please give a rating',
//           type: ToastType.error,
//         );
//       });
//       return;
//     }
//
//     if (_titleController.text.trim().isEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ToastManager.show(
//           context: context,
//           message: 'Please enter a title',
//           type: ToastType.error,
//         );
//       });
//       return;
//     }
//
//     context.read<SellerFeedbackBloc>().add(
//       AddSellerFeedback(
//         orderId: widget.orderId,
//         sellerId: widget.sellerId,
//         title: _titleController.text.trim(),
//         description: _descController.text.trim(),
//         rating: _rating.toInt(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<SellerFeedbackBloc, SellerFeedbackState>(
//       listener: (context, state) {
//         if (state is SellerFeedbackLoaded) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             ToastManager.show(
//               context: context,
//               message: 'Feedback submitted successfully!',
//               type: ToastType.success,
//             );
//           });
//           context.read<SellerFeedbackBloc>().add(ResetSellerFeedback());
//           Navigator.pop(context, true); // Signal refresh
//         } else if (state is SellerFeedbackFailure) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             ToastManager.show(
//               context: context,
//               message: state.error,
//               type: ToastType.error,
//             );
//           });
//           context.read<SellerFeedbackBloc>().add(ResetSellerFeedback());
//         }
//       },
//       child: Container(
//         padding: EdgeInsets.only(
//           left: 20.w,
//           right: 20.w,
//           top: 20.h,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
//         ),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Drag handle
//               Center(
//                 child: Container(
//                   width: 40.w,
//                   height: 4.h,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(2.r),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16.h),
//
//               // Header
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 24.r,
//                     backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
//                     child: Icon(Icons.store, color: AppTheme.primaryColor, size: 28.w),
//                   ),
//                   SizedBox(width: 12.w),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Rate ${widget.storeName}',
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Text(
//                           'How was your experience?',
//                           style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20.h),
//
//               // Rating
//               Center(
//                 child: RatingBar.builder(
//                   initialRating: _rating,
//                   minRating: 1,
//                   itemCount: 5,
//                   itemSize: 40.w,
//                   itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
//                   glow: false,
//                   itemBuilder: (context, _) => Icon(
//                     Icons.star,
//                     color: Colors.amber,
//                   ),
//                   onRatingUpdate: (rating) {
//                     setState(() => _rating = rating);
//                   },
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               Center(
//                 child: Text(
//                   _rating > 0 ? '${_rating.toInt()} Star${_rating > 1 ? 's' : ''}' : 'Tap to rate',
//                   style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
//                 ),
//               ),
//               SizedBox(height: 20.h),
//
//               // Title
//               TextField(
//                 controller: _titleController,
//                 decoration: InputDecoration(
//                   labelText: 'Title *',
//                   hintText: 'e.g., Great service!',
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//                 ),
//               ),
//               SizedBox(height: 16.h),
//
//               // Description
//               TextField(
//                 controller: _descController,
//                 maxLines: 4,
//                 decoration: InputDecoration(
//                   labelText: 'Description (optional)',
//                   hintText: 'Share more details...',
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//                 ),
//               ),
//               SizedBox(height: 24.h),
//
//               // Submit Button
//               BlocBuilder<SellerFeedbackBloc, SellerFeedbackState>(
//                 builder: (context, state) {
//                   final isLoading = state is SellerFeedbackLoading;
//                   return SizedBox(
//                     width: double.infinity,
//                     height: 50.h,
//                     child: CustomButton(
//                       onPressed: isLoading ? () {} : _submit,
//                       child: isLoading
//                           ? Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 20.w,
//                             height: 20.w,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           ),
//                           SizedBox(width: 12.w),
//                           Text('Submitting...', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
//                         ],
//                       )
//                           : Text(
//                         'Submit Feedback',
//                         style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/screens/seller_page/bloc/seller_feedback/seller_feedback_bloc.dart';
import 'package:hyper_local/utils/widgets/custom_button.dart';
import 'package:hyper_local/utils/widgets/custom_textfield.dart';
import 'package:hyper_local/utils/widgets/custom_toast.dart';
import 'package:hyper_local/l10n/app_localizations.dart';

import '../../../config/constant.dart';

class SellerFeedbackSheet extends StatefulWidget {
  final String orderSlug;
  final int orderItemId;
  final String storeName;
  final int sellerId;
  final int? feedbackId;
  final String? initialTitle;
  final String? initialDescription;
  final int? initialRating;

  const SellerFeedbackSheet({
    super.key,
    required this.orderSlug,
    required this.orderItemId,
    required this.storeName,
    required this.sellerId,
    this.feedbackId,
    this.initialTitle,
    this.initialDescription,
    this.initialRating,
  });

  @override
  State<SellerFeedbackSheet> createState() => _SellerFeedbackSheetState();
}

class _SellerFeedbackSheetState extends State<SellerFeedbackSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _descController = TextEditingController(text: widget.initialDescription ?? '');
    _rating = widget.initialRating?.toDouble() ?? 0.0;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ToastManager.show(
      context: context,
      message: message,
      type: ToastType.error,
    );
  }

  void _handleBlocListener(BuildContext context, SellerFeedbackState state) {
    if (state is SellerFeedbackLoaded) {
      final isUpdate = widget.feedbackId != null;
      ToastManager.show(
        context: context,
        message: isUpdate
            ? AppLocalizations.of(context)!.feedbackUpdatedSuccessfully
            : AppLocalizations.of(context)!.feedbackSubmittedSuccessfully,
        type: ToastType.success,
      );
      context.read<SellerFeedbackBloc>().add(ResetSellerFeedback());
      Navigator.pop(context, true);
    } else if (state is SellerFeedbackFailure) {
      ToastManager.show(
        context: context,
        message: state.error,
        type: ToastType.error,
      );
      context.read<SellerFeedbackBloc>().add(ResetSellerFeedback());
    }
  }

  void _submit() {
    // Validation for all 3 inputs
    if (_rating == 0) {
      return _showError(AppLocalizations.of(context)!.pleaseGiveARating);
    }
    if (_titleController.text.trim().isEmpty) {
      return _showError(AppLocalizations.of(context)!.pleaseEnterATitle);
    }
    if (_descController.text.trim().isEmpty) {
      return _showError(AppLocalizations.of(context)!.pleaseEnterADescription);
    }

    final isUpdate = widget.feedbackId != null;

    if (isUpdate) {
      context.read<SellerFeedbackBloc>().add(
        UpdateSellerFeedback(
          feedbackId: widget.feedbackId!,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          rating: _rating.toInt(),
        ),
      );
    } else {
      context.read<SellerFeedbackBloc>().add(
        AddSellerFeedback(
          orderItemId: widget.orderItemId,
          sellerId: widget.sellerId,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          rating: _rating.toInt(),
        ),
      );
    }
  }

  void _deleteFeedback() {
    if (widget.feedbackId == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteFeedback),
        content: Text(AppLocalizations.of(context)!.areYouSureYouWantToDeleteThisFeedback),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SellerFeedbackBloc>().add(
                DeleteSellerFeedback(feedbackId: widget.feedbackId!),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SellerFeedbackBloc, SellerFeedbackState>(
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
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: const Offset(0, -3),
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
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                _HeaderSection(
                  storeName: widget.storeName,
                  isEditMode: widget.feedbackId != null,
                ),
                SizedBox(height: 20.h),
                _RatingSection(
                  rating: _rating,
                  onChanged: (r) {
                    HapticFeedback.lightImpact();
                    setState(() => _rating = r);
                  },
                ),
                SizedBox(height: 20.h),
                _InputSection(
                  titleController: _titleController,
                  descController: _descController,
                ),
                SizedBox(height: 24.h),
                _ActionButtons(
                  isLoading:
                  context.watch<SellerFeedbackBloc>().state is SellerFeedbackLoading,
                  onSubmit: _submit,
                  onDelete: widget.feedbackId != null ? _deleteFeedback : null,
                  isEditMode: widget.feedbackId != null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// --- HEADER SECTION ---
class _HeaderSection extends StatelessWidget {
  final String storeName;
  final bool isEditMode;
  const _HeaderSection({required this.storeName, required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: isTablet(context) ? 18.r : 24.r,
          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          child: Icon(Icons.store_rounded,
              color: AppTheme.primaryColor, size: isTablet(context) ? 24.h : 28.w),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.rateStoreName(storeName),
                style: TextStyle(fontSize: isTablet(context) ? 24 : 18.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4.h),
              Text(
                isEditMode ? AppLocalizations.of(context)!.editYourFeedback : AppLocalizations.of(context)!.howWasYourExperience,
                style: TextStyle(fontSize: isTablet(context) ? 20 : 13.sp, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// --- RATING SECTION ---
class _RatingSection extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onChanged;

  const _RatingSection({required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
          SizedBox(height: 8.h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              rating > 0
                  ? '${rating.toInt()} Star${rating > 1 ? 's' : ''}'
                  : AppLocalizations.of(context)!.tapToRate,
              key: ValueKey(rating),
              style: TextStyle(fontSize: isTablet(context) ? 18 : 12.sp, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}

/// --- INPUT SECTION ---
class _InputSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descController;

  const _InputSection({
    required this.titleController,
    required this.descController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          controller: titleController,
          textInputAction: TextInputAction.next,
          hintText: AppLocalizations.of(context)!.egGreatService,
        ),
        SizedBox(height: 16.h),
        CustomTextFormField(
          controller: descController,
          maxLines: 4,
          hintText: AppLocalizations.of(context)!.shareMoreDetails,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }
}

/// --- ACTION BUTTONS ---
class _ActionButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback? onDelete;
  final bool isEditMode;

  const _ActionButtons({
    required this.isLoading,
    required this.onSubmit,
    this.onDelete,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            onPressed: isLoading ? () {} : onSubmit,
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
                  isEditMode ? AppLocalizations.of(context)!.updating : AppLocalizations.of(context)!.submitting,
                  style: TextStyle(fontSize: isTablet(context) ? 20 : 14.sp, color: Colors.white),
                ),
              ],
            )
                : Text(
              isEditMode ? AppLocalizations.of(context)!.updateFeedback : AppLocalizations.of(context)!.submitFeedback,
              style: TextStyle(
                fontSize: isTablet(context) ? 20 : 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        if (onDelete != null) ...[
          SizedBox(height: 12.h),
          SizedBox(
            height: isTablet(context) ? 40.h : 48,
            width: double.infinity,
            child: OutlinedButton(
              onPressed: isLoading ? null : onDelete,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.deleteFeedback,
                style: TextStyle(
                  fontSize: isTablet(context) ? 20 : 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade700,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}




















/*
// lib/screens/rate_your_exp/widgets/seller_feedback_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/screens/seller_page/bloc/seller_feedback/seller_feedback_bloc.dart';
import 'package:hyper_local/utils/widgets/custom_toast.dart';

class SellerFeedbackSheet extends StatefulWidget {
  final String orderSlug;
  final String storeName;
  final int sellerId;
  final int? feedbackId;
  final String? initialTitle;
  final String? initialDescription;
  final int? initialRating;

  const SellerFeedbackSheet({
    super.key,
    required this.orderSlug,
    required this.storeName,
    required this.sellerId,
    this.feedbackId,
    this.initialTitle,
    this.initialDescription,
    this.initialRating,
  });

  @override
  State<SellerFeedbackSheet> createState() => _SellerFeedbackSheetState();
}

class _SellerFeedbackSheetState extends State<SellerFeedbackSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descController = TextEditingController(text: widget.initialDescription);
    _rating = widget.initialRating?.toDouble() ?? 0.0;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastManager.show(
          context: context,
          message: 'Please give a rating',
          type: ToastType.error,
        );
      });
      return;
    }

    if (_titleController.text.trim().isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastManager.show(
          context: context,
          message: 'Please enter a title',
          type: ToastType.error,
        );
      });
      return;
    }

    final isUpdate = widget.feedbackId != null;

    if (isUpdate) {
      context.read<SellerFeedbackBloc>().add(
        UpdateSellerFeedback(
          feedbackId: widget.feedbackId!,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          rating: _rating.toInt(),
        ),
      );
    } else {
      context.read<SellerFeedbackBloc>().add(
        AddSellerFeedback(
          sellerId: widget.sellerId,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          rating: _rating.toInt(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SellerFeedbackBloc, SellerFeedbackState>(
      listener: (context, state) {
        if (state is SellerFeedbackLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ToastManager.show(
              context: context,
              message: 'Feedback ${widget.feedbackId != null ? 'updated' : 'submitted'} successfully!',
              type: ToastType.success,
            );
          });
          context.read<SellerFeedbackBloc>().add(ResetSellerFeedback());
          Navigator.pop(context, true); // Signal refresh
        } else if (state is SellerFeedbackFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ToastManager.show(
              context: context,
              message: state.error,
              type: ToastType.error,
            );
          });
          context.read<SellerFeedbackBloc>().add(ResetSellerFeedback());
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 20.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
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
              SizedBox(height: 16.h),

              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(Icons.store, color: Colors.blue, size: 28.w),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rate ${widget.storeName}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.feedbackId != null ? 'Edit your feedback' : 'How was your experience?',
                          style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Rating
              Center(
                child: RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  itemCount: 5,
                  itemSize: 40.w,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
                  glow: false,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() => _rating = rating);
                  },
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  _rating > 0 ? '${_rating.toInt()} Star${_rating > 1 ? 's' : ''}' : 'Tap to rate',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 20.h),

              // Title
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title *',
                  hintText: 'e.g., Great service!',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                ),
              ),
              SizedBox(height: 16.h),

              // Description
              TextField(
                controller: _descController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'Share more details...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                ),
              ),
              SizedBox(height: 24.h),

              // Submit Button
              BlocBuilder<SellerFeedbackBloc, SellerFeedbackState>(
                builder: (context, state) {
                  final isLoading = state is SellerFeedbackLoading;
                  return SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: isLoading
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text('Submitting...', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                        ],
                      )
                          : Text(
                        widget.feedbackId != null ? 'Update Feedback' : 'Submit Feedback',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
