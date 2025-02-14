part of 'exercise_cubit.dart';

@immutable
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
