import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CategoryEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchCategory extends CategoryEvent {
  final BuildContext context;
  FetchCategory({required this.context});
  @override
  // TODO: implement props
  List<Object?> get props => [context];
}

class FetchMoreCategory extends CategoryEvent {}