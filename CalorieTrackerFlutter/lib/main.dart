import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_meal_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/addMeal': (context) => const AddMealScreen(),
      },
    );
  }
}
