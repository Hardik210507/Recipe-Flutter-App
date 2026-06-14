import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/saved_recipe_service.dart';
import '../widgets/recipe_card.dart';

class SavedRecipesScreen extends StatelessWidget {
  const SavedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saved Recipes',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: StreamBuilder<List<Recipe>>(
                stream: SavedRecipeService.savedRecipesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final recipes = snapshot.data ?? [];
                  if (recipes.isEmpty) {
                    return const Center(child: Text('No saved recipes yet'));
                  }

                  return GridView.builder(
                    itemCount: recipes.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) => RecipeCard(recipe: recipes[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
