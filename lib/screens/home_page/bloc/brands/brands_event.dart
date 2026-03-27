part of 'brands_bloc.dart';

sealed class BrandsEvent extends Equatable {
  const BrandsEvent();
}

class FetchBrands extends BrandsEvent{
  final String categorySlug;
  const FetchBrands({required this.categorySlug});
  @override
  List<Object?> get props => [categorySlug];
}