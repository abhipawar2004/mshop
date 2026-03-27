import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import '../../bloc/product_review_bloc/product_review_bloc.dart';
import '../../widgets/rating_info_card.dart';
import '../../widgets/review_rating_card.dart';

class ReviewRatingListPage extends StatefulWidget {
  final String productSlug;
  const ReviewRatingListPage({super.key, required this.productSlug});

  @override
  State<ReviewRatingListPage> createState() => _ReviewRatingListPageState();
}

class _ReviewRatingListPageState extends State<ReviewRatingListPage> {
  @override
  void initState() {
    context
        .read<ProductReviewBloc>()
        .add(FetchProductReview(productSlug: widget.productSlug));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Text('Reviews & Ratings'),
      ),
      showViewCart: false,
      body: BlocBuilder<ProductReviewBloc, ProductReviewState>(
        builder: (context, state) {
          if (state is ProductReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductReviewLoaded) {
            final reviewData = state.productReview;
            if (reviewData.isEmpty || reviewData.first.data.reviews.isEmpty) {
              return const Center(child: Text('No reviews available', style: TextStyle(color: Colors.black),));
            }
            return Column(
              children: [
                if (state.productReview.first.data.totalReviews > 0)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                    child: RatingInfoCard(reviewModel: state.productReview.first),
                  ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  itemCount: reviewData.first.data.reviews.length,
                  itemBuilder: (context, index) {
                    final reviews = reviewData.first.data.reviews[index];
                    return ReviewRatingCard(
                      rating: reviews.rating.toDouble(),
                      date: reviews.createdAt,
                      reviewText: reviews.comment,
                      index: index,
                      images: reviews.reviewImages,
                    );
                  },
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}