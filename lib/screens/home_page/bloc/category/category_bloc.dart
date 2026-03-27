import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hyper_local/screens/home_page/bloc/category/category_event.dart';
import 'package:hyper_local/screens/home_page/bloc/category/category_state.dart';
import 'package:hyper_local/screens/home_page/model/category_model.dart';
import 'package:hyper_local/screens/home_page/repo/category_repo.dart';
import '../../../../utils/widgets/cache_manager.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<FetchCategory>(_onFetchCategory);
    on<FetchMoreCategory>(_onFetchMoreCategory);
  }
  int currentPage = 0;
  int perPage = 0;
  int? lastPage;
  bool loadMore = false;
  final CategoryRepository repository = CategoryRepository();
  final DefaultCacheManager cacheManager = DefaultCacheManager();

  Future<void> _onFetchCategory(
      FetchCategory event, Emitter<CategoryState> emit) async {
    try {
      List<CategoryData> categoryData = [];
      perPage = 30;
      currentPage = 1;
      loadMore = false;
      final response = await repository.fetchCategory(
          perPage: perPage, currentPage: currentPage);
      print('========== CATEGORY API RESPONSE ==========');
      print(response);
      print('===========================================');
      categoryData = List<CategoryData>.from(
          response['data']['data'].map((data) => CategoryData.fromJson(data)));
      for (var category in categoryData) {
        final urls = [
          category.backgroundImage,
          category.icon,
          category.banner,
          category.image,
        ];
        for (var url in urls) {
          if (url?.isNotEmpty == true) {
            customCacheManager.downloadFile(url!);
          }
        }
      }

      currentPage += 1;
      if (response['success'] != null) {
        if (response['success'] == true) {
          emit(CategoryLoaded(
              message: response['message'], categoryData: categoryData));
        } else if (response['success'] == false) {
          emit(CategoryFailed(error: response['message']));
        }
      } else {
        emit(CategoryFailed(error: response['message']));
      }
    } catch (e) {
      emit(CategoryFailed(error: e.toString()));
    }
  }

  Future<void> _onFetchMoreCategory(
      FetchMoreCategory event, Emitter<CategoryState> emit) async {
    try {} catch (e) {
      emit(CategoryFailed(error: e.toString()));
    }
  }
}
