import 'package:equatable/equatable.dart';
import 'package:hyper_local/screens/home_page/model/category_model.dart';

abstract class CategoryState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryData> categoryData;
  final String message;
  CategoryLoaded({
    required this.message,
    required this.categoryData
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message, categoryData];
}

class CategoryFailed extends CategoryState {
  final String error;
  CategoryFailed({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}