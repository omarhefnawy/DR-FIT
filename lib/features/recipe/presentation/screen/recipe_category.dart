import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/recipe/controller/recipe_cubit.dart';
import 'package:dr_fit/features/recipe/presentation/screen/random_plan_page.dart';
import 'package:dr_fit/features/recipe/presentation/screen/recipe_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class RecipeCategory extends StatelessWidget {
  const RecipeCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: BlocBuilder<RecipeCubit, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoading) {
            return _buildLoadingIndicator();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  navigateTo(context, RandomPlanPage());
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(20),
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  height: 190,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://www.heilpraxisnet.de/wp-content/uploads/2020/08/Fruehstueck-Abnehmen-1140x570.jpeg',
                      ),
                      fit: BoxFit.cover,
                      opacity: .6,
                    ),
                  ),
                  child: Text(
                    'خطة يومية عشوائية',
                    style: TextStyle(
                      fontSize: 30,
                      color: buttonPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  navigateTo(context, RecipeView());
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(20),
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://img.freepik.com/premium-photo/chicken-meal-photography_841014-8527.jpg',
                      ),
                      fit: BoxFit.cover,
                      opacity: .6,
                    ),
                  ),
                  child: Text(
                    'عرض كل الوصفات',
                    style: TextStyle(
                      fontSize: 30,
                      color: buttonPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          LoadingAnimationWidget.progressiveDots(
            color: buttonPrimaryColor,
            size: 50,
          ),
          Text(
            textDirection: TextDirection.rtl,
            '     جاري التحميل   ',
            style: TextStyle(
                color: buttonPrimaryColor,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
