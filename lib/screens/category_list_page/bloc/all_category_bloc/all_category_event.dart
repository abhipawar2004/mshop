import 'package:equatable/equatable.dart';

abstract class AllCategoriesEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchAllCategories extends AllCategoriesEvent {}

class FetchMoreAllCategories extends AllCategoriesEvent {}