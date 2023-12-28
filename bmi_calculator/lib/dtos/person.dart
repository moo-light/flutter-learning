// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:math';

class Person {
  String gender;
  int age;
  double height; // in centimeters
  int weight; // in kilograms

  Person({
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
  });

  double calculateBMI() {
    double heightInMeters = height / 100.0;
    return weight / pow(heightInMeters, 2);
  }
}
