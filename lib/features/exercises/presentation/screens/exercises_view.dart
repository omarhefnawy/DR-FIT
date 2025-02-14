import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/custom_appbar.dart';
import 'package:dr_fit/features/exercises/presentation/widgets/custom_card.dart';
import 'package:dr_fit/features/exercises/presentation/widgets/custom_separate.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ExercisesView extends StatelessWidget {
  ExercisesView({super.key, required this.exercises});
  List exercises;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: customAppBar(context),
      body: (exercises.isNotEmpty)
          ? ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return customCard(
                  exercise: exercises[index],
                  context: context,
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return customSeparate();
              },
              itemCount: exercises.length,
            )
          : LoadingAnimationWidget.discreteCircle(
              color: kPrimaryColor,
              size: 20,
              secondRingColor: kSecondryColor,
            ),
    );
  }
}
