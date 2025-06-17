part of 'recipe_cubit.dart';

abstract class RecipeState {}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;
  final List<String> title;
  final List<List<String>> instructions;
  final List<List<String>> ingredients;
  RecipeLoaded({
    required this.recipes,
    required this.title,
    required this.ingredients,
    required this.instructions,
  });
}

class RecipeError extends RecipeState {
  final String error;
  RecipeError(this.error);
}

class FavoriteUpdated extends RecipeState {}

class FavoriteError extends RecipeState {
  final String error;
  FavoriteError(this.error);
}
