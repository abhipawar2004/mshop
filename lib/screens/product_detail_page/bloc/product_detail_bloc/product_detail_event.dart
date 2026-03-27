import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchProductDetail extends ProductDetailEvent {
  final String productSlug;
  FetchProductDetail({required this.productSlug});
  @override
  // TODO: implement props
  List<Object?> get props => [productSlug];
}