import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recipe.dart';

class SavedRecipeService {
  SavedRecipeService._();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>> _savedCollection() {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('User is not logged in');
    }

    return _db.collection('users').doc(user.uid).collection('savedRecipes');
  }

  static Future<void> saveRecipe(Recipe recipe) async {
    await _savedCollection().doc(recipe.id).set(recipe.toFirestoreMap());
  }

  static Future<void> removeRecipe(String recipeId) async {
    await _savedCollection().doc(recipeId).delete();
  }

  static Future<bool> isSaved(String recipeId) async {
    final doc = await _savedCollection().doc(recipeId).get();
    return doc.exists;
  }

  static Stream<List<Recipe>> savedRecipesStream() {
    return _savedCollection()
        .orderBy('savedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Recipe.fromFirestore(doc.data()))
            .toList());
  }
}
