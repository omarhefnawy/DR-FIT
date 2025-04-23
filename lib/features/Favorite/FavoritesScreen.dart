import 'package:dr_fit/features/Favorite/cubit/favorite_cubit.dart';
import 'package:dr_fit/features/exercises/model/exercise_model.dart';
import 'package:dr_fit/features/exercises/presentation/screens/exercises_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/custom_appbar.dart';
import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/features/exercises/controller/controller_translate/translate_cubit.dart';
import 'package:dr_fit/features/exercises/presentation/widgets/custom_card.dart';
import 'package:dr_fit/features/exercises/presentation/widgets/custom_separate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var translateCubit = context.read<TranslateCubit>();
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(title: Text('المفضله'),backgroundColor: kPrimaryColor,),
      body: StreamBuilder<List<Exercise>>(
        stream: context.read<FavoriteCubit>().getFavoritesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: kPrimaryColor,
                size: 20,
                secondRingColor: kSecondryColor,
              ),
            );
          }

          final favorites = snapshot.data!;
          if (favorites.isEmpty) {
            return Center(child: Text('لا توجد تمارين مفضلة بعد.'));
          }

          return ListView.separated(
            itemCount: favorites.length,
            separatorBuilder: (context, index) => customSeparate(),
            itemBuilder: (context, index) {
              final exercise = favorites[index];
              return InkWell(
                onTap: () {
                  translateCubit.getTranslated(messages: exercise.instructions);
                  navigateTo(
                    context,
                    ExercisesInfo(exercises: exercise),
                  );
                },
                child: customCard(exercise: exercise, context: context),
              );
            },
          );
        },
      ),
    );
  }
}
