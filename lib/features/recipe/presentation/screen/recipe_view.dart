import 'package:dr_fit/features/recipe/presentation/widgets/recipe_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/custom_appbar.dart';
import 'package:dr_fit/features/recipe/controller/recipe_cubit.dart';
import 'package:dr_fit/features/recipe/model/recipe_model.dart';

class RecipeView extends StatelessWidget {
  const RecipeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<RecipeCubit, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLoading) {
              return _buildLoadingIndicator();
            } else if (state is RecipeLoaded) {
              return _buildRecipeList(
                context,
                recipes: state.recipes,
                instructions: state.instructions,
                ingredients: state.ingredients,
                title: state.title,
              );
            }
            return _buildErrorWidget();
          },
        ),
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

  Widget _buildErrorWidget() {
    return const Center(
      child:
          Text('Failed to load recipes', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildRecipeList(
    BuildContext context, {
    required List<Recipe> recipes,
    required List<String> title,
    required List<List<String>> instructions,
    required List<List<String>> ingredients,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: recipes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return buildRecipeItem(
          context,
          recipes: recipes,
          index: index,
          title: title,
          instructions: instructions,
          ingredients: ingredients,
        );
      },
    );
  }
}
