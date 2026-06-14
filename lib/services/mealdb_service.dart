import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class MealDbService {
  MealDbService._();

  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static Future<List<Recipe>> searchRecipes(String query) async {
    final uri = Uri.parse('$_baseUrl/search.php?s=${Uri.encodeComponent(query)}');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load recipes');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = decoded['meals'];

    if (meals == null) return [];

    return (meals as List)
        .map((item) => Recipe.fromMealDb(item as Map<String, dynamic>))
        .toList();
  }

  static Future<List<Recipe>> homeRecipes() async {
    final queries = ['chicken', 'pasta', 'rice', 'paneer'];
    final allRecipes = <Recipe>[];
    final usedIds = <String>{};

    for (final query in queries) {
      final recipes = await searchRecipes(query);
      for (final recipe in recipes.take(8)) {
        if (usedIds.add(recipe.id)) {
          allRecipes.add(recipe);
        }
      }
    }

    return allRecipes;
  }

  static Future<Recipe> getRecipeDetails(String recipeId) async {
    final uri = Uri.parse('$_baseUrl/lookup.php?i=$recipeId');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load recipe details');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = decoded['meals'];

    if (meals == null || (meals as List).isEmpty) {
      throw Exception('Recipe not found');
    }

    return Recipe.fromMealDb(meals.first as Map<String, dynamic>);
  }
}
