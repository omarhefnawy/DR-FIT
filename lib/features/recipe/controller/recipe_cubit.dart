import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/core/network/api/recipe_api/recipe.dart';
import 'package:dr_fit/core/network/api/translate/translotor.dart';
import 'package:dr_fit/features/recipe/model/recipe_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  RecipeCubit() : super(RecipeInitial());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
      // for (var recipe in recipes) {
      //   // ترجمة التعليمات
      //   // List<Future<String>> translationInstruction =
      //   //     recipe.instructions.map((element) {
      //   //   //log("Translating instruction: $element");
      //   //   return Translator.translated(message: element);
      //   // }).toList();
      //   // instructions.add(await Future.wait(translationInstruction));
      //
      //   // ترجمة المكونات
      //   // List<Future<String>> translationIngredients =
      //   //     recipe.ingredients.map((element) {
      //   //   // log("Translating ingredient: $element");
      //   //   return Translator.translated(message: element);
      //   // }).toList();
      //   // ingredients.add(await Future.wait(translationIngredients));
      // }

      // ترجمة العناوين
      // List<Future<String>> translationTitle = recipes.map((recipe) {
      //   return Translator.translated(message: recipe.name);
      // }).toList();
      // titles = await Future.wait(translationTitle);

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

  Future<void> toggleFavorite(Recipe recipe) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      final docRef = _firestore
          .collection('favoritesRecipes')
          .doc(userId)
          .collection('recipe')
          .doc(recipe.id.toString());

      final docExists = await docRef.get().then((doc) => doc.exists);

      if (docExists) {
        await docRef.delete(); // إزالة من المفضلة
      } else {
        await docRef.set(recipe.toJson()); // ✅ يتم حفظ كل المعلومات الآن
      }

      emit(FavoriteUpdated());
    } catch (e) {
      log(e.toString());
      emit(FavoriteError(e.toString()));
    }
  }

  Stream<List<Recipe>> getFavoritesStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.empty();

    return _firestore
        .collection('favoritesRecipes')
        .doc(userId)
        .collection('recipe')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Recipe.fromJson(doc.data())).toList());
  }
}
