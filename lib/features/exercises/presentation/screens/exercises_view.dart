import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/custom_appbar.dart';
import 'package:dr_fit/features/exercises/controller/controller_translate/translate_cubit.dart';
import 'package:dr_fit/features/exercises/model/exercise_model.dart';
import 'package:dr_fit/features/exercises/presentation/screens/exercises_info.dart';
import 'package:dr_fit/features/exercises/presentation/widgets/custom_card.dart';
import 'package:dr_fit/features/exercises/presentation/widgets/custom_separate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ExercisesView extends StatelessWidget {
  ExercisesView({
    super.key,
    required this.exercise,
  });

  List<Exercise> exercise;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranslateCubit, TranslateState>(
      builder: (context, state) {
        var cubit = context.read<TranslateCubit>();
        return Scaffold(
          backgroundColor: PrimaryColor(context),
          appBar: customAppBar(
            context,
          ),
          body: (exercise.isNotEmpty)
              ? ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        cubit.getTranslated(
                            messages: exercise[index].instructions);
                        navigateTo(
                            context,
                            ExercisesInfo(
                              exercises: exercise[index],
                            ));
                      },
                      child: customCard(
                        exercise: exercise[index],
                        context: context,
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return customSeparate();
                  },
                  itemCount: exercise.length,
                )
              : LoadingAnimationWidget.discreteCircle(
                  color: PrimaryColor(context),
                  size: 20,
                  secondRingColor: secondaryColor(context),
                ),
        );
      },
    );
  }
}
