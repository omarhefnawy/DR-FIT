import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dr_fit/core/network/api/recipe_api/recipe.dart';
import 'package:dr_fit/core/network/api/translate/translotor.dart';
import 'package:dr_fit/features/recipe/model/recipe_model.dart';

part 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  RecipeCubit() : super(RecipeInitial());
  List<String> title = [];
  Future<void> fetchHealthyRecipes() async {
    emit(RecipeLoading());
    try {
      List<List<String>> instructions = [];
      List<List<String>> ingredients = [];
      List<String> titles = [];
      final recipes = await RecipeService().fetchRecipes();
      recipes.forEach((e) async {
        List<Future<String>> translationInstruction =
            e.instructions.map((element) {
          log("Translating instruction: $element");
          return Translator.translated(message: element);
        }).toList();
        instructions.add(await Future.wait(translationInstruction));
        List<Future<String>> translationIngredients =
            e.ingredients.map((element) {
          log("Translating ingredient: $element");
          return Translator.translated(message: element);
        }).toList();
        ingredients.add(await Future.wait(translationIngredients));
      });
      List<Future<String>> translationTitle = recipes.map((element) {
        log("Translating recipe title: ${element.name}");
        return Translator.translated(message: element.name);
      }).toList();
      titles = await Future.wait(translationTitle);
      emit(RecipeLoaded(
        recipes: recipes,
        title: titles,
        ingredients: ingredients,
        instructions: instructions,
      ));
    } catch (e) {
      emit(RecipeError(e.toString()));

      emit(RecipeError(e.toString()));
    }
  }
}
