import 'dart:convert'; // For encoding and decoding JSON
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RecipeResultsPage extends StatefulWidget {
  final String selectedCourse;
  final String selectedCuisine;
  final String selectedDiet;
  final int maxCookingTime;

  const RecipeResultsPage({
    super.key,
    required this.selectedCourse,
    required this.selectedCuisine,
    required this.selectedDiet,
    required this.maxCookingTime,
  });

  @override
  _RecipeResultsPageState createState() => _RecipeResultsPageState();
}

class _RecipeResultsPageState extends State<RecipeResultsPage> {
  List<dynamic> _recipes = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _fetchRecipes() async {
    final url = 'https://recipe.shubhodip.in/filter.php'; // API endpoint
    final Map<String, String> body = {
      'course': widget.selectedCourse,
      'cuisine': widget.selectedCuisine,
      'diet': widget.selectedDiet,
      'prep_time': widget.maxCookingTime.toString(),
    };

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.post(Uri.parse(url), body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          if (data is List) {
            _recipes = data;
          } else {
            _errorMessage = data['message'] ?? 'No recipes found.';
            _recipes = [];
          }
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch recipes. Status code: ${response.statusCode}';
          _recipes = [];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _recipes = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Results', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _recipes.isNotEmpty
                ? ListView.builder(
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) {
                      return _buildRecipeCard(_recipes[index]);
                    },
                  )
                : Center(
                    child: Text(
                      _errorMessage.isEmpty ? 'No recipes found for your selection.' : _errorMessage,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
      ),
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailPage(
              name: recipe['name'] ?? 'Unknown Recipe',
              imageUrl: recipe['image_url'] ?? '',
              description: recipe['description'] ?? '',
              ingredients: recipe['final_ingredients'] ?? '',
              instructions: recipe['instruction'] ?? '',
              time: recipe['prep_time'] ?? '',
              origin: recipe['cuisine'] ?? '',
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.network(
                recipe['image_url'] ?? '',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    size: 100,
                    color: Colors.grey,
                  );
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe['name'] ?? 'Unknown Recipe',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Cooking Time: ',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '${recipe['prep_time']} minutes',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      recipe['description'] ?? '',
                      style: TextStyle(color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecipeDetailPage extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String description;
  final String ingredients;
  final String instructions;
  final String origin;
  final String time;

  const RecipeDetailPage({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.time,
    required this.origin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    size: 100,
                    color: Colors.grey,
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Cooking Time: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '$time minutes',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Origin: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: origin,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Description:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(description, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              const Text(
                'Ingredients:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(ingredients, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              const Text(
                'Instructions:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(instructions, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
