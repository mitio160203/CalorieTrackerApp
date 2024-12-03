import 'package:calories_app/api/http_service.dart';
import 'package:calories_app/data_controller.dart';
import 'package:flutter/material.dart';
import '../api/api_service.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  //final _apiService = ApiService();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbController = TextEditingController();
  final _fatController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _saveMeal() async {
    final name = _nameController.text.trim();
    final calories = double.tryParse(_caloriesController.text) ?? 0;
    final protein = double.tryParse(_proteinController.text) ?? 0;
    final carbs = double.tryParse(_carbController.text) ?? 0;
    final fat = double.tryParse(_fatController.text) ?? 0;

    if (name.isEmpty || calories <= 0 || protein <= 0) {
      _showError("All fields are required and must have valid values.");
      return;
    }

    await MealHttpService.instance.postAsync(
        requestBody: PostMealRequestBody(
            title: name,
            calories: calories,
            carbs: carbs,
            protein: protein,
            fat: fat));

    if (context.mounted) {
      Navigator.pop(context, true);
    }

    DataController.instance.performMealsFetch();
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Meal"), backgroundColor: Colors.white,),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Meal Name"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Calories"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _proteinController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Protein (g)"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _carbController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Carb (g)"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _fatController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Fat (g)"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveMeal,
                child: const Text("Save Meal"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
