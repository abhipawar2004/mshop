import 'package:equatable/equatable.dart';

abstract class AddToCartState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddToCartInitial extends AddToCartState {}

class AddToCartLoading extends AddToCartState {}

class AddToCartSuccess extends AddToCartState {}

class AddToCartFailed extends AddToCartState {
  final String error;

  AddToCartFailed({required this.error});

  @override
  List<Object?> get props => [error];
}
