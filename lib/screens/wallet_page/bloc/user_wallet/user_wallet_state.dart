part of 'user_wallet_bloc.dart';

abstract class UserWalletState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserWalletInitial extends UserWalletState {}

class UserWalletLoading extends UserWalletState {}

class UserWalletLoaded extends UserWalletState {
  final List<Wallet> userWallet;
  UserWalletLoaded({required this.userWallet});
  @override
  // TODO: implement props
  List<Object?> get props => [userWallet];
}

class UserWalletFailure extends UserWalletState {
  final String error;
  UserWalletFailure({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
