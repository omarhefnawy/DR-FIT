import 'package:dio/dio.dart';
import 'package:dr_fit/features/recipe/model/recipe_model.dart';

class RecipeService {
  final Dio _dio = Dio();

  Future<List<Recipe>> fetchRecipes() async {
    try {
      Response response = await _dio.get('https://dummyjson.com/recipes');

      if (response.statusCode == 200) {
        List recipes = response.data['recipes']; // Access the "recipes" array
        return recipes.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }
}
