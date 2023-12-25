// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String output = "";
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 12.0,
              ),
              child: Text(output,
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 12.0,
              ),
              child: Text(result,
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            // Button
            const Expanded(child: Divider()),
            Column(
              children: [
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('/'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('*'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('-'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('0'),
                    _buildButton('00'),
                    _buildButton('.'),
                    _buildButton('+'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('<=', _backSlash),
                    _buildButton('Clear', _clearText),
                    _buildButton('=', _calculate),
                  ],
                )
              ],
            )
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Expanded _buildButton(String buttonText, [VoidCallback? ff]) {
    void _addText() {
      RegExp operator = RegExp(r'[+\-*/]$');

      if (operator.hasMatch(output) && operator.hasMatch(buttonText)) {
        _backSlash();
      }
      output += buttonText;
      setState(() {});
    }

    return Expanded(
      child: OutlinedButton(
        onPressed: ff ?? _addText,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: Text(
            buttonText,
            softWrap: false,
            style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.visible),
          ),
        ),
      ),
    );
  }

  void _calculate() {
    List<double> _getNumbers(String output) {
      List<String> result = output.split(RegExp("\\+|\\-|\\*|\\/"));
      return result.map((e) => double.parse(e)).toList();
    }

    List<String> _getOperators(String output) {
      return output.replaceAll(RegExp(r'\d'), '').split('');
    }

    List<double> numbers;
    List<String> operators;
    try {
      numbers = _getNumbers(output);
      operators = _getOperators(output);
    } catch (e) {
      result = "Invalid";
      return;
    }
    if (kDebugMode) {
      print(numbers);
      print(operators);
    }
    void _doMath(List<double> numbers, List<String> operators) {
      int i = 0;
      while (operators.contains('*') || operators.contains('/')) {
        if (operators[i] == '*' || operators[i] == '/') {
          if (kDebugMode) {
            print(i);
          }
          var num1 = numbers[i];
          var num2 = numbers[i + 1];
          numbers.removeAt(i);

          numbers[i] = calculate(operators.removeAt(i), num1, num2);
          if (kDebugMode) {
            print(numbers);
            print(operators);
          }
          i--;
        }
        ++i;
      }
      i = 0;
      while (operators.isNotEmpty) {
        if (operators[i] == '-' || operators[i] == '+') {
          if (kDebugMode) {
            print(i);
          }
          var num1 = numbers[i];
          var num2 = numbers[i + 1];
          numbers.removeAt(i);
          numbers[i] = calculate(operators.removeAt(i), num1, num2);
          if (kDebugMode) {
            print(numbers);
            print(operators);
          }
          i--;
        }
        ++i;
      }
    }

    _doMath(numbers, operators);
    result = numbers.last.toString();
    setState(() {

    });
  }

  double calculate(String operator, double num1, double num2) {
    double result = 0;
    switch (operator) {
      case "*":
        result = num1 * num2;
        break;
      case "/":
        result = num1 / num2;
        break;
      case "+":
        result = num1 + num2;
        break;
      case "-":
        result = num1 - num2;
        break;
    }
    return result;
  }

  void _clearText() {
    output = "";
    result = "";
    setState(() {});
  }

  void _backSlash() {
    if (output.isEmpty) return;
    output = output.substring(0, output.length - 1);
    setState(() {});
  }
}
