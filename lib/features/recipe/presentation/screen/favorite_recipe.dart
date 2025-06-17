import 'package:dr_fit/features/recipe/controller/recipe_cubit.dart';
import 'package:dr_fit/features/recipe/model/recipe_model.dart';
import 'package:dr_fit/features/recipe/presentation/screen/recipe_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/utils/component.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/custom_appbar.dart';
import '../../../exercises/presentation/widgets/custom_separate.dart';
import '../widgets/recipe_cards.dart';

class FavoriteRecipe extends StatelessWidget {
  const FavoriteRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: customAppBar(context),
      body: StreamBuilder<List<Recipe>>(
        stream: context.read<RecipeCubit>().getFavoritesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: kPrimaryColor,
                size: 20,
                secondRingColor: kSecondaryColor,
              ),
            );
          }

          final favorites = snapshot.data!;
          if (favorites.isEmpty) {
            return Center(child: Text('لا توجد وجبات مفضلة بعد.'));
          }

          return ListView.separated(
            itemCount: favorites.length,
            separatorBuilder: (context, index) => customSeparate(),
            itemBuilder: (context, index) {
              final recipes = favorites[index];
              return InkWell(
                onTap: () {
                  navigateTo(context, RecipeDetailPage(data: recipes));
                },
                child:
                    buildRecipeItem(context, recipes: favorites, index: index),
              );
            },
          );
        },
      ),
    );
  }
}
