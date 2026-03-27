part of 'shopping_list_bloc.dart';

abstract class ShoppingListState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ShoppingListInitial extends ShoppingListState {}

class ShoppingListLoading extends ShoppingListState {}

class ShoppingListLoaded extends ShoppingListState {
  final String message;
  final List<ShoppingListData> shoppingListData;
  final bool hasReachedMax;

  ShoppingListLoaded({
    required this.message,
    required this.shoppingListData,
    required this.hasReachedMax
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message, shoppingListData, hasReachedMax];
}

class ShoppingListFailed extends ShoppingListState {
  final String error;
  ShoppingListFailed({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}