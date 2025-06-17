import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/custom_appbar.dart';
import 'package:dr_fit/features/recipe/controller/recipe_cubit.dart';
import 'package:dr_fit/features/recipe/presentation/widgets/recipe_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RandomPlanPage extends StatelessWidget {
  const RandomPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: customAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'خطة الوجبات العشوائيه',
              style: TextStyle(
                color: buttonPrimaryColor,
                fontSize: 28,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(
                bottom: 5,
                right: 18,
              ),
              child: Text(
                textDirection: TextDirection.rtl,
                'الفطار',
                style: TextStyle(
                  color: buttonPrimaryColor.withOpacity(.7),
                  fontSize: 24,
                ),
              ),
            ),
            BlocBuilder<RecipeCubit, RecipeState>(
              builder: (context, state) {
                if (state is RecipeLoaded) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (_, index) =>
                        separateWidget(index: index),
                    itemBuilder: (context, index) {
                      return buildRecipeItem(
                        context,
                        recipes: state.recipes,
                        index: index,
                        isDaily: true,
                      );
                    },
                  );
                }
                return const Center(
                  child: Text('Failed to load recipes',
                      style: TextStyle(color: Colors.red)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget separateWidget({required index}) {
    var titles = [
      'الغداء',
      'العشاء',
    ];
    return Padding(
      padding: EdgeInsets.only(right: 18, top: 5, bottom: 5),
      child: Column(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textDirection: TextDirection.rtl,
            titles[index],
            style: TextStyle(
              color: buttonPrimaryColor.withOpacity(.7),
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
