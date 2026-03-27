part of 'near_by_store_bloc.dart';

sealed class NearByStoreEvent extends Equatable {
  const NearByStoreEvent();
  @override
  List<Object?> get props => [];
}

final class FetchNearByStores extends NearByStoreEvent {
  final int page;
  final int perPage;
  final String searchQuery;

  const FetchNearByStores({
    this.page = 1,
    this.perPage = 15,
    required this.searchQuery
  });

  @override
  List<Object?> get props => [page, perPage, searchQuery];
}

final class LoadMoreNearByStores extends NearByStoreEvent {
  final int perPage;
  final String searchQuery;

  const LoadMoreNearByStores({
    this.perPage = 15,
    required this.searchQuery
  });

  @override
  List<Object?> get props => [perPage, searchQuery];
}