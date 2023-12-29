import 'package:flutter/material.dart';
import 'package:tic_tac_toe/src/main_page/tic_tac_toe.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    DateTime currentTime = DateTime.now();
    bool isDarkMode = isNightTime(currentTime);
    return MaterialApp(
      title: "Tic Tac Toe Game",
      home: TicTacToe(),
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      darkTheme: ThemeData(
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
    );
  }

  bool isNightTime(DateTime time) {
    // Check if the time is between 6:00 PM and 6:00 AM
    int hour = time.hour;
    return hour >= 18 || hour < 6;
  }
}
