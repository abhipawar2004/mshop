part of 'product_listing_bloc.dart';

abstract class ProductListingEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchFilteredAndSortedProduct extends ProductListingEvent {
  final String categorySlug;
  final String sortType;
  FetchFilteredAndSortedProduct({
    required this.categorySlug,
    required this.sortType
  });
  @override
  // TODO: implement props
  List<Object?> get props => [categorySlug, sortType];
}

class FetchListingProducts extends ProductListingEvent {
  final ProductListingType type;
  final String identifier;
  final String? storeSlug;
  final String? sortType;
  final bool? isSearchInStore;
  final String? includeChildCategories;

  FetchListingProducts({
    required this.type,
    required this.identifier,
    this.storeSlug,
    this.sortType,
    this.isSearchInStore,
    this.includeChildCategories
  });

  @override
  List<Object?> get props => [type, identifier, storeSlug, sortType, isSearchInStore, includeChildCategories];
}

class FetchSortedListingProducts extends ProductListingEvent {
  final ProductListingType type;
  final String identifier;
  final String? storeSlug;
  final String sortType;
  final bool? isSearchInStore;

  FetchSortedListingProducts({
    required this.type,
    required this.identifier,
    this.storeSlug,
    required this.sortType,
    this.isSearchInStore
  });

  @override
  List<Object?> get props => [type, identifier, storeSlug, sortType, isSearchInStore];
}

class FetchMoreListingProducts extends ProductListingEvent {
  final ProductListingType type;
  final String identifier;
  final String? storeSlug;
  final String? sortType;
  final bool? isSearchInStore;

  FetchMoreListingProducts({
    required this.type,
    required this.identifier,
    this.storeSlug,
    this.sortType,
    this.isSearchInStore
  });

  @override
  List<Object?> get props => [type, identifier, storeSlug, sortType, isSearchInStore];
}

class FetchKeywords extends ProductListingEvent {
  final String query;
  FetchKeywords({required this.query});
  @override
  // TODO: implement props
  List<Object?> get props => [query];
}

class ResetSearchKeywords extends ProductListingEvent {}