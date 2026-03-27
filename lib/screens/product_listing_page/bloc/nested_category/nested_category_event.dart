part of 'nested_category_bloc.dart';

abstract class NestedCategoryEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchNestedCategory extends NestedCategoryEvent {
  final String slug;
  FetchNestedCategory({required this.slug});
  @override
  // TODO: implement props
  List<Object?> get props => [slug];
}