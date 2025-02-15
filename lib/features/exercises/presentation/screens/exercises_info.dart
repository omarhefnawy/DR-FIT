import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/context_extension.dart';
import 'package:dr_fit/core/utils/custom_appbar.dart';
import 'package:dr_fit/features/exercises/controller/exercise_cubit.dart';
import 'package:dr_fit/features/exercises/controller/controller_translate/translate_cubit.dart';
import 'package:dr_fit/features/exercises/model/exercise_model.dart';
import 'package:dr_fit/features/exercises/presentation/widgets/custom_separate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ExercisesInfo extends StatelessWidget {
  ExercisesInfo({
    super.key,
    required this.exercises,
  });

  Exercise exercises;
  String translated = '';
  @override
  Widget build(BuildContext context) {
    var cubit = TranslateCubit();
    return BlocBuilder<TranslateCubit, TranslateState>(
      builder: (context, state) {
        if (state is TranslateLoaded) {
          translated = state.translate;
        }
        return Scaffold(
          appBar: customAppBar(context),
          backgroundColor: kPrimaryColor,
          body: ConditionalBuilder(
            condition: state is TranslateLoading,
            fallback: (context) => ListView(
              shrinkWrap: false,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          exercises.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          exercises.target,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
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
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              (cubit.convertList(exercises.secondaryMuscles)),
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
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
                          Spacer(),
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
                          textDirection: TextDirection.rtl,
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
                          translated.toString(),
                          textDirection: TextDirection.rtl,
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
            builder: (context) => Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textDirection: TextDirection.rtl,
                    '     جاري التحميل..   ',
                    style: TextStyle(
                        color: buttonPrimaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: context.height * .1,
                  ),
                  LoadingAnimationWidget.flickr(
                    leftDotColor: buttonPrimaryColor,
                    rightDotColor: bottomNavigationBar,
                    size: 100,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
