import 'package:bloc/bloc.dart';
import 'package:dr_fit/core/network/api/recipe_api/recipe.dart';
import 'package:dr_fit/core/network/api/translate/translotor.dart';
import 'package:dr_fit/features/recipe/model/recipe_model.dart';

part 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  RecipeCubit() : super(RecipeInitial());

  List<String> title = [];
  List<List<String>> instructions = [];
  List<List<String>> ingredients = [];
  List<String> titles = [];
  var recipe;

  Future<void> fetchHealthyRecipes() async {
    emit(RecipeLoading());

    try {
      instructions = [];
      ingredients = [];
      titles = [];

      final recipes = await ApiService().getHealthyRecipes();
      recipe = recipes;
      // استخدام async/await بشكل صحيح بدلاً من forEach
      for (var recipe in recipes) {
        // ترجمة التعليمات
        List<Future<String>> translationInstruction =
            recipe.instructions.map((element) {
          //log("Translating instruction: $element");
          return Translator.translated(message: element);
        }).toList();
        instructions.add(await Future.wait(translationInstruction));

        // ترجمة المكونات
        List<Future<String>> translationIngredients =
            recipe.ingredients.map((element) {
          // log("Translating ingredient: $element");
          return Translator.translated(message: element);
        }).toList();
        ingredients.add(await Future.wait(translationIngredients));
      }

      // ترجمة العناوين
      List<Future<String>> translationTitle = recipes.map((recipe) {
        return Translator.translated(message: recipe.name);
      }).toList();
      titles = await Future.wait(translationTitle);

      // ارسال الحالة المحملة بعد الترجمة
      emit(RecipeLoaded(
        recipes: recipes,
        title: titles,
        ingredients: ingredients,
        instructions: instructions,
      ));
    } catch (e) {
      emit(RecipeError(e.toString()));
      print(e.toString());
    }
  }
}
