import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dr_fit/features/recipe/model/recipe_model.dart' show Recipe;
import 'recipe.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://dummyjson.com/recipes';

  Future<List<Recipe>> getHealthyRecipes() async {
    try {
      final response = await _dio.get(
        baseUrl,
        queryParameters: {
          'tags': 'healthy',
          'limit': 100,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> recipesJson = response.data['recipes'];

        final allRecipes =
            recipesJson.map((json) => Recipe.fromJson(json)).toList();
        log(allRecipes.length.toString());
        // ✅ فلترة الوصفات الصحية
        final healthyRecipes =
            allRecipes.where((r) => r.caloriesPerServing <= 500).toList();
        log(healthyRecipes.length.toString());
        return healthyRecipes;
      } else {
        throw Exception('فشل في تحميل الوصفات');
      }
    } catch (e) {
      throw Exception('خطأ أثناء الاتصال: $e');
    }
  }
}
