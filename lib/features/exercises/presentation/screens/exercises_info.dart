import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/context_extension.dart';
import 'package:dr_fit/core/utils/custom_appbar.dart';
import 'package:dr_fit/features/exercises/model/exercise_model.dart';
import 'package:dr_fit/features/exercises/presentation/widgets/custom_separate.dart';
import 'package:flutter/material.dart';

class ExercisesInfo extends StatelessWidget {
  ExercisesInfo({super.key, required this.exercises});
  Exercise exercises;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      backgroundColor: kPrimaryColor,
      body: ListView(
        shrinkWrap: false,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                Text(
                  exercises.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '   :العضلة المستهدفة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  exercises.target,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '   :العضلات المساعدة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      (convertList(exercises.secondaryMuscles)),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: context.width * 1.5,
                  height: context.height * .4,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: buttonPrimaryColor,
                        blurStyle: BlurStyle.outer,
                        blurRadius: 5,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        exercises.gifUrl,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                customSeparate(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      '   :المعدات اللازمة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      exercises.equipment,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    ' ازاي تلعب التمرين؟',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    convertList(exercises.instructions),
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String convertList(List string) {
  int i = 1;
  String s = '';
  for (var e in string) {
    s += ('$i - ');
    s = s + e;
    s += '\n';
    i++;
  }
  return s;
}
