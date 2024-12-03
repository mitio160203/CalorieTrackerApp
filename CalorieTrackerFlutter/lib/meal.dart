class Meal {
  final int id;
  final String title;
  final double calories;
  final double carbs;
  final double protein;
  final double fat;

  Meal({required this.id, required this.title, required this.calories, required this.carbs, required this.protein, required this.fat});

  Meal.fromJson( Map<String, dynamic> json)
      : title = json['title'].toString(),
        calories = double.parse(json['calories'].toString()),
        carbs = double.parse(json['carbs'].toString()),
        protein = double.parse(json['protein'].toString()),
        fat = double.parse(json['fat'].toString()),
        id = int.parse(json['id'].toString());
}