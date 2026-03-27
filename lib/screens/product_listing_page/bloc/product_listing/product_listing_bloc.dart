import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/product_detail_page/model/product_detail_model.dart';
//
import '../../../../model/sorting_model/sorting_model.dart';
import '../../repo/category_product_repo.dart';
import '../../model/product_listing_type.dart';

part 'product_listing_event.dart';
part 'product_listing_state.dart';

class ProductListingBloc extends Bloc<ProductListingEvent, ProductListingState> {
  ProductListingBloc() : super(ProductListingInitial()) {
    on<FetchListingProducts>(_onFetchListingProducts);
    on<FetchMoreListingProducts>(_onFetchMoreListingProducts);
    on<FetchSortedListingProducts>(_onFetchSortedListingProducts);
    on<ResetSearchKeywords>(_onResetSearchKeywords);
  }

  int currentPage = 1;
  int perPage = 15;
  int? lastPage;
  bool hasReachedMax = false;
  bool isLoadingMore = false;
  final CategoryProductRepository repository = CategoryProductRepository();
  SortType currentSortType = SortType.relevance;
  int totalProducts = 0;
  ProductListingType type = ProductListingType.search;
  String selectedSortingType = '';


  Future<void> _onFetchListingProducts(FetchListingProducts event, Emitter<ProductListingState> emit) async {
    emit(ProductListingLoading());
    try {
      currentPage = 1;
      hasReachedMax = false;
      isLoadingMore = false;
      currentSortType = SortType.relevance;
      List<dynamic> keywords = [];
      type = event.type;
      totalProducts = 0;
      selectedSortingType = event.sortType ?? 'default';

      final response = await repository.fetchProductsByType(
        type: event.type,
        identifier: event.identifier,
        sortType: selectedSortingType,
        currentPage: currentPage,
        perPage: perPage,
        isSearchInStore: event.isSearchInStore ?? false,
        storeSlug: event.storeSlug ?? '',
        includeChildCategories: event.includeChildCategories

      );

      if(response['data'].isNotEmpty) {
        final products = List<ProductData>.from(
            response['data']['data'].map((data) => ProductData.fromJson(data))
        );

        totalProducts = int.parse(response['data']['total'].toString());
        final currentTotal = int.parse(response['data']['current_page'].toString());
        final lastPageNum = int.parse(response['data']['last_page'].toString());

        if(event.type == ProductListingType.search){
          keywords = response['data']['keywords'] as List<dynamic>;
        }

        hasReachedMax = currentTotal >= lastPageNum || products.length < perPage;

        if (response['success'] == true) {
          emit(ProductListingLoaded(
            message: response['message'],
            productList: products,
            hasReachedMax: hasReachedMax,
            isFilterLoading: false,
            isLoading: false,
            currentSortType: currentSortType,
            totalProducts: totalProducts,
            keywords: keywords
          ));
        } else {
          emit(ProductListingFailed(error: response['message']));
        }
      }
      else {
        emit(ProductListingFailed(error: response['message'] ?? 'No products found'));
      }
    } catch (e) {
      emit(ProductListingFailed(error: e.toString()));
    }
  }

  Future<void> _onFetchMoreListingProducts(FetchMoreListingProducts event, Emitter<ProductListingState> emit) async {
    if (hasReachedMax || isLoadingMore) return;

    final currentState = state;
    if (currentState is ProductListingLoaded) {
      isLoadingMore = true;
      try {
        currentPage += 1;
        List<dynamic> keywords = [];

        final response = await repository.fetchProductsByType(
          type: type,
          identifier: event.identifier,
          sortType: selectedSortingType,
          currentPage: currentPage,
          perPage: perPage,
          isSearchInStore: event.isSearchInStore ?? false,
          storeSlug: event.storeSlug ?? '',
        );

        if(response['data'].isNotEmpty) {
          final newProducts = List<ProductData>.from(
              response['data']['data'].map((data) => ProductData.fromJson(data))
          );
          if(event.type == ProductListingType.search){
            keywords = response['data']['keywords'];
          }
          // ✅ Update hasReachedMax based on response
          final currentTotal = int.parse(response['data']['current_page'].toString());
          final lastPageNum = int.parse(response['data']['last_page'].toString());
          hasReachedMax = currentTotal >= lastPageNum || newProducts.length < perPage;

          // ✅ Remove duplicates when combining lists
          final updatedProductList = List<ProductData>.from(currentState.productList);

          // Add only unique products
          for (final newProduct in newProducts) {
            if (!updatedProductList.any((existing) => existing.id == newProduct.id)) {
              updatedProductList.add(newProduct);
            }
          }

          emit(ProductListingLoaded(
              message: response['message'],
              productList: updatedProductList,
              hasReachedMax: hasReachedMax,
              isFilterLoading: false,
              isLoading: false,
              currentSortType: currentSortType,
              totalProducts: totalProducts,
              keywords: keywords
          ));
        } else {
          emit(ProductListingFailed(error: response['message'] ?? 'No products found'));
        }

      } catch (e) {
        // ✅ Reset page on error
        currentPage -= 1;
        emit(ProductListingFailed(error: e.toString()));
      } finally {
        isLoadingMore = false;
      }
    }
  }

  Future<void> _onFetchSortedListingProducts(FetchSortedListingProducts event, Emitter<ProductListingState> emit) async {
    final currentState = state;
    if (currentState is ProductListingLoaded) {
      emit(ProductListingLoaded(
          message: currentState.message,
          productList: [],
          hasReachedMax: false,
          isFilterLoading: true,
          isLoading: false,
          currentSortType: currentState.currentSortType,
          totalProducts: 0
      ));
    }

    try {
      // ✅ Reset pagination for sorting
      currentPage = 1;
      hasReachedMax = false;
      isLoadingMore = false;
      List<dynamic> keywords = [];
      selectedSortingType = event.sortType;

      final response = await repository.fetchProductsByType(
        type: type,
        identifier: event.identifier,
        sortType: event.sortType,
        currentPage: currentPage,
        perPage: perPage,
        isSearchInStore: event.isSearchInStore ?? false,
        storeSlug: event.storeSlug ?? '',
      );

      final products = List<ProductData>.from(
          response['data']['data'].map((data) => ProductData.fromJson(data))
      );

      // ✅ Update pagination state
      final currentTotal = int.parse(response['data']['current_page'].toString());
      final lastPageNum = int.parse(response['data']['last_page'].toString());
      hasReachedMax = currentTotal >= lastPageNum || products.length < perPage;
      if(event.type == ProductListingType.search){
        keywords = response['data']['keywords'];
      }
      currentSortType = SortOption.getSortOptionByApiValue(event.sortType).type;

      if (response['success'] == true) {
        emit(ProductListingLoaded(
          message: response['message'],
          productList: products,
          hasReachedMax: hasReachedMax,
          isFilterLoading: false,
          isLoading: false,
          currentSortType: currentSortType,
          totalProducts: totalProducts,
          keywords: keywords
        ));
      } else {
        emit(ProductListingFailed(error: response['message']));
      }
    } catch (e) {
      emit(ProductListingFailed(error: e.toString()));
    }
  }

  Future<void> _onResetSearchKeywords (ResetSearchKeywords event, Emitter<ProductListingState> emit) async {
    emit(ProductListingInitial());
  }
}