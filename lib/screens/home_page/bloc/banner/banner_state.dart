import 'package:equatable/equatable.dart';
import 'package:hyper_local/screens/home_page/model/banner_model.dart';

abstract class BannerState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class BannerInitial extends BannerState {}

class BannerLoading extends BannerState {}

class BannerLoaded extends BannerState {
  final List<Top> topBannerData;
  final List<Top> middleBannerData;
  final String message;
  final bool hasReachedMax;

  BannerLoaded({
    required this.message,
    required this.topBannerData,
    required this.middleBannerData,
    required this.hasReachedMax,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message, topBannerData, middleBannerData, hasReachedMax];
}

class BannerFailed extends BannerState {
  final String error;

  BannerFailed({required this.error});

  @override
  List<Object?> get props => [error];
}