import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(RecipePickerApp());
}

class RecipePickerApp extends StatelessWidget {
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
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      home: RecipePickerPage(),
    );
  }
}

class RecipePickerPage extends StatefulWidget {
  @override
  _RecipePickerPageState createState() => _RecipePickerPageState();
}

class _RecipePickerPageState extends State<RecipePickerPage> {
  final List<String> courses = [
    'Side Dish',
    'Appetizer',
    'Main Course',
    'Lunch',
    'Dinner',
    'Dessert',
    'Breakfast',
    'Snack'
  ];

  final List<String> cuisines = [
    'Indian',
    'North Indian',
    'South Indian',
    'East Indian',
    'West Indian',
    'Other Regional Indian',
    'Asian',
    'Mughlai',
    'Parsi',
    'Indo Chinese',
    'Fusion',
    'Continental',
    'Middle Eastern'];

  final List<String> diets = [
    'Vegetarian',
    'No Onion No Garlic (Sattvic)',
    'Non Vegeterian',
    'Eggetarian',
    'Diabetic Friendly',
    'Gluten Free',
    'Vegan'
  ];

  String? selectedCourse;
  String? selectedCuisine;
  String? selectedDiet;
  double maxCookingTime = 600;  // Default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Picker', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[100]!, Colors.green[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Course:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildDropdownButton(courses, selectedCourse, 'Choose Course', (newValue) {
                setState(() {
                  selectedCourse = newValue;
                });
              }),
              SizedBox(height: 16),

              Text('Select Cuisine:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildDropdownButton(cuisines, selectedCuisine, 'Choose Cuisine', (newValue) {
                setState(() {
                  selectedCuisine = newValue;
                });
              }),
              SizedBox(height: 16),

              Text('Select Diet:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildDropdownButton(diets, selectedDiet, 'Choose Diet', (newValue) {
                setState(() {
                  selectedDiet = newValue;
                });
              }),
              SizedBox(height: 32),

              Text('Select Maximum Cooking Time (minutes):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Slider(
                value: maxCookingTime,
                min: 1,
                max: 600,
                divisions: 300,
                label: maxCookingTime.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    maxCookingTime = value;
                  });
                },
              ),
              SizedBox(height: 32),

              Center(
                child: ElevatedButton(
                  onPressed: selectedCourse != null && selectedCuisine != null && selectedDiet != null
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeResultsPage(
                          selectedCourse: selectedCourse!,
                          selectedCuisine: selectedCuisine!,
                          selectedDiet: selectedDiet!,
                          maxCookingTime: maxCookingTime.round(),
                        ),
                      ),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text('Find Recipes', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownButton(List<String> items, String? selectedItem, String hint, ValueChanged<String?> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: selectedItem,
        hint: Text(hint),
        isExpanded: true,
        underline: SizedBox(),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class RecipeResultsPage extends StatefulWidget {
  final String selectedCourse;
  final String selectedCuisine;
  final String selectedDiet;
  final int maxCookingTime;

  RecipeResultsPage({
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
    final rawData = await rootBundle.loadString('assets/modified_file.csv');
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);

    // Filter the recipes based on user selection and cooking time
    List<List<dynamic>> filteredRecipes = listData.where((recipe) {
      int cookingTime = int.tryParse(recipe[6].toString()) ?? 0; // Assuming cooking time is in the 6th column
      return recipe[4] == widget.selectedCourse && // COURSE column
          recipe[3] == widget.selectedCuisine && // CUISINE column
          recipe[5] == widget.selectedDiet && // DIET column
          cookingTime >= 1 && cookingTime <= widget.maxCookingTime; // Cooking time condition
    }).toList();

    setState(() {
      _recipes = filteredRecipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Results', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
            : Center(
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
              name: recipe[0].toString(), // NAME column
              imageUrl: recipe[1].toString(), // IMAGE_URL column
              description: recipe[2].toString(), // DESCRIPTION column
              ingredients: recipe[8].toString(), // INGREDIENTS column
              instructions: recipe[7].toString(), // INSTRUCTIONS column
              time: recipe[6].toString(),
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.network(
                recipe[1].toString(), // IMAGE_URL column
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Instead of showing an error icon or warning, return a Wi-Fi off icon
                  return Icon(
                    Icons.wifi_off,
                    size: 100,
                    color: Colors.grey,
                  );
                },
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe[0].toString(), // NAME column
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      recipe[2].toString(), // DESCRIPTION column
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
  var time;

  RecipeDetailPage({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                  // Instead of showing an error icon or warning, return a Wi-Fi off icon
                  return Icon(
                    Icons.wifi_off,
                    size: 100,
                    color: Colors.grey,
                  );
                },
              ),
              SizedBox(height: 16),
              Text(
                description,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                'Ingredients:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                ingredients,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Instructions:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                instructions,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}