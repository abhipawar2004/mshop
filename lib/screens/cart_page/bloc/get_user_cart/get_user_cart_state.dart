part of 'get_user_cart_bloc.dart';

abstract class GetUserCartState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetUserCartInitial extends GetUserCartState {}

class GetUserCartLoading extends GetUserCartState {}

class UserCartInitialLoading extends GetUserCartState {}

class GetUserCartUpdating extends GetUserCartState {
  final List<GetCartModel> cartData;

  GetUserCartUpdating({required this.cartData});

  @override
  List<Object?> get props => [cartData];
}

class GetUserCartLoaded extends GetUserCartState {
  final List<GetCartModel> cartData;
  final String message;
  final Map<int, CartItemAttachment?> attachments;

  GetUserCartLoaded({required this.cartData, required this.message, this.attachments = const {},});
  @override
  // TODO: implement props
  List<Object?> get props => [cartData, message, attachments];
}

class GetUserCartFailed extends GetUserCartState {
  final String error;
  GetUserCartFailed({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class GetUserCartRushDeliveryNotAvailable extends GetUserCartState {
  final String message;
  final List<GetCartModel>? originalData;

  GetUserCartRushDeliveryNotAvailable({
    required this.message,
    this.originalData,
  });

  @override
  List<Object?> get props => [message, originalData];
}

class UpdateCartAttachment extends GetUserCartState {
  final int productId;
  final CartItemAttachment? attachment;

  UpdateCartAttachment({
    required this.productId,
    this.attachment,
  });
}

class ClearCartAttachments extends CartEvent {}