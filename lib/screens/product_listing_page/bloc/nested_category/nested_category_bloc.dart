import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home_page/model/sub_category_model.dart';
import '../../../home_page/repo/sub_category_repo.dart';

part 'nested_category_event.dart';
part 'nested_category_state.dart';

class NestedCategoryBloc extends Bloc<NestedCategoryEvent, NestedCategoryState> {
  NestedCategoryBloc() : super(NestedCategoryInitial()) {
    on<FetchNestedCategory>(_onFetchNestedCategory);
  }

  int currentPage = 0;
  int perPage = 0;
  int? lastPage;
  bool loadMore = false;
  final SubCategoryRepository repository = SubCategoryRepository();

  Future<void> _onFetchNestedCategory(FetchNestedCategory event, Emitter<NestedCategoryState> emit) async {
    emit(NestedCategoryLoading());
    try{
      List<SubCategoryData> subCategoryData = [];
      perPage = 30;
      currentPage = 1;
      loadMore = false;
      final response = await repository.fetchSubCategory(slug: event.slug,  isForAllCategory: false, perPage: perPage, page: currentPage);
      subCategoryData = List<SubCategoryData>.from(response['data']['data'].map((data) => SubCategoryData.fromJson(data)));
      currentPage += 1;
      if(response['success'] == true){
        emit(NestedCategoryLoaded(
            message: response['message'],
            subCategoryData: subCategoryData
        ));
      } else if (response['error'] == true){
        emit(NestedCategoryFailed(error: response['message']));
      }
    }catch(e){
      emit(NestedCategoryFailed(error: e.toString()));
    }
  }

}
