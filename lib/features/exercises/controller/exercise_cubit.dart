import 'package:bloc/bloc.dart';
import 'package:dr_fit/core/network/api/dio_consumer.dart';
import 'package:dr_fit/core/network/api/translotor.dart';
import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/features/exercises/model/exercise_model.dart';
import 'package:dr_fit/features/exercises/presentation/screens/exercises_view.dart';
import 'package:meta/meta.dart';

part 'exercise_state.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  ExerciseCubit() : super(ExerciseInitial());

  List<Exercise> exercises = [];

  Future<void> getExerciseByBody(
      {required String target, required dynamic context}) async {
    emit(ExerciseLoading());
    try {
      exercises.clear();
      print(state);
      final response =
          await DioConsumer().getExerciseByBodyPart(targetPart: target);

      if (response?.isEmpty ?? true) {
        throw Exception("API returned an empty response");
      }

      response.forEach((element) {
        exercises.add(Exercise.fromJson(element));
      });
      emit(ExerciseSuccess(exercises));
      print('Fetched ${exercises.length} exercises successfully.');
    } catch (e, stackTrace) {
      print("Error fetching exercises: ${e.toString()}\n$stackTrace");
      emit(ExerciseError(e.toString()));
    }
  }
}
