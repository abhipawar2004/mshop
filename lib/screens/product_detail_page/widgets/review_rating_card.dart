import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';

import '../../../config/constant.dart';
import '../../../config/theme.dart';

class ReviewRatingCard extends StatelessWidget {
  final double rating;
  final String date;
  final String reviewText;
  final List<String>? images;
  final int? maxLines;
  final int index;
  const ReviewRatingCard({
    super.key,
    required this.rating,
    required this.date,
    required this.reviewText,
    required this.index,
    this.maxLines,
    this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(right: 12.w),
      margin: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 12.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rating and date row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Star rating
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 14,
                      itemBuilder: (context, _) => Icon(
                        AppTheme.ratingStarIconFilled,
                        color: AppTheme.ratingStarColor,
                      ),
                      ignoreGestures: true,
                      onRatingUpdate: (rating) {},
                    ),
                    const SizedBox(width: 6),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                // Date
                Text(
                  formatIsoDateToCustomFormat(date),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),

            // Horizontal Image List (if images are provided)
            if (images != null && images!.isNotEmpty) ...[
              const SizedBox(height: 10),
              SizedBox(
                height: 50.h, // Fixed height for image list
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(right: 8.w),
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: CustomImageContainer(
                          imagePath:  images![index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 10),
            // Review text
            Expanded(
              child: Text(
                reviewText,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.8),
                  height: 1.3,
                ),
                maxLines: maxLines ?? 100,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
