import 'package:equatable/equatable.dart';

import '../../model/sub_category_model.dart';

abstract class SubCategoryState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SubCategoryInitial extends SubCategoryState {}

class SubCategoryLoading extends SubCategoryState {}

class SubCategoryLoaded extends SubCategoryState {
  final List<SubCategoryData> subCategoryData;
  final String message;
  final bool isLoadingMore;
  SubCategoryLoaded({
    required this.message,
    required this.subCategoryData,
    this.isLoadingMore = false,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message, subCategoryData, isLoadingMore];
}

class SubCategoryFailed extends SubCategoryState {
  final String error;
  SubCategoryFailed({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}