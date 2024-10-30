import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const RecipePickerApp());
}

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

class RecipePickerPage extends StatefulWidget {
  const RecipePickerPage({super.key});

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
    'Middle Eastern'
  ];

  final List<String> allDiets = [
    'Vegetarian',
    'No Onion No Garlic (Sattvic)',
    'Non Vegetarian',
    'Eggetarian',
    'Diabetic Friendly',
    'Gluten Free',
    'Vegan'
  ];

  final Map<String, List<String>> courseCuisines = {
    "Side Dish": ["Indian", "North Indian", "South Indian", "East Indian", "West Indian", "Other Regional Indian", "Asian", "Mughlai", "Parsi", "Continental"],
    "Appetizer": ["Indian", "North Indian", "South Indian", "East Indian", "West Indian", "Other Regional Indian", "Asian"],
    "Main Course": ["Indian", "North Indian", "South Indian", "East Indian", "West Indian", "Other Regional Indian", "Asian", "Mughlai", "Parsi"],
    "Lunch": ["Indian", "North Indian", "South Indian", "East Indian", "West Indian", "Other Regional Indian", "Asian", "Mughlai", "Parsi", "Indo Chinese", "Continental", "Middle Eastern"],
    "Dinner": ["Indian", "North Indian", "South Indian", "East Indian", "West Indian", "Other Regional Indian", "Asian", "Mughlai", "Parsi", "Fusion", "Middle Eastern"],
    "Dessert": ["Indian", "North Indian", "South Indian", "East Indian", "West Indian", "Other Regional Indian", "Asian", "Mughlai", "Parsi", "Fusion", "Middle Eastern"],
    "Breakfast": ["Indian", "North Indian", "South Indian", "East Indian", "West Indian", "Other Regional Indian", "Parsi", "Indo Chinese", " Fusion", " Continental"],
    "Snack": ["Indian", "North Indian", "South Indian", "East Indian", "West Indian", "Other Regional Indian", "Asian", "Parsi", "Fusion"],
  };

  final Map<String, Map<String, List<String>>> validDietsForCourseCuisine = {
    'Side Dish': {
      'Indian': ['Vegetarian', 'No Onion No Garlic (Sattvic)', 'Non Vegetarian', 'Eggetarian', 'Diabetic Friendly', 'Vegan'],
      'North Indian': ['Vegetarian', 'No Onion No Garlic (Sattvic)', 'Non Vegetarian', 'Diabetic Friendly'],
      'South Indian': ['Vegetarian', 'No Onion No Garlic (Sattvic)', 'Non Vegetarian', 'Eggetarian', 'Diabetic Friendly', 'Vegan'],
      'East Indian': ['Vegetarian', 'No Onion No Garlic (Sattvic)', 'Non Vegetarian', 'Diabetic Friendly'],
      'West Indian': ['Vegetarian', 'Non Vegetarian', 'Eggetarian', 'Diabetic Friendly'],
      'Other Regional Indian': ['Vegetarian', 'No Onion No Garlic (Sattvic)', 'Non Vegetarian'],
      'Asian': ['Vegetarian', 'Diabetic Friendly'],
      'Mughlai': ['Vegetarian', 'Non Vegetarian'],
      'Parsi': ['Vegetarian'],
      'Continental': ['Vegetarian'],
    },
    'Appetizer': {
      'Indian': ['Vegetarian', 'Non Vegetarian', 'Eggetarian', 'Diabetic Friendly', 'Vegan'],
      'North Indian': ['Vegetarian', 'Non Vegetarian'],
      'South Indian': ['Vegetarian', 'Non Vegetarian', 'Eggetarian'],
      'East Indian': ['Vegetarian'],
      'West Indian': ['Non Vegetarian'],
      'Other Regional Indian': ['Vegetarian'],
      'Asian': ['Non Vegetarian'],
    },
    'Main Course': {
      'Indian': ['Vegetarian','Diabetic Friendly'],
      'North Indian': ['Vegetarian', 'No Onion No Garlic (Sattvic)', 'Non Vegetarian', 'Diabetic Friendly'],
      'South Indian': ['Vegetarian', 'Non Vegetarian', 'Eggetarian', 'Diabetic Friendly'],
      'East Indian': ['Vegetarian', 'No Onion No Garlic (Sattvic)', 'Non Vegetarian', 'Diabetic Friendly'],
      'West Indian': ['Vegetarian', 'Non Vegetarian', 'Diabetic Friendly'],
      'Other Regional Indian': ['Vegetarian', 'Diabetic Friendly'],
      'Asian': ['Vegetarian'],
      'Mughlai': ['Vegetarian', 'Non Vegetarian'],
      'Parsi': ['Vegetarian'],
    },
    'Lunch': {
      'Indian': ['Vegetarian', 'No Onion No Garlic (Sattvic)', 'Non Vegetarian', 'Eggetarian', 'Diabetic Friendly', 'Vegan', 'Gluten Free'],
      'North Indian': ['Vegetarian', 'No Onion No Garlic (Sattvic)', 'Non Vegetarian', 'Eggetarian', 'Diabetic Friendly', 'Vegan', 'Gluten Free'],
      'South Indian': ['Vegetarian', 'No Onion No Garlic (Sattvic)', 'Non Vegetarian', 'Eggetarian', 'Diabetic Friendly', 'Gluten Free'],
      'East Indian': ['Vegetarian', 'Non Vegetarian', 'Eggetarian', 'Gluten Free'],
      'West Indian': ['Vegetarian', 'Non Vegetarian', 'Eggetarian', 'Diabetic Friendly'],
      'Other Regional Indian': ['Vegetarian', 'Eggetarian', 'Diabetic Friendly'],
      'Asian': ['Vegetarian', 'Eggetarian'],
      'Mughlai': ['Vegetarian', 'Non Vegetarian', 'Eggetarian'],
      'Parsi': ['Vegetarian'],
      'Indo Chinese': ['Vegetarian', 'Eggetarian'],
      'Continental': ['Vegetarian'],
      'Middle Eastern': ['Vegetarian', 'Eggetarian'],
    },
    'Dinner': {
      'Indian': ['Vegetarian', 'Non Vegetarian', 'Eggetarian', 'Diabetic Friendly', 'Vegan'],
      'North Indian': ['Vegetarian', 'No Onion No Garlic (Sattvic)', 'Non Vegetarian', 'Eggetarian', 'Diabetic Friendly', 'Vegan'],
      'South Indian': ['Vegetarian', 'Non Vegetarian', 'Eggetarian', 'Diabetic Friendly'],
      'East Indian': ['Vegetarian', 'No Onion No Garlic (Sattvic)', 'Non Vegetarian', 'Eggetarian', 'Diabetic Friendly'],
      'West Indian': ['Vegetarian', 'Non Vegetarian', 'Eggetarian'],
      'Other Regional Indian': ['Vegetarian', 'Non Vegetarian'],
      'Asian': ['Vegetarian', 'Non Vegetarian'],
      'Mughlai': ['Vegetarian', 'Non Vegetarian'],
      'Parsi': ['Vegetarian'],
      'Fusion': ['Eggetarian'],
      'Middle Eastern': ['Vegetarian'],
    },
    'Dessert': {
      'Indian': ['Vegetarian', 'Eggetarian', 'Vegan'],
      'North Indian': ['Vegetarian', 'No Onion No Garlic (Sattvic)', 'Gluten Free'],
      'South Indian': ['Vegetarian', 'Gluten Free'],
      'East Indian': ['Vegetarian'],
      'West Indian': ['Vegetarian', 'Eggetarian'],
      'Other Regional Indian': ['Vegetarian'],
      'Asian': ['Eggetarian'],
      'Mughlai': ['Vegetarian'],
      'Parsi': ['Eggetarian'],
      'Fusion': ['Vegetarian'],
      'Middle Eastern': ['Vegetarian'],
    },
    'Breakfast': {
      'Indian': ['Vegetarian', 'Eggetarian', 'Diabetic Friendly', 'Vegan', 'Gluten Free'],
      'North Indian': ['Vegetarian', 'Eggetarian', 'Diabetic Friendly', 'Vegan', 'Gluten Free'],
      'South Indian': ['Vegetarian', 'Eggetarian', 'Diabetic Friendly', 'Vegan', 'Gluten Free'],
      'East Indian': ['Vegetarian', 'Diabetic Friendly', 'Gluten Free'],
      'West Indian': ['No Onion No Garlic (Sattvic)', 'Diabetic Friendly'],
      'Other Regional Indian': ['Vegetarian'],
      'Parsi': ['Eggetarian'],
      'Indo Chinese': ['Vegetarian'],
      'Fusion': ['Vegetarian', 'Diabetic Friendly'],
      'Continental': ['Non Vegetarian', 'Eggetarian'],
    },
    'Snack': {
      'Indian': ['Vegetarian'],
      'North Indian': ['Vegetarian'],
      'South Indian': ['Vegetarian', 'Eggetarian', 'Diabetic Friendly', 'Gluten Free'],
      'East Indian': ['Vegetarian', 'Diabetic Friendly'],
      'West Indian': ['Vegetarian'],
      'Other Regional Indian': ['Vegetarian'],
      'Asian': ['Eggetarian'],
      'Parsi': ['Vegetarian'],
      'Fusion': ['Vegetarian'],
    },
  };

  String? selectedCourse;
  String? selectedCuisine;
  String? selectedDiet;
  double maxCookingTime = 600;

  List<String> availableCuisines = [];
  List<String> availableDiets = [];

  @override
  void initState() {
    super.initState();
    availableDiets = List.from(allDiets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Picker', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Course:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildDropdownButton(courses, selectedCourse, 'Choose Course', (newValue) {
                setState(() {
                  selectedCourse = newValue;
                  selectedCuisine = null;
                  selectedDiet = null;
                  availableCuisines = courseCuisines[selectedCourse] ?? [];
                  availableDiets = List.from(allDiets);
                });
              }),
              const SizedBox(height: 16),
              const Text('Select Cuisine:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildDropdownButton(availableCuisines, selectedCuisine, 'Choose Cuisine', (newValue) {
                setState(() {
                  selectedCuisine = newValue;
                  if (selectedCourse != null && newValue != null) {
                    availableDiets = validDietsForCourseCuisine[selectedCourse]?[newValue] ?? [];
                  } else {
                    availableDiets = List.from(allDiets);
                  }
                  selectedDiet = null;
                });
              }),
              const SizedBox(height: 16),
              const Text('Select Diet:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildDropdownButton(availableDiets, selectedDiet, 'Choose Diet', (newValue) {
                setState(() {
                  selectedDiet = newValue;
                });
              }),
              const SizedBox(height: 32),
              const Text('Select Maximum Cooking Time (minutes):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Slider(
                value: maxCookingTime,
                min: 10,
                max: 600,
                divisions: 118,
                label: maxCookingTime.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    maxCookingTime = value;
                  });
                },
              ),
              const SizedBox(height: 32),
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
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Find Recipes',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black, // Set text color to black
                    ),
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
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
        underline: const SizedBox(),
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

  const RecipeResultsPage({super.key,
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
          cookingTime >= 10 && cookingTime <= widget.maxCookingTime; // Cooking time condition
    }).toList();

    setState(() {
      _recipes = filteredRecipes;
    });
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
              name: recipe[0].toString(), // NAME column
              imageUrl: recipe[1].toString(), // IMAGE_URL column
              description: recipe[2].toString(), // DESCRIPTION column
              ingredients: recipe[8].toString(), // INGREDIENTS column
              instructions: recipe[7].toString(), // INSTRUCTIONS column
              time: recipe[6]+10, // TIME column
              origin: recipe[9].toString(), // ORIGIN column
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
                recipe[1].toString(), // IMAGE_URL column
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Instead of showing an error icon or warning, return a Wi-Fi off icon
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
                      recipe[0].toString(), // NAME column
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Cooking Time: ', //TIME column
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '${recipe[6]+10} (minutes)',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
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
  final String origin;
  final int time;

  RecipeDetailPage({super.key,
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
                  // Instead of showing an error icon or warning, return a Wi-Fi off icon
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