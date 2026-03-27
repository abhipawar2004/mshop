import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../config/global.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial()) {
    on<LoadLanguage>(_onLoadLanguage);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onLoadLanguage(LoadLanguage event, Emitter<LanguageState> emit) async {
    emit(LanguageLoading());
    try {
      final currentLanguage = Global.currentLanguage;
      final locale = Global.getLocaleFromLanguage(currentLanguage);
      emit(LanguageLoaded(locale: locale, languageCode: currentLanguage));
    } catch (e) {
      emit(LanguageError(message: e.toString()));
    }
  }

  Future<void> _onChangeLanguage(ChangeLanguage event, Emitter<LanguageState> emit) async {
    emit(LanguageLoading());
    try {
      await Global.setLanguage(event.languageCode);
      final locale = Global.getLocaleFromLanguage(event.languageCode);
      emit(LanguageLoaded(locale: locale, languageCode: event.languageCode));
    } catch (e) {
      emit(LanguageError(message: e.toString()));
    }
  }
} 