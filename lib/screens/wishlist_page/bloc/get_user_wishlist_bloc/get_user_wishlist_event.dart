part of 'get_user_wishlist_bloc.dart';

abstract class UserWishlistEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetUserWishlistRequest extends UserWishlistEvent {}

class GetMoreUserWishlistRequest extends UserWishlistEvent {}

class CreateNewWishlist extends UserWishlistEvent {
  final String title;
  CreateNewWishlist({required this.title});
  @override
  // TODO: implement props
  List<Object?> get props => [title];
}

class AddItemInWishlist extends UserWishlistEvent {
  final String wishlistTitle;
  final int productId;
  final int productVariantId;
  final int storeId;

  AddItemInWishlist({required this.wishlistTitle, required this.productId, required this.productVariantId, required this.storeId});
  @override
  // TODO: implement props
  List<Object?> get props => [wishlistTitle, productId, productVariantId, storeId];
}

class UpdateUserWishlist extends UserWishlistEvent {
  final String title;
  final int wishlistId;
  UpdateUserWishlist({required this.title, required this.wishlistId});
  @override
  // TODO: implement props
  List<Object?> get props => [title, wishlistId];
}

class DeleteWishlist extends UserWishlistEvent {
  final int wishlistId;
  DeleteWishlist({required this.wishlistId});
  @override
  // TODO: implement props
  List<Object?> get props => [wishlistId];
}

class RemoveItemFromWishlist extends UserWishlistEvent {
  final int itemId;
  RemoveItemFromWishlist({required this.itemId});
  @override
  // TODO: implement props
  List<Object?> get props => [itemId];
}

class MoveItemToAnotherWishlist extends UserWishlistEvent {
  final int itemId;
  final int wishlistId;
  MoveItemToAnotherWishlist({
    required this.itemId,
    required this.wishlistId,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [itemId, wishlistId];
}

// Optimistic update events for instant UI updates
class OptimisticAddToWishlist extends UserWishlistEvent {
  final int productId;
  final int productVariantId;
  final int storeId;
  final int? wishlistItemId;

  OptimisticAddToWishlist({
    required this.productId,
    required this.productVariantId,
    required this.storeId,
    this.wishlistItemId,
  });
  @override
  List<Object?> get props => [productId, productVariantId, storeId, wishlistItemId];
}

class OptimisticRemoveFromWishlist extends UserWishlistEvent {
  final int productId;
  final int productVariantId;
  final int storeId;

  OptimisticRemoveFromWishlist({
    required this.productId,
    required this.productVariantId,
    required this.storeId,
  });
  @override
  List<Object?> get props => [productId, productVariantId, storeId];
}