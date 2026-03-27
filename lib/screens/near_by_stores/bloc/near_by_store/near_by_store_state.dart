part of 'near_by_store_bloc.dart';

sealed class NearByStoreState extends Equatable {
  const NearByStoreState();
  @override
  List<Object?> get props => [];
}

final class NearByStoreInitial extends NearByStoreState {}

final class NearByStoreLoading extends NearByStoreState {}

final class NearByStoreLoaded extends NearByStoreState {
  final String msg;
  final Data stores;
  final bool hasReachedMax;
  final int totalStores;
  final bool isLoading;

  const NearByStoreLoaded({
    required this.msg,
    required this.stores,
    this.hasReachedMax = false,
    required this.totalStores,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [msg, stores, hasReachedMax, totalStores, isLoading];
}

final class NearByStoreFailed extends NearByStoreState {
  final String error;
  const NearByStoreFailed({required this.error});
  @override
  List<Object?> get props => [error];
}