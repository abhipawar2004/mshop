part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final SettingsResponse settingsResponse;
  SettingsLoaded({required this.settingsResponse});
  @override
  // TODO: implement props
  List<Object?> get props => [settingsResponse];
}

class SettingsFailure extends SettingsState {
  final String error;
  SettingsFailure({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}