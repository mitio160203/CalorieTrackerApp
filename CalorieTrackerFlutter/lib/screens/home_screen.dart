import 'package:calories_app/data_controller.dart';
import 'package:calories_app/meal.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'goal_settings_screen.dart';
import '../api/api_service.dart';
import 'meal_search_screen.dart'; // Import the meal search screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _proteinGoal = '103';
  String _carbsGoal = '258';
  String _fatGoal = '68';

  // late Future<List<Map<String, dynamic>>> _breakfastMeals;
  // late Future<List<Map<String, dynamic>>> _lunchMeals;
  // late Future<List<Map<String, dynamic>>> _dinnerMeals;
  // late Future<List<Map<String, dynamic>>> _snacksMeals;

  @override
  void initState() {
    super.initState();
    DataController.instance.performMealsFetch();
  }

  void _fetchMeals() {}

  // void _addMealToCategory(String category, Map<String, dynamic> meal) {
  //   ApiService().addMealToCategory(meal, category).then((_) {
  //     setState(() {
  //       _fetchMeals(); // Refresh meals after adding
  //     });
  //   }).catchError((error) {
  //     // Handle error
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error adding meal: $error")),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Today",
          style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final goals = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GoalSettingsScreen()),
              );

              if (goals != null) {
                setState(() {
                  DataController.instance.goalCaloriesNotifier.value =
                      int.parse(goals['calories'].toString());
                  DataController.instance.remainingCaloriesNotifier.value =
                      DataController.instance.goalCaloriesNotifier.value -
                          DataController
                              .instance.consumedCaloriesNotifier.value;
                  _proteinGoal = goals['protein'];
                  _carbsGoal = goals['carbs'];
                  _fatGoal = goals['fat'];
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListenableBuilder(
              listenable: DataController.instance.remainingCaloriesNotifier,
              builder: (context, child) {
                return _CalorieSummary(
                  caloriesGoal: DataController
                      .instance.goalCaloriesNotifier.value
                      .toString(),
                  proteinGoal: _proteinGoal,
                  carbsGoal: _carbsGoal,
                  fatGoal: _fatGoal,
                  eatenCalories: DataController
                      .instance.consumedCaloriesNotifier.value
                      .toDouble(),
                  dailyGoal: DataController.instance.goalCaloriesNotifier.value
                      .toDouble(),
                  remainingCalories: DataController
                      .instance.remainingCaloriesNotifier.value
                      .toDouble(),
                );
              },
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(width: 0.1, color: Colors.black),
              ),

              //title
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.fastfood_outlined,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Title",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Calories",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Carbs",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Protein",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Fat",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: Text(
                                "Actions",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: DataController.instance.mealsNotifier,
                builder: (context, value, child) {
                  return ListView(
                    children: List.generate(value.length, (index) {
                      return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ExpenseTableItem(model: value[index]));
                    }),
                  );
                },
                //mealsNotifier
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addMeal');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CalorieSummary extends StatelessWidget {
  final String caloriesGoal;
  final String proteinGoal;
  final String carbsGoal;
  final String fatGoal;
  final double eatenCalories;
  final double dailyGoal;
  final double remainingCalories;

  const _CalorieSummary({
    required this.caloriesGoal,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatGoal,
    required this.eatenCalories,
    required this.dailyGoal,
    required this.remainingCalories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CalorieItem(
                  label: "Eaten", value: eatenCalories.toStringAsFixed(0)),
              Column(
                children: [
                  CircularPercentIndicator(
                    radius: 80.0,
                    lineWidth: 10.0,
                    percent: eatenCalories / dailyGoal,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          remainingCalories.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Remaining",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    progressColor: Colors.green,
                    backgroundColor: Colors.grey[200]!,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ],
              ),
              const _CalorieItem(label: "", value: ""),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListenableBuilder(
                  listenable: DataController.instance.carbsNotifier,
                  builder: (context, child) {
                    return _NutrientBar(
                        label: "Carbs",
                        value: DataController.instance.carbsNotifier.value,
                        goal: int.tryParse(carbsGoal) ?? 258,
                        color: Colors.blue);
                  },
                ),
              ),
              Expanded(
                child: ListenableBuilder(
                  listenable: DataController.instance.proteinNotifier,
                  builder: (context, child) {
                    return _NutrientBar(
                        label: "Protein",
                        value: DataController.instance.proteinNotifier.value,
                        goal: int.tryParse(carbsGoal) ?? 258,
                        color: Colors.green);
                  },
                ),
              ),
              Expanded(
                child: ListenableBuilder(
                  listenable: DataController.instance.fatNotifier,
                  builder: (context, child) {
                    return _NutrientBar(
                        label: "Fat",
                        value: DataController.instance.fatNotifier.value,
                        goal: int.tryParse(carbsGoal) ?? 258,
                        color: Colors.red);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalorieItem extends StatelessWidget {
  final String label;
  final String value;

  const _CalorieItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}

class _NutrientBar extends StatelessWidget {
  final String label;
  final int value;
  final int goal;
  final Color color;

  const _NutrientBar(
      {required this.label,
      required this.value,
      required this.goal,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final percentage = value / goal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            Container(
              width: 80,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              width: 80 * percentage,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "$value / $goal g",
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class MealCategory extends StatelessWidget {
  final String category;
  final Future<List<Map<String, dynamic>>> mealsFuture;
  final IconData icon;
  final Function(String category, Map<String, dynamic> meal) onAddMeal;

  const MealCategory({
    required this.category,
    required this.mealsFuture,
    required this.icon,
    required this.onAddMeal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: Colors.blue),
            title: Text(category,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: const Icon(Icons.add, color: Colors.blue),
              onPressed: () async {
                final selectedMeal = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MealSearchScreen(category: category),
                  ),
                );

                if (selectedMeal != null) {
                  onAddMeal(category, selectedMeal);
                }
              },
            ),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: mealsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No meals found'));
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final meal = snapshot.data![index];
                    return ListTile(
                      title: Text(meal['name']),
                      subtitle: Text('${meal['calories']} calories'),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class ExpenseTableItem extends StatelessWidget {
  final double height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Meal model;

  const ExpenseTableItem({
    super.key,
    this.height = 50,
    this.margin,
    this.padding,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Row(
        children: [
          // Icon
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.fastfood_outlined,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "${model.title}",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "${model.calories}",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "${model.carbs}",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "${model.protein}",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "${model.fat}",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await DataController.instance.performDeleteMeal(model.id);
              DataController.instance.performMealsFetch();
            },
            style: TextButton.styleFrom(
                backgroundColor: const Color(0xfff14646),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
