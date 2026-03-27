part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {}

class FetchSettingsData extends SettingsEvent {
  final BuildContext context;
  FetchSettingsData({required this.context});
  @override
  List<Object?> get props => [context];
}