import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dr_fit/core/network/api/exercises_api/body_part.dart';
import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/context_extension.dart';
import 'package:dr_fit/core/utils/custom_appbar.dart';
import 'package:dr_fit/features/exercises/controller/exercise_cubit.dart';
import 'package:dr_fit/features/exercises/presentation/screens/exercises_view.dart';
import 'package:dr_fit/features/exercises/presentation/widgets/custom_separate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ExercisesType extends StatelessWidget {
  const ExercisesType({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ExerciseCubit>();
    List type = [
      "تمرين الصدر",
      " تمرين الظهر",
      "تمرين الخصر",
      "تمرين الأكتاف",
      "تمرين الرقبة",
      "تمرين الذراع العلوية",
      "تمرين الذراع السفلية",
      "تمرين الرجل العلوية",
      "تمرين الرجل السفلية",
      "تمرين الكرديو",
    ];
    List target = [
      BodyPart.chest,
      BodyPart.back,
      BodyPart.waist,
      BodyPart.shoulders,
      BodyPart.neck,
      BodyPart.upperArms,
      BodyPart.lowerArms,
      BodyPart.upperLegs,
      BodyPart.lowerLegs,
      BodyPart.cardio,
    ];
    List image = [
      'https://www.mundofitness.com/wp-content/uploads/Incline_Dumbbell_Bench_Press_Starting.jpg',
      'https://www.bodybuildingreviews.com/wp-content/uploads/best-trap-exercises.webp',
      'https://www.mundofitness.com/wp-content/uploads/Incline_Dumbbell_Bench_Press_Starting.jpg',
      'https://www.mundofitness.com/wp-content/uploads/Incline_Dumbbell_Bench_Press_Starting.jpg',
      'https://tfclarkfitnessmagazine.com/wp-content/uploads/2020/10/Become-a-Bodybuilder-How-to-Train-a-Comprehensive-Guide.jpg',
      'https://www.mundofitness.com/wp-content/uploads/Incline_Dumbbell_Bench_Press_Starting.jpg',
      'https://www.mundofitness.com/wp-content/uploads/Incline_Dumbbell_Bench_Press_Starting.jpg',
      'https://www.mundofitness.com/wp-content/uploads/Incline_Dumbbell_Bench_Press_Starting.jpg',
      'https://www.mundofitness.com/wp-content/uploads/Incline_Dumbbell_Bench_Press_Starting.jpg',
      'https://www.mundofitness.com/wp-content/uploads/Incline_Dumbbell_Bench_Press_Starting.jpg',
    ];
    return BlocListener<ExerciseCubit, ExerciseState>(
      listener: (context, state) {
        if (state is ExerciseSuccess) {
          navigateTo(
            context,
            ExercisesView(
              exercise: state.exercise,
            ),
          );
        }
      },
      child: BlocBuilder<ExerciseCubit, ExerciseState>(
        builder: (context, state) {
          return Scaffold(
            appBar: customAppBar(context),
            backgroundColor: kPrimaryColor,
            body: ConditionalBuilder(
              condition: state is ExerciseLoading,
              builder: (context) => Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textDirection: TextDirection.rtl,
                      'أنتظر لحظة من فضلك\n     جاري التحميل..',
                      style: TextStyle(
                          color: buttonPrimaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: context.height * .1,
                    ),
                    LoadingAnimationWidget.progressiveDots(
                      color: buttonPrimaryColor,
                      size: 100,
                    ),
                  ],
                ),
              ),
              fallback: (context) => ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      await cubit.getExerciseByBody(
                        target: target[index],
                        context: context,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: buttonPrimaryColor,
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurStyle: BlurStyle.outer,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      height: 120,
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        textDirection: TextDirection.rtl,
                        children: [
                          Image(
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                            image: NetworkImage(
                              image[index],
                            ),
                          ),
                          Text(
                            type[index],
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: target.length,
                separatorBuilder: (BuildContext context, int index) {
                  return customSeparate();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
