import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
//import 'recipe_detail_page.dart';

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
  List<List<dynamic>> _recipes = [];

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  Future<void> _loadCSV() async {
    try {
      print('Attempting to load CSV file...');
      final rawData = await rootBundle.loadString('assets/modified_file.csv');
      print('CSV file loaded successfully.');
      
      List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
      print('CSV data converted successfully.');

      // Filter recipes based on user selection and cooking time
      List<List<dynamic>> filteredRecipes = listData.where((recipe) {
        int cookingTime = int.tryParse(recipe[6].toString()) ?? 0; // Cooking time in 6th column
        return recipe[4] == widget.selectedCourse &&
            recipe[3] == widget.selectedCuisine &&
            recipe[5] == widget.selectedDiet &&
            cookingTime <= widget.maxCookingTime;
      }).toList();

      print('Filtered recipes: ${filteredRecipes.length} found.');

      setState(() {
        _recipes = filteredRecipes;
      });
    } catch (e) {
      print('Error loading CSV: $e');
    }
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
        child: _recipes.isNotEmpty
            ? ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  return _buildRecipeCard(_recipes[index]);
                },
              )
            : const Center(
                child: Text(
                  'No recipes found for your selection.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }

  Widget _buildRecipeCard(List<dynamic> recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailPage(
              name: recipe[0].toString(),
              imageUrl: recipe[1].toString(),
              description: recipe[2].toString(),
              ingredients: recipe[8].toString(),
              instructions: recipe[7].toString(),
              time: recipe[6],
              origin: recipe[9].toString(),
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
                recipe[1].toString(),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.wifi_off,
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
                      recipe[0].toString(),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Cooking Time: ',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '${recipe[6]} minutes',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      recipe[2].toString(),
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
  final int time;

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
                    Icons.wifi_off,
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
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '$time minutes',
                      style: const TextStyle(fontSize: 20),
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
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: origin,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Description:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ingredients:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                ingredients,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              const Text(
                'Instructions:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                instructions,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}