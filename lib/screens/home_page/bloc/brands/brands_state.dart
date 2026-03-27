part of 'brands_bloc.dart';

abstract class BrandsState extends Equatable {
  const BrandsState();
}

class BrandsInitial extends BrandsState {
  @override
  List<Object> get props => [];
}

class BrandsLoading extends BrandsState {
  @override
  List<Object> get props => [];
}

class BrandsLoaded extends BrandsState {
  final List<BrandsData> brandsData;
  final String message;
  const BrandsLoaded({required this.brandsData, required this.message});
  @override
  List<Object> get props => [];
}

class BrandsFailed extends BrandsState {
  final String error;
  const BrandsFailed({required this.error});
  @override
  List<Object> get props => [error];
}
