part of 'similar_product_bloc.dart';

abstract class SimilarProductEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchSimilarProduct extends SimilarProductEvent {
  final List<String> excludeProductSlug;
  FetchSimilarProduct({required this.excludeProductSlug});
  @override
  // TODO: implement props
  List<Object?> get props => [excludeProductSlug];
}