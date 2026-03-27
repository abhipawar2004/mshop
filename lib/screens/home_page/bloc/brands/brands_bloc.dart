import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/home_page/model/brands_model.dart';

import '../../repo/brands_repo.dart';

part 'brands_event.dart';
part 'brands_state.dart';

class BrandsBloc extends Bloc<BrandsEvent, BrandsState> {
  BrandsBloc() : super(BrandsInitial()) {
    on<FetchBrands>(_onFetchBrands);
  }

  int currentPage = 0;
  int perPage = 0;
  int? lastPage;
  bool loadMore = false;
  final BrandsRepository repository = BrandsRepository();

  Future<void> _onFetchBrands(
      FetchBrands event, Emitter<BrandsState> emit) async {
    emit(BrandsLoading());
    try {
      List<BrandsData> brandsData = [];
      perPage = 18;
      currentPage = 1;
      loadMore = false;
      final response =
          await repository.fetchBrands(categorySlug: event.categorySlug);
      print('========== BRANDS API RESPONSE ==========');
      print(response);
      print('=========================================');
      brandsData = List<BrandsData>.from(
          response['data']['data'].map((data) => BrandsData.fromJson(data)));
      currentPage += 1;
      if (response['success'] != null && brandsData.isNotEmpty) {
        if (response['success'] == true) {
          emit(BrandsLoaded(
              message: response['message'], brandsData: brandsData));
        } else if (response['success'] == false) {
          emit(BrandsFailed(error: response['message']));
        }
      } else {
        emit(BrandsFailed(error: response['message']));
      }
    } catch (e) {
      emit(BrandsFailed(error: e.toString()));
    }
  }
}
