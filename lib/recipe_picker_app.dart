import 'package:flutter/material.dart';
import 'recipe_picker_page.dart';

class RecipePickerApp extends StatelessWidget {
  const RecipePickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Picker',
      theme: ThemeData(
        primaryColor: Colors.green,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.orangeAccent,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      home: const RecipePickerPage(),
    );
  }
}