import 'package:equatable/equatable.dart';

abstract class SubCategoryEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchSubCategory extends SubCategoryEvent {
  final String slug;
  final bool isForAllCategory;
  FetchSubCategory({required this.slug, required this.isForAllCategory});
  @override
  // TODO: implement props
  List<Object?> get props => [slug, isForAllCategory];
}

class FetchMoreSubCategory extends SubCategoryEvent {}