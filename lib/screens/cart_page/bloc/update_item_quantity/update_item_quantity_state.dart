import 'package:equatable/equatable.dart';

abstract class UpdateItemQuantityState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UpdateItemQuantityInitial extends UpdateItemQuantityState {}

class UpdateItemQuantityLoading extends UpdateItemQuantityState {}

class UpdateItemQuantitySuccess extends UpdateItemQuantityState {}

class UpdateItemQuantityFailed extends UpdateItemQuantityState {
  final String error;

  UpdateItemQuantityFailed({required this.error});

  @override
  List<Object?> get props => [error];
}
