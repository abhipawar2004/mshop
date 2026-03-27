part of 'store_detail_bloc.dart';

abstract class StoreDetailEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchStoreDetail extends StoreDetailEvent {
  final String storeSlug;

  FetchStoreDetail({required this.storeSlug});

  @override
  // TODO: implement props
  List<Object?> get props => [storeSlug];
}
