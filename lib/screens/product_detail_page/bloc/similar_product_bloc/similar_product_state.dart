part of 'similar_product_bloc.dart';

abstract class SimilarProductState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SimilarProductInitial extends SimilarProductState {}

class SimilarProductLoading extends SimilarProductState {}

class SimilarProductLoaded extends SimilarProductState {
  final String message;
  final List<ProductData> similarProduct;
  final bool hasReachedMax;

  SimilarProductLoaded({
    required this.message,
    required this.similarProduct,
    required this.hasReachedMax,
  });

  @override
  List<Object?> get props => [message, similarProduct];
}

class SimilarProductFailure extends SimilarProductState {
  final String error;
  SimilarProductFailure({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
