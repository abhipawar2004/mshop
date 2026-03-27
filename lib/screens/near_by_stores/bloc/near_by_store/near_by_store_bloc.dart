import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/near_by_stores/model/near_by_store_model.dart';
import 'package:hyper_local/screens/near_by_stores/repo/near_by_store_repo.dart';

part 'near_by_store_event.dart';
part 'near_by_store_state.dart';

class NearByStoreBloc extends Bloc<NearByStoreEvent, NearByStoreState> {
  NearByStoreBloc() : super(NearByStoreInitial()) {
    on<FetchNearByStores>(_onFetchNearByStores);
    on<LoadMoreNearByStores>(_onLoadMore);
  }

  final NearByStoreRepo repository = NearByStoreRepo();

  int currentPage = 1;
  int perPage = 15;
  bool hasReachedMax = false;
  bool isLoadingMore = false;
  int totalStores = 0;

  Future<void> _onFetchNearByStores(
      FetchNearByStores event,
      Emitter<NearByStoreState> emit,
      ) async {
    emit(NearByStoreLoading());
    try {
      // Reset pagination state
      currentPage = event.page;
      hasReachedMax = false;
      isLoadingMore = false;
      totalStores = 0;

      final response = await repository.getNearByStores(
        page: currentPage,
        perPage: event.perPage,
        searchQuery: event.searchQuery
      );

      if (response == null) {
        emit(const NearByStoreFailed(error: "Failed to fetch stores"));
        return;
      }

      final storeModel = NearByStoreModel.fromJson(response);

      if (storeModel.success == true && storeModel.data != null) {
        final stores = storeModel.data!.data ?? [];

        totalStores = storeModel.data!.total ?? 0;
        final currentPageNum = storeModel.data!.currentPage ?? 1;
        final lastPageNum = storeModel.data!.lastPage ?? 1;

        hasReachedMax = currentPageNum >= lastPageNum || stores.length < event.perPage;

        emit(NearByStoreLoaded(
          msg: storeModel.message ?? "",
          stores: storeModel.data!,
          hasReachedMax: hasReachedMax,
          totalStores: totalStores,
          isLoading: false,
        ));
      } else {
        emit(NearByStoreFailed(error: storeModel.message ?? "Unknown error"));
      }
    } catch (e) {
      emit(NearByStoreFailed(error: e.toString()));
    }
  }

  Future<void> _onLoadMore(
      LoadMoreNearByStores event,
      Emitter<NearByStoreState> emit,
      ) async {
    if (isLoadingMore) return;

    final currentState = state;
    if (currentState is NearByStoreLoaded && !currentState.hasReachedMax) {
      isLoadingMore = true;
      try {
        currentPage += 1;

        final response = await repository.getNearByStores(
          page: currentPage,
          perPage: event.perPage,
          searchQuery: event.searchQuery
        );

        if (response == null) {
          currentPage -= 1;
          return;
        }

        final newModel = NearByStoreModel.fromJson(response);
        if (newModel.success == true && newModel.data != null) {
          final newStores = newModel.data!.data ?? [];

          // Combine without duplicates (by id)
          final updatedStoreList = List<StoreData>.from(currentState.stores.data ?? []);
          for (final newStore in newStores) {
            if (!updatedStoreList.any((existing) => existing.id == newStore.id)) {
              updatedStoreList.add(newStore);
            }
          }

          final currentPageNum = newModel.data!.currentPage ?? currentPage;
          final lastPageNum = newModel.data!.lastPage ?? 1;
          hasReachedMax = currentPageNum >= lastPageNum || newStores.length < event.perPage;

          // Full copy of Data
          final updatedStores = Data(
            currentPage: newModel.data!.currentPage,
            data: updatedStoreList,
            total: newModel.data!.total,
            nextPageUrl: newModel.data!.nextPageUrl,
            firstPageUrl: newModel.data!.firstPageUrl,
            from: newModel.data!.from,
            lastPage: newModel.data!.lastPage,
            lastPageUrl: newModel.data!.lastPageUrl,
            links: newModel.data!.links,
            path: newModel.data!.path,
            perPage: newModel.data!.perPage,
            prevPageUrl: newModel.data!.prevPageUrl,
            to: newModel.data!.to,
          );

          emit(NearByStoreLoaded(
            msg: currentState.msg,
            stores: updatedStores,
            hasReachedMax: hasReachedMax,
            totalStores: newModel.data!.total ?? totalStores,
            isLoading: false,
          ));
        } else {
          currentPage -= 1;
        }
      } catch (e) {
        currentPage -= 1;
      } finally {
        isLoadingMore = false;
      }
    }
  }
}