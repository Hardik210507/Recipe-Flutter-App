import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/mealdb_service.dart';
import '../widgets/recipe_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  Future<List<Recipe>>? _resultsFuture;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _resultsFuture = null;
      });
      return;
    }

    setState(() {
      _resultsFuture = MealDbService.searchRecipes(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search Recipes',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,

              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    _resultsFuture = null;
                  });
                }
              },

              onSubmitted: (_) => _search(),

              decoration: InputDecoration(
                hintText: 'Search chicken, pasta, rice...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _search,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: _resultsFuture == null
                  ? const Center(child: Text('Search for any recipe from TheMealDB'))
                  : FutureBuilder<List<Recipe>>(
                      future: _resultsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          print("SEARCH ERROR: ${snapshot.error}");
                          return SingleChildScrollView(
                            child: Text(
                              snapshot.error.toString(),
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        final recipes = snapshot.data ?? [];
                        if (recipes.isEmpty) {
                          return const Center(child: Text('No matching recipes found'));
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
