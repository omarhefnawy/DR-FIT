import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/exercises/model/exercise_model.dart';
import 'package:dr_fit/features/exercises/presentation/screens/exercises_info.dart';
import 'package:flutter/material.dart';

Widget customCard({required Exercise exercise, required context}) {
  return InkWell(
    onTap: () {
      navigateTo(
          context,
          ExercisesInfo(
            exercises: exercise,
          ));
    },
    child: Container(
      height: 100,
      alignment: Alignment.center,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: buttonPrimaryColor,
        borderRadius: BorderRadius.circular(
          10,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurStyle: BlurStyle.outer,
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          overflow: TextOverflow.ellipsis,
        ),
        subtitleTextStyle: TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            exercise.gifUrl,
          ),
          radius: 30,
        ),
        title: Text(exercise.name),
        subtitle: Text(exercise.target),
      ),
    ),
  );
}
