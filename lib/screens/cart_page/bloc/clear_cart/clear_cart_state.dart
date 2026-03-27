import 'package:equatable/equatable.dart';

abstract class ClearCartState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ClearCartInitial extends ClearCartState {}

class ClearCartLoading extends ClearCartState {}

class ClearCartSuccess extends ClearCartState {}

class ClearCartFailed extends ClearCartState {
  final String error;

  ClearCartFailed({required this.error});

  @override
  List<Object?> get props => [error];
}
