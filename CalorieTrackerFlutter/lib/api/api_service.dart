import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://localhost:5000"; // Вашият базов URL

  Future<List<Map<String, dynamic>>> fetchMeals(String searchQuery) async {
    final response = await http.get(
      Uri.parse('$baseUrl/meals?search=$searchQuery'),
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMealsByCategory(String category) async {
    final String url = "$baseUrl/meals/$category"; // Ensure the URL matches your Flask endpoint
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load meals by category: ${response.body}');
      }
    } catch (error) {
      print('Error in fetchMealsByCategory: $error'); // Log the error
      throw Exception('Failed to load meals by category.');
    }
  }

  // Функция за добавяне на ново ястие
  Future<void> addMeal(Map<String, dynamic> meal) async {
    final response = await http.post(
      Uri.parse('$baseUrl/meals'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(meal),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to add meal");
    }
  }

  // Функция за актуализиране на ястие по ID
  Future<void> updateMeal(int id, Map<String, dynamic> meal) async {
    final response = await http.put(
      Uri.parse('$baseUrl/meals/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(meal),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update meal");
    }
  }

  // Функция за изтриване на ястие по ID
  Future<void> deleteMeal(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/meals/$id'));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete meal");
    }
  }

  Future<List<Map<String, dynamic>>> searchMeals(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/meals?search=$query'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to search meals");
    }
  }

  Future<void> addMealToCategory(Map<String, dynamic> meal, String category) async {
    final updatedMeal = {...meal, 'category': category};
    await addMeal(updatedMeal); // Reuse the existing addMeal function
  }
}
