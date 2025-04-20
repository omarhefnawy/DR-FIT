import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/recipe/controller/recipe_cubit.dart';
import 'package:dr_fit/features/recipe/model/recipe_model.dart';
import 'package:dr_fit/features/recipe/presentation/screen/recipe_details.dart';

class RecipeView extends StatelessWidget {
  const RecipeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      child: LoadingAnimationWidget.progressiveDots(
        color: buttonPrimaryColor,
        size: 100,
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
        return _buildRecipeItem(
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

  Widget _buildRecipeItem(
    BuildContext context, {
    required List<Recipe> recipes,
    required int index,
    required List<String> title,
    required List<List<String>> instructions,
    required List<List<String>> ingredients,
  }) {
    final recipe = recipes[index];

    return GestureDetector(
      onTap: () => _navigateToRecipeDetails(
        context,
        recipe: recipe,
        title: title[index],
        ingredients: ingredients[index],
        instructions: instructions[index],
      ),
      child: _buildRecipeCard(recipe, title[index]),
    );
  }

  void _navigateToRecipeDetails(
    BuildContext context, {
    required Recipe recipe,
    required String title,
    required List<String> instructions,
    required List<String> ingredients,
  }) {
    navigateTo(
        context,
        RecipeDetailPage(
          data: recipe,
          title: title,
          ingredients: ingredients,
          instructions: instructions,
        ));
  }

  Widget _buildRecipeCard(Recipe recipe, String title) {
    return Card(
      elevation: 5,
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(
          10,
        ),
        decoration: BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          // textDirection: TextDirection.rtl,
          children: [
            _buildRecipeImage(recipe.image),
            const SizedBox(width: 10),
            _buildRecipeDetails(recipe, title),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeImage(String imageUrl) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildRecipeDetails(Recipe recipe, String title) {
    return Expanded(
      child: Column(
        // textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            recipe.name,
            //textDirection: TextDirection.rtl,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontFamily: 'Inter'),
          ),
          Text(
            '${recipe.cuisine} Cuisine',
            //textDirection: TextDirection.rtl,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w300, fontFamily: 'Inter'),
          ),
          _buildRecipeInfo(recipe),
        ],
      ),
    );
  }

  Widget _buildRecipeInfo(Recipe recipe) {
    return Row(
      children: [
        const Icon(
          Icons.local_fire_department,
          color: Colors.deepOrange,
        ),
        const SizedBox(width: 5),
        Text('${recipe.caloriesPerServing} calories',
            style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 10),
        const Icon(
          Icons.alarm,
          size: 14,
          color: Colors.green,
        ),
        const SizedBox(width: 5),
        Text('${recipe.cookTimeMinutes + recipe.prepTimeMinutes} min',
            style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}