part of 'wishlist_product_bloc.dart';

abstract class WishlistProductState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WishlistProductInitial extends WishlistProductState {}

class WishlistProductLoading extends WishlistProductState {}

class WishlistProductLoaded extends WishlistProductState {
  final String message;
  final List<WishlistProductItems> wishlistProductItems;
  final String wishlistName;
  final int totalProducts;
  final bool hasReachedMax;
  final bool isLoading;

  WishlistProductLoaded({
    required this.message,
    required this.wishlistProductItems,
    required this.totalProducts,
    required this.wishlistName,
    required this.hasReachedMax,
    required this.isLoading,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    message,
    wishlistProductItems,
    totalProducts,
    wishlistName,
    hasReachedMax,
    isLoading
  ];
}

class WishlistProductFailed extends WishlistProductState {
  final String error;

  WishlistProductFailed({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}