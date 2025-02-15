part of 'translate_cubit.dart';

sealed class TranslateState {}

final class TranslateInitial extends TranslateState {}

final class TranslateLoading extends TranslateState {}

final class TranslateError extends TranslateState {
  final String error;

  TranslateError({required this.error});
}

final class TranslateLoaded extends TranslateState {
  final String translate;
  TranslateLoaded({required this.translate});
}
