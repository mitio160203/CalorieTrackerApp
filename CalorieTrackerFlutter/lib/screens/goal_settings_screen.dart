import 'package:flutter/material.dart';

class GoalSettingsScreen extends StatefulWidget {
  const GoalSettingsScreen({super.key});

  @override
  _GoalSettingsScreenState createState() => _GoalSettingsScreenState();
}

class _GoalSettingsScreenState extends State<GoalSettingsScreen> {
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Set Your Goals",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter Your Daily Goals",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),

              // Calories Input
              _buildInputField(
                controller: _caloriesController,
                label: 'Calories',
                hintText: 'Enter your daily calorie goal',
              ),

              // Protein Input
              _buildInputField(
                controller: _proteinController,
                label: 'Protein (g)',
                hintText: 'Enter your daily protein goal',
              ),

              // Carbs Input
              _buildInputField(
                controller: _carbsController,
                label: 'Carbs (g)',
                hintText: 'Enter your daily carbs goal',
              ),

              // Fat Input
              _buildInputField(
                controller: _fatController,
                label: 'Fat (g)',
                hintText: 'Enter your daily fat goal',
              ),

              const SizedBox(height: 24),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveGoals,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    backgroundColor: Colors.blue, // Updated from 'primary' to 'backgroundColor'
                  ),
                  child: const Text(
                    "Save Goals",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Input field builder for reusable code
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  // Handle saving the goals and passing data back
  void _saveGoals() {
    if (_caloriesController.text.isEmpty ||
        _proteinController.text.isEmpty ||
        _carbsController.text.isEmpty ||
        _fatController.text.isEmpty) {
      _showErrorDialog("Please fill in all the fields.");
      return;
    }

    // Collect goals into a map to return
    final goals = {
      'calories': _caloriesController.text,
      'protein': _proteinController.text,
      'carbs': _carbsController.text,
      'fat': _fatController.text,
    };

    // Pass data back to HomeScreen
    Navigator.pop(context, goals);
  }

  // Show error dialog if fields are empty
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}