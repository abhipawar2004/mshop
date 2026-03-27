part of 'language_bloc.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageLoading extends LanguageState {}

class LanguageLoaded extends LanguageState {
  final Locale locale;
  final String languageCode;

  const LanguageLoaded({
    required this.locale,
    required this.languageCode,
  });

  @override
  List<Object> get props => [locale, languageCode];
}

class LanguageError extends LanguageState {
  final String message;

  const LanguageError({required this.message});

  @override
  List<Object> get props => [message];
} 