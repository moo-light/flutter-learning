// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:bmi_calculator/dtos/person.dart';
import 'package:flutter/material.dart';

class CalculatedPage extends StatelessWidget {
  Person person;

  CalculatedPage({required this.person, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Text("BMI Calculator"),
        ),
        centerTitle: true,
        
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              person.calculateBMI().toStringAsFixed(1),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary, fontSize: 30),
            ),
          ),
          Text(
            interpretBMI(
              person.calculateBMI(),
            ),
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary, fontSize: 25),
          )
        ],
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  String interpretBMI(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal weight';
    } else if (bmi >= 25 && bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }
}
