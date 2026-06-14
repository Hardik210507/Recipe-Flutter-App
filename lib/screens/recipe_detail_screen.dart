import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/recipe.dart';
import '../services/mealdb_service.dart';
import '../services/saved_recipe_service.dart';
import 'enquiry_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<Recipe> _recipeFuture;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _recipeFuture = MealDbService.getRecipeDetails(widget.recipeId);
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    try {
      final saved = await SavedRecipeService.isSaved(widget.recipeId);
      if (mounted) setState(() => _isSaved = saved);
    } catch (_) {}
  }

  Future<void> _toggleSave(Recipe recipe) async {
    try {
      if (_isSaved) {
        await SavedRecipeService.removeRecipe(recipe.id);
      } else {
        await SavedRecipeService.saveRecipe(recipe);
      }
      if (!mounted) return;
      setState(() => _isSaved = !_isSaved);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isSaved ? 'Recipe saved' : 'Recipe removed')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update saved recipe: $e')),
      );
    }
  }

  void _shareRecipe(Recipe recipe) {
    Share.share(
      'Check out this recipe: ${recipe.title}\n${recipe.imageUrl}\n\n${recipe.instructions}',
      subject: recipe.title,
    );
  }

  void _openOptions(Recipe recipe) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share recipe'),
                subtitle: const Text('Share through WhatsApp or any app'),
                onTap: () {
                  Navigator.pop(context);
                  _shareRecipe(recipe);
                },
              ),
              ListTile(
                leading: const Icon(Icons.mail_outline),
                title: const Text('Enquire about recipe'),
                subtitle: const Text('Fill form and send enquiry email'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EnquiryScreen(recipe: recipe)),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Recipe>(
        future: _recipeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final recipe = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                actions: [
                  IconButton(
                    onPressed: () => _toggleSave(recipe),
                    icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border),
                  ),
                  IconButton(
                    onPressed: () => _openOptions(recipe),
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(recipe.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  background: Image.network(
                    recipe.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image_not_supported_outlined)),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (recipe.category.isNotEmpty) Chip(label: Text(recipe.category)),
                          if (recipe.area.isNotEmpty) Chip(label: Text(recipe.area)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _toggleSave(recipe),
                              icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border),
                              label: Text(_isSaved ? 'Saved' : 'Save Recipe'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _openOptions(recipe),
                              icon: const Icon(Icons.more_horiz),
                              label: const Text('Options'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text('Ingredients', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      ...recipe.ingredients.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text('• $item'),
                          )),
                      const SizedBox(height: 24),
                      const Text('Instructions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      Text(
                        recipe.instructions.isEmpty ? 'No instructions available.' : recipe.instructions,
                        style: const TextStyle(height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
