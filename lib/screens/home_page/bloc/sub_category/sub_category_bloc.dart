import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/home_page/bloc/sub_category/sub_category_event.dart';
import 'package:hyper_local/screens/home_page/bloc/sub_category/sub_category_state.dart';
import '../../model/sub_category_model.dart';
import '../../repo/sub_category_repo.dart';

class SubCategoryBloc extends Bloc<SubCategoryEvent, SubCategoryState> {
  SubCategoryBloc() : super(SubCategoryInitial()) {
    on<FetchSubCategory>(_onFetchSubCategory);

    on<FetchMoreSubCategory>(_onFetchMoreSubCategory);
  }
  int currentPage = 0;
  int perPage = 0;
  int? lastPage;
  bool _hasReachedMax = false;
  bool loadMore = false;
  String selectedSlug = '';
  bool selectedIsForAllCategory = false;
  final SubCategoryRepository repository = SubCategoryRepository();

  Future<void> _onFetchSubCategory(
      FetchSubCategory event, Emitter<SubCategoryState> emit) async {
    emit(SubCategoryLoading());
    try {
      List<SubCategoryData> subCategoryData = [];
      perPage = 80;
      currentPage = 1;
      _hasReachedMax = false;
      loadMore = false;
      selectedSlug = event.slug;
      selectedIsForAllCategory = event.isForAllCategory;
      final response = await repository.fetchSubCategory(
          slug: event.slug,
          isForAllCategory: event.isForAllCategory,
          perPage: perPage,
          page: currentPage,
          isFiltered: true);
      print('========== SUB CATEGORY API RESPONSE ==========');
      print(response);
      print('===============================================');
      subCategoryData = List<SubCategoryData>.from(response['data']['data']
          .map((data) => SubCategoryData.fromJson(data)));
      _hasReachedMax = subCategoryData.length < perPage;
      if (response['success'] == true) {
        emit(SubCategoryLoaded(
            message: response['message'],
            subCategoryData: subCategoryData,
            isLoadingMore: false));
      } else if (response['success'] == false) {
        emit(SubCategoryFailed(error: response['message']));
      } else {
        emit(SubCategoryFailed(error: response['message']));
      }
    } catch (e) {
      emit(SubCategoryFailed(error: e.toString()));
    }
  }

  Future<void> _onFetchMoreSubCategory(
      FetchMoreSubCategory event, Emitter<SubCategoryState> emit) async {
    // Prevent multiple simultaneous calls
    if (_hasReachedMax || loadMore) return;

    final currentState = state;
    if (currentState is SubCategoryLoaded) {
      // Set loading state
      loadMore = true;

      try {
        // Emit loading-more state for UI
        emit(SubCategoryLoaded(
          message: currentState.message,
          subCategoryData: currentState.subCategoryData,
          isLoadingMore: true,
        ));

        // Increment page BEFORE API call
        currentPage += 1;
        final response = await repository.fetchSubCategory(
            slug: selectedSlug,
            isForAllCategory: selectedIsForAllCategory,
            page: currentPage,
            perPage: perPage,
            isFiltered: true);

        final newSubCategoryData = List<SubCategoryData>.from(response['data']
                ['data']
            .map((data) => SubCategoryData.fromJson(data)));

        // Update hasReachedMax
        final currentTotal =
            int.parse(response['data']['current_page'].toString());
        final lastPageNum = int.parse(response['data']['last_page'].toString());
        _hasReachedMax =
            currentTotal >= lastPageNum || newSubCategoryData.length < perPage;

        // Remove duplicates when combining lists
        final updatedSubCategoryData =
            List<SubCategoryData>.from(currentState.subCategoryData);

        // Add only unique subcategories
        for (final newSubCategory in newSubCategoryData) {
          if (!updatedSubCategoryData
              .any((existing) => existing.id == newSubCategory.id)) {
            updatedSubCategoryData.add(newSubCategory);
          }
        }

        if (response['success'] == true) {
          emit(SubCategoryLoaded(
            message: response['message'],
            subCategoryData: updatedSubCategoryData,
            isLoadingMore: false,
          ));
        } else {
          emit(SubCategoryFailed(error: response['message']));
        }
      } catch (e) {
        currentPage -= 1;
        emit(SubCategoryFailed(error: e.toString()));
      } finally {
        loadMore = false;
      }
    }
  }
}
