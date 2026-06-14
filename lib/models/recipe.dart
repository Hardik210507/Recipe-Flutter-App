import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final String category;
  final String area;
  final String instructions;
  final List<String> ingredients;
  final String youtubeUrl;
  final String sourceUrl;

  const Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.category = '',
    this.area = '',
    this.instructions = '',
    this.ingredients = const [],
    this.youtubeUrl = '',
    this.sourceUrl = '',
  });

  factory Recipe.fromMealDb(Map<String, dynamic> json) {
    final ingredients = <String>[];

    for (int i = 1; i <= 20; i++) {
      final ingredient = (json['strIngredient$i'] ?? '').toString().trim();
      final measure = (json['strMeasure$i'] ?? '').toString().trim();

      if (ingredient.isNotEmpty) {
        ingredients.add(measure.isEmpty ? ingredient : '$measure $ingredient');
      }
    }

    return Recipe(
      id: (json['idMeal'] ?? '').toString(),
      title: (json['strMeal'] ?? 'Untitled Recipe').toString(),
      imageUrl: (json['strMealThumb'] ?? '').toString(),
      category: (json['strCategory'] ?? '').toString(),
      area: (json['strArea'] ?? '').toString(),
      instructions: (json['strInstructions'] ?? '').toString(),
      ingredients: ingredients,
      youtubeUrl: (json['strYoutube'] ?? '').toString(),
      sourceUrl: (json['strSource'] ?? '').toString(),
    );
  }

  factory Recipe.fromFirestore(Map<String, dynamic> data) {
    return Recipe(
      id: (data['id'] ?? '').toString(),
      title: (data['title'] ?? 'Recipe').toString(),
      imageUrl: (data['imageUrl'] ?? '').toString(),
      category: (data['category'] ?? '').toString(),
      area: (data['area'] ?? '').toString(),
      instructions: (data['instructions'] ?? '').toString(),
      ingredients: List<String>.from(data['ingredients'] ?? const []),
      youtubeUrl: (data['youtubeUrl'] ?? '').toString(),
      sourceUrl: (data['sourceUrl'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'category': category,
      'area': area,
      'instructions': instructions,
      'ingredients': ingredients,
      'youtubeUrl': youtubeUrl,
      'sourceUrl': sourceUrl,
      'savedAt': FieldValue.serverTimestamp(),
    };
  }
}
