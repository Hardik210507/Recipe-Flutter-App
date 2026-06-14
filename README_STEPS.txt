RECIPE APP - SPLIT FILE VERSION
================================

This ZIP has the Recipe App code split into separate Dart files:

lib/main.dart
lib/models/recipe.dart
lib/services/auth_service.dart
lib/services/mealdb_service.dart
lib/services/saved_recipe_service.dart
lib/screens/splash_screen.dart
lib/screens/login_screen.dart
lib/screens/register_screen.dart
lib/screens/main_shell.dart
lib/screens/home_screen.dart
lib/screens/search_screen.dart
lib/screens/saved_recipes_screen.dart
lib/screens/profile_screen.dart
lib/screens/recipe_detail_screen.dart
lib/screens/enquiry_screen.dart
lib/widgets/recipe_card.dart
lib/widgets/app_text_field.dart

WHAT THIS VERSION DOES
----------------------
1. Login/Register using Firebase Authentication.
2. Stores user name/email in Firestore.
3. Loads recipes from TheMealDB API.
4. Shows recipes in GridView.
5. Opens recipe details with ingredients and instructions.
6. Saves recipes per logged-in user in Firestore.
7. Shows saved recipes from the database.
8. Profile screen shows the registered user's real name/email.
9. Recipe detail options include sharing and enquiry email.

IMPORTANT FIREBASE FILE
-----------------------
This ZIP does NOT include lib/firebase_options.dart because that file is unique to your Firebase project.

You must do ONE of these:

Option A:
Copy your existing firebase_options.dart into:
lib/firebase_options.dart

Option B:
Run this inside your project:
flutterfire configure

Then confirm this file exists:
lib/firebase_options.dart

HOW TO USE
----------
1. Create/open your Flutter project.
2. Copy the lib folder from this ZIP into your project.
3. Copy pubspec.yaml dependencies into your own pubspec.yaml, or replace it carefully.
4. Make sure lib/firebase_options.dart exists.
5. Run:
   flutter pub get
6. Run:
   flutter run -d chrome

FIREBASE CONSOLE SETUP
----------------------
1. Firebase Console > Authentication > Sign-in method > Enable Email/Password.
2. Firebase Console > Firestore Database > Create database.
3. Use the rules below while testing.

FIRESTORE RULES
---------------
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      match /savedRecipes/{recipeId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}

MEALDB API
----------
This app uses TheMealDB free API:
https://www.themealdb.com/api/json/v1/1/

No API key setup is needed for the free test endpoint.

CHANGE ENQUIRY EMAIL
--------------------
Open:
lib/screens/enquiry_screen.dart

Change:
static const String enquiryEmail = 'hardikmangs@gmail.com';

to your required email address.
