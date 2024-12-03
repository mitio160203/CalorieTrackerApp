import 'package:calories_app/api/http_service.dart';
import 'package:calories_app/meal.dart';
import 'package:flutter/cupertino.dart';

class DataController {
  static final DataController instance = DataController._internal();

  ValueNotifier<List<Meal>> mealsNotifier = ValueNotifier<List<Meal>>([
    // Meal(title: "title", calories: 6.9, carbs: 5.7, protein: 4.8, fat: 3.7),
    // Meal(title: "title", calories: 6.9, carbs: 5.7, protein: 4.8, fat: 3.7),
    // Meal(title: "title", calories: 6.9, carbs: 5.7, protein: 4.8, fat: 3.7),
  ]);
  ValueNotifier<int> carbsNotifier = ValueNotifier<int>(0);
  ValueNotifier<int> fatNotifier = ValueNotifier<int>(0);
  ValueNotifier<int> proteinNotifier = ValueNotifier<int>(0);
  ValueNotifier<int> consumedCaloriesNotifier = ValueNotifier<int>(0);
  ValueNotifier<int> goalCaloriesNotifier = ValueNotifier<int>(2200);
  ValueNotifier<int> remainingCaloriesNotifier = ValueNotifier<int>(0);

  factory DataController() {
    return instance;
  }

  Future<void> performMealsFetch() async {
    try {
      //handle the response
      List<dynamic> listDynamic =
          await MealHttpService.instance.getAllAsync<List<dynamic>>();

      mealsNotifier.value = listDynamic
          .map((item) => Meal.fromJson(item as Map<String, dynamic>))
          .toList();

      if (mealsNotifier.value.isEmpty) {
        consumedCaloriesNotifier.value = 0;
      } else {
        consumedCaloriesNotifier.value = (mealsNotifier.value
            .map((meal) => meal.calories)
            .toList()
            .reduce((a, b) => a + b)).toInt();
      }

      remainingCaloriesNotifier.value =
          goalCaloriesNotifier.value - consumedCaloriesNotifier.value;

      if (mealsNotifier.value.isEmpty) {
        carbsNotifier.value = 0;
      } else {
        carbsNotifier.value = (mealsNotifier.value
            .map((meal) => meal.carbs)
            .toList()
            .reduce((a, b) => a + b)).toInt();
      }

      if (mealsNotifier.value.isEmpty) {
        proteinNotifier.value = 0;
      } else {
        proteinNotifier.value = (mealsNotifier.value
            .map((meal) => meal.protein)
            .toList()
            .reduce((a, b) => a + b)).toInt();
      }

      if (mealsNotifier.value.isEmpty) {
        fatNotifier.value = 0;
      } else {
        fatNotifier.value = (mealsNotifier.value
            .map((meal) => meal.fat)
            .toList()
            .reduce((a, b) => a + b)).toInt();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Perform Delete Expense
  Future<bool> performDeleteMeal(int id) async {
    bool result;
    try {
      await MealHttpService.instance.deleteAsync(id: id);
      result = true;
    } catch (ex) {
      return false;
    }

    return result;
  }

  DataController._internal();
}
