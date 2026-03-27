
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hyper_local/bloc/theme_bloc/theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.light) {
    // Load the theme when the bloc is initialized
    on<ThemeChanged>((event, emit) {
      _saveTheme(event.themeMode);
      emit(event.themeMode);
    });
    _loadTheme();
  }
  void _saveTheme(ThemeMode theme) {
    final box = Hive.box('themebox');
    box.put('themeMode', theme.index);
  }
  void _loadTheme() async {
    final box = Hive.box('themebox');
    final themeIndex = box.get('themeMode', defaultValue: ThemeMode.light.index);
    // Emit the loaded theme as the initial state
    add(ThemeChanged(ThemeMode.values[themeIndex]));
  }
}