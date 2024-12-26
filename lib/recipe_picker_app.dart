import 'package:flutter/material.dart';
import 'recipe_picker_page.dart';

class RecipePickerApp extends StatelessWidget {
  const RecipePickerApp({super.key});

  Future<void> _loadData() async {
    // Simulate a delay for loading data
    await Future.delayed(const Duration(seconds: 2));
  }

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
      home: FutureBuilder<void>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Image.asset('assets/loading.gif'), // Add your loading GIF here
              ),
            );
          } else {
            return const RecipePickerPage();
          }
        },
      ),
    );
  }
}