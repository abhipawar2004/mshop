part of 'shopping_list_bloc.dart';

abstract class ShoppingListEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CreateShoppingList extends ShoppingListEvent {
  final String keywords;
  CreateShoppingList({required this.keywords});
  @override
  // TODO: implement props
  List<Object?> get props => [keywords];
}