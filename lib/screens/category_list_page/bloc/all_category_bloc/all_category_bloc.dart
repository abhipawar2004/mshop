import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home_page/model/sub_category_model.dart';
import '../../../home_page/repo/sub_category_repo.dart';
import 'all_category_event.dart';
import 'all_category_state.dart';

class AllCategoriesBloc extends Bloc<AllCategoriesEvent, AllCategoriesState>{
  AllCategoriesBloc() : super(AllCategoriesInitial()){
    on<FetchAllCategories>(_onFetchAllCategories);

    on<FetchMoreAllCategories>(_onFetchMoreAllCategories);
  }
  int currentPage = 0;
  int perPage = 0;
  int? lastPage;
  bool _hasReachedMax = false;
  bool loadMore = false;
  String selectedSlug = '';
  bool selectedIsForAllCategory = false;
  final SubCategoryRepository repository = SubCategoryRepository();

  Future<void> _onFetchAllCategories(FetchAllCategories event, Emitter<AllCategoriesState> emit) async {
    emit(AllCategoriesLoading());
    try{
      List<SubCategoryData> subCategoryData = [];
      perPage = 80;
      currentPage = 1;
      _hasReachedMax = false;
      loadMore = false;
      final response = await repository.fetchSubCategory(
        slug: '',
        isForAllCategory: true,
        perPage: perPage,
        page: currentPage,
        isFiltered: false
      );
      subCategoryData = List<SubCategoryData>.from(response['data']['data'].map((data) => SubCategoryData.fromJson(data)));
      _hasReachedMax = subCategoryData.length < perPage;
      if(response['success'] != null){
        if(response['success'] == true){
          emit(AllCategoriesLoaded(
              message: response['message'],
              subCategoryData: subCategoryData,
              isLoadingMore: false
          ));
        } else if (response['success'] == false){
          emit(AllCategoriesFailed(error: response['message']));
        }
      } else {
        emit(AllCategoriesFailed(error: response['message']));
      }

    }catch(e){
      emit(AllCategoriesFailed(error: e.toString()));
    }
  }

  Future<void> _onFetchMoreAllCategories(FetchMoreAllCategories event, Emitter<AllCategoriesState> emit) async {
    // Prevent multiple simultaneous calls
    if (_hasReachedMax || loadMore) return;

    final currentState = state;
    if (currentState is AllCategoriesLoaded) {
      // Set loading state
      loadMore = true;

      try {
        // Emit loading-more state for UI
        emit(AllCategoriesLoaded(
          message: currentState.message,
          subCategoryData: currentState.subCategoryData,
          isLoadingMore: true,
        ));

        // Increment page BEFORE API call
        currentPage += 1;
        final response = await repository.fetchSubCategory(
          slug: selectedSlug,
          isForAllCategory: true,
          page: currentPage,
          perPage: perPage,
        );

        final newSubCategoryData = List<SubCategoryData>.from(
            response['data']['data'].map((data) => SubCategoryData.fromJson(data))
        );

        // Update hasReachedMax
        final currentTotal = int.parse(response['data']['current_page'].toString());
        final lastPageNum = int.parse(response['data']['last_page'].toString());
        _hasReachedMax = currentTotal >= lastPageNum || newSubCategoryData.length < perPage;

        // Remove duplicates when combining lists
        final updatedSubCategoryData = List<SubCategoryData>.from(currentState.subCategoryData);

        // Add only unique subcategories
        for (final newSubCategory in newSubCategoryData) {
          if (!updatedSubCategoryData.any((existing) => existing.id == newSubCategory.id)) {
            updatedSubCategoryData.add(newSubCategory);
          }
        }

        if (response['success'] == true) {
          emit(AllCategoriesLoaded(
            message: response['message'],
            subCategoryData: updatedSubCategoryData,
            isLoadingMore: false,
          ));
        } else {
          emit(AllCategoriesFailed(error: response['message']));
        }

      } catch (e) {
        currentPage -= 1;
        emit(AllCategoriesFailed(error: e.toString()));
      } finally {
        loadMore = false;
      }
    }
  }
}