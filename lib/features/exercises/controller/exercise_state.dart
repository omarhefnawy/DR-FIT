part of 'exercise_cubit.dart';

sealed class ExerciseState {}

final class ExerciseInitial extends ExerciseState {}

final class ExerciseLoading extends ExerciseState {}

final class ExerciseSuccess extends ExerciseState {
  List<Exercise> exercise;
  ExerciseSuccess(this.exercise);
}

final class ExerciseError extends ExerciseState {
  String error;
  ExerciseError(this.error);
}

final class TranslatedLoading extends ExerciseState {}

final class TranslatedLoaded extends ExerciseState {
  List<String> translate;
  TranslatedLoaded({required this.translate});
}

final class TranslatedError extends ExerciseState {
  String error;
  TranslatedError(this.error);
}
