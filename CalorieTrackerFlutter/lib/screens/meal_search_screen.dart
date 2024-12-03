import 'package:flutter/material.dart';
import '../api/api_service.dart';

class MealSearchScreen extends StatefulWidget {
  final String category;

  const MealSearchScreen({required this.category, Key? key}) : super(key: key);

  @override
  _MealSearchScreenState createState() => _MealSearchScreenState();
}

class _MealSearchScreenState extends State<MealSearchScreen> {
  late Future<List<Map<String, dynamic>>> _mealsFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMeals(); // Initial fetch of meals without any search query
  }

  // Fetch meals from the API based on the search query.
  void _fetchMeals([String query = '']) {
    setState(() {
      // _mealsFuture = ApiService().searchMeals(query); // API call to search meals
    });
  }

  // Add the selected meal to the current category and return to the previous screen.
  void _addMeal(Map<String, dynamic> meal) {
    Navigator.pop(context, meal); // Return the selected meal to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Meals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _fetchMeals(_searchController.text); // Trigger search on button press
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search for meals...',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: _fetchMeals, // Trigger search on Enter
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _mealsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No meals found'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final meal = snapshot.data![index];
                        return ListTile(
                          title: Text(meal['name']),
                          subtitle: Text('${meal['calories']} calories'),
                          onTap: () => _addMeal(meal), // Add meal on tap
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
