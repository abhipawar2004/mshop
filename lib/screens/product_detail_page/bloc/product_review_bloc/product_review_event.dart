part of 'product_review_bloc.dart';

abstract class ProductReviewEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchProductReview extends ProductReviewEvent {
  final String productSlug;
  FetchProductReview({required this.productSlug});
  @override
  // TODO: implement props
  List<Object?> get props => [productSlug];
}