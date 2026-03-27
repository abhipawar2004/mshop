part of 'product_faq_bloc.dart';

abstract class ProductFAQState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProductFAQInitial extends ProductFAQState {}

class ProductFAQLoading extends ProductFAQState {}

class ProductFAQLoaded extends ProductFAQState {
  final List<ProductFAQData> productData;
  final String message;
  ProductFAQLoaded({required this.message, required this.productData});

  @override
  // TODO: implement props
  List<Object?> get props => [message, productData];
}

class ProductFAQFailure extends ProductFAQState {
  final String error;
  ProductFAQFailure({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
