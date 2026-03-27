part of 'product_review_bloc.dart';

abstract class ProductReviewState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProductReviewInitial extends ProductReviewState {}

class ProductReviewLoading extends ProductReviewState {}

class ProductReviewLoaded extends ProductReviewState {
  final List<ProductReviewData> productReview;
  final String message;
  ProductReviewLoaded({required this.message, required this.productReview});

  @override
  // TODO: implement props
  List<Object?> get props => [message, productReview];
}

class ProductReviewFailure extends ProductReviewState {
  final String error;
  ProductReviewFailure({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
