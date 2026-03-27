import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/config/constant.dart';
import '../../config/api_routes.dart';
import '../../config/settings_data_instance.dart';
import '../../model/settings_model/settings_model.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<FetchSettingsData>(_onFetchSettingsData);
  }

  Future<void> _onFetchSettingsData(
      FetchSettingsData event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final response = await AppConstant.apiBaseHelper
          .getAPICall(ApiRoutes.settingsApi, {}, context: event.context);
      if (response.statusCode == 200 && response.data['success'] == true) {
        final settingsResponse = SettingsResponse.fromJson(response.data);
        SettingsData().setSettingsData(settingsResponse.data);
        emit(SettingsLoaded(settingsResponse: settingsResponse));
        return;
      }

      emit(
        SettingsFailure(
          error:
              'Settings API failed: status=${response.statusCode}, success=${response.data['success']}',
        ),
      );
    } catch (e) {
      emit(SettingsFailure(error: e.toString()));
    }
  }
}
