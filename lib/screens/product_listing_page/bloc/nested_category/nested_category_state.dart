part of 'nested_category_bloc.dart';

abstract class NestedCategoryState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NestedCategoryInitial extends NestedCategoryState {}

class NestedCategoryLoading extends NestedCategoryState {}

class NestedCategoryLoaded extends NestedCategoryState {
  final List<SubCategoryData> subCategoryData;
  final String message;
  NestedCategoryLoaded({
    required this.message,
    required this.subCategoryData
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message, subCategoryData];
}

class NestedCategoryFailed extends NestedCategoryState {
  final String error;
  NestedCategoryFailed({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}