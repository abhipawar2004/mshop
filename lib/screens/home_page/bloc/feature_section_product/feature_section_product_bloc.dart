import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/home_page/bloc/feature_section_product/feature_section_product_event.dart';
import 'package:hyper_local/screens/home_page/bloc/feature_section_product/feature_section_product_state.dart';
import 'package:hyper_local/screens/home_page/repo/feature_section_product_repo.dart';

import '../../model/featured_section_product_model.dart';

class FeatureSectionProductBloc
    extends Bloc<FeatureSectionProductEvent, FeatureSectionProductState> {
  FeatureSectionProductBloc() : super(FeatureSectionProductInitial()) {
    on<FetchFeatureSectionProducts>(_onFetchFeatureSectionProducts);
    on<FetchMoreFeatureSectionProducts>(_onFetchMoreFeatureSectionProducts);
    on<ClearFeatureSectionProducts>(_onClearProducts);
    on<RefreshFeatureSectionProducts>(_onRefreshFeatureSectionProducts);
  }

  int currentPage = 0;
  int perPage = 0;
  int? lastPage;
  bool hasReachedMax = false;
  bool isLoadingMore = false;
  final repository = FeatureSectionProductRepository();
  bool isRefresh = false;
  String selectedCategory = '';

  void _onClearProducts(ClearFeatureSectionProducts event,
      Emitter<FeatureSectionProductState> emit) {
    emit(FeatureSectionProductLoading());
  }

  Future<void> _onFetchFeatureSectionProducts(FetchFeatureSectionProducts event,
      Emitter<FeatureSectionProductState> emit) async {
    if (isRefresh) {
      emit(FeatureSectionProductLoading());
    }
    try {
      List<FeatureSectionData> featureSectionProductData = [];
      perPage = 12;
      currentPage = 1;
      hasReachedMax = false;
      selectedCategory = event.slug;

      final response = await repository.fetchFeatureSectionProduct(
          slug: event.slug, perPage: perPage, page: currentPage);
      print('========== FEATURE SECTION PRODUCT API RESPONSE ==========');
      print(response);
      print('==========================================================');
      featureSectionProductData = List<FeatureSectionData>.from(response['data']
              ['data']
          .map((data) => FeatureSectionData.fromJson(data)));
      final currentTotal =
          int.parse(response['data']['current_page'].toString());
      final lastPageNum = int.parse(response['data']['last_page'].toString());
      hasReachedMax = currentTotal >= lastPageNum ||
          featureSectionProductData.length < perPage;
      if (response['success'] == true) {
        emit(FeatureSectionProductLoaded(
            featureSectionProductData: featureSectionProductData,
            message: response['message'],
            hasReachedMax: hasReachedMax));
        isRefresh = true;
      } else if (response['success'] == false) {
        emit(FeatureSectionProductFailed(error: response['message']));
        isRefresh = true;
      } else {
        emit(FeatureSectionProductFailed(error: response['message']));
        isRefresh = true;
      }
    } catch (e) {
      emit(FeatureSectionProductFailed(error: e.toString()));
      isRefresh = true;
    }
  }

  Future<void> _onFetchMoreFeatureSectionProducts(
      FetchMoreFeatureSectionProducts event,
      Emitter<FeatureSectionProductState> emit) async {
    if (hasReachedMax || isLoadingMore) return;

    final currentState = state;
    if (currentState is FeatureSectionProductLoaded) {
      isLoadingMore = true;
      try {
        currentPage += 1;

        final response = await repository.fetchFeatureSectionProduct(
            slug: event.slug, perPage: perPage, page: currentPage);
        final featureSectionProductData = List<FeatureSectionData>.from(
            response['data']['data']
                .map((data) => FeatureSectionData.fromJson(data)));

        final currentTotal =
            int.parse(response['data']['current_page'].toString());
        final lastPageNum = int.parse(response['data']['last_page'].toString());
        hasReachedMax = currentTotal >= lastPageNum ||
            featureSectionProductData.length < perPage;

        final updatedFeatureSectionList = List<FeatureSectionData>.from(
            currentState.featureSectionProductData);

        for (final newData in featureSectionProductData) {
          if (!updatedFeatureSectionList
              .any((existing) => existing.id == newData.id)) {
            updatedFeatureSectionList.add(newData);
          }
        }

        emit(FeatureSectionProductLoaded(
            featureSectionProductData: updatedFeatureSectionList,
            message: response['message'],
            hasReachedMax: hasReachedMax));
      } catch (e) {
        currentPage -= 1;
        emit(FeatureSectionProductFailed(error: e.toString()));
      } finally {
        isLoadingMore = false;
      }
    }
  }

  Future<void> _onRefreshFeatureSectionProducts(
      RefreshFeatureSectionProducts event,
      Emitter<FeatureSectionProductState> emit) async {
    emit(FeatureSectionProductLoading());
    try {
      isRefresh = false;
      add(FetchFeatureSectionProducts(slug: selectedCategory));
    } catch (e) {
      emit(FeatureSectionProductFailed(error: e.toString()));
    }
  }
}
