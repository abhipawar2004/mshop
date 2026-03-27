part of 'wishlist_product_bloc.dart';

abstract class WishlistProductEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchWishlistProductData extends WishlistProductEvent {
  final int wishlistId;
  FetchWishlistProductData({required this.wishlistId});

  @override
  // TODO: implement props
  List<Object?> get props => [wishlistId];
}
