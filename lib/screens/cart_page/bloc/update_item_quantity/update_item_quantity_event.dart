import 'package:equatable/equatable.dart';

abstract class UpdateItemQuantityEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UpdateItemQuantityRequest extends UpdateItemQuantityEvent{
  final int cartItemId;
  final int quantity;

  UpdateItemQuantityRequest({
    required this.cartItemId,
    required this.quantity
  });

  @override
  // TODO: implement props
  List<Object?> get props => [cartItemId, quantity];
}
