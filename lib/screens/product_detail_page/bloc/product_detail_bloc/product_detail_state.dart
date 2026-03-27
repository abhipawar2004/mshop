import 'package:equatable/equatable.dart';

import '../../model/product_detail_model.dart';

abstract class ProductDetailState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final List<ProductData> productData;
  final String message;
  ProductDetailLoaded({required this.message, required this.productData});

  @override
  // TODO: implement props
  List<Object?> get props => [message, productData];
}

class ProductDetailFailed extends ProductDetailState {
  final String error;
  ProductDetailFailed({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}