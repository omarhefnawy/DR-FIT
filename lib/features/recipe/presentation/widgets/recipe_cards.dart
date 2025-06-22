import 'dart:math';

import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/features/recipe/model/recipe_model.dart';
import 'package:dr_fit/features/recipe/presentation/screen/recipe_details.dart'
    show RecipeDetailPage;
import 'package:flutter/material.dart';

List<int> generated = [];
int getRandom() {
  if (generated.length == 3) {
    generated = [];
  }
  int a;
  var r = Random.secure();
  do {
    a = (r.nextInt(48));
  } while (generated.contains(a) && generated.length < 3);
  generated.add(a);
  return a;
}

Widget buildRecipeItem(
  BuildContext context, {
  required List<Recipe> recipes,
  required int index,
  bool isDaily = false,
}) {
  final recipe = recipes[index];
  int a = getRandom();
  return GestureDetector(
    onTap: () => _navigateToRecipeDetails(
      context,
      recipe: isDaily ? recipes[a] : recipe,
    ),
    child: isDaily
        ? _buildRecipeCard(
            recipes[a],
          )
        : _buildRecipeCard(
            recipe,
          ),
  );
}

void _navigateToRecipeDetails(
  BuildContext context, {
  required Recipe recipe,
}) {
  navigateTo(
    context,
    RecipeDetailPage(
      data: recipe,
    ),
  );
}

Widget _buildRecipeCard(
  Recipe recipe,
) {
  return Card(
    elevation: 5,
    child: Container(
      height: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _buildRecipeImage(recipe.image),
          const SizedBox(width: 10),
          _buildRecipeDetails(recipe),
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

Widget _buildRecipeDetails(
  Recipe recipe,
) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          recipe.name,
          style:
              const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter'),
        ),
        Text(
          '${recipe.cuisine} Cuisine',
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
      Text('${recipe.cookTimeMinutes + (recipe.prepTimeMinutes)} min',
          style: const TextStyle(fontSize: 12)),
    ],
  );
}
