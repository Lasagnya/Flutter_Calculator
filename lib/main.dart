import 'dart:math';

import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CalculatorState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          useMaterial3: true,
        ),
        home: const CalculatorScreen(),
      ),
    );
  }
}

class CalculatorState extends ChangeNotifier {
  String n1 = "";
  String operand = "";
  String n2 = "";
  // String result = "";

  void calculate() {
    if (n1.isEmpty) return;
    if (operand.isEmpty) return;
    if (n2.isEmpty) return;

    final double num1 = double.parse(n1);
    final double num2 = double.parse(n2);

    var result = 0.0;
    switch (operand) {
      case Buttons.add:
        result = num1 + num2;
        break;
      case Buttons.subtract:
        result = num1 - num2;
        break;
      case Buttons.multiply:
        result = num1 * num2;
        break;
      case Buttons.divide:
        result = num1 / num2;
        break;
      default:
    }

    n1 = result.toStringAsPrecision(3);

    if (n1.endsWith(".0")) {
      n1 = n1.substring(0, n1.length - 2);
    }

    operand = "";
    n2 = "";

    notifyListeners();
  }

  void unaryOperators(String value) {
    // ex: 434+324
    if (n1.isNotEmpty && operand.isNotEmpty && n2.isNotEmpty) {
      // calculate before conversion
      calculate();
    }

    if (operand.isNotEmpty) {
      // cannot be converted
      return;
    }

    final number = double.parse(n1);
    if (value == Buttons.per)
      n1 = "${(number / 100)}";
    else
      n1 = "${sqrt(number)}";
    operand = "";
    n2 = "";
    notifyListeners();
  }

  void erase() {
    if (n2.isNotEmpty) {
      n2 = n2.substring(0, n2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (n1.isNotEmpty) {
      n1 = n1.substring(0, n1.length - 1);
    }
    notifyListeners();
  }

  void clearAll() {
    n1 = "";
    n2 = "";
    operand = "";
    notifyListeners();
  }

  void appendValue(String value) {
    if (value != Buttons.dot && int.tryParse(value) == null) {
      // operand pressed
      if (operand.isNotEmpty && n2.isNotEmpty) {
        // TODO calculate the equation before assigning new operand
        calculate();
      }
      operand = value;
    }
    // assign value to number1 variable
    else if (n1.isEmpty || operand.isEmpty) {
      // check if value is "." | ex: number1 = "1.2"
      if (value == Buttons.dot && n1.contains(Buttons.dot)) return;
      if (value == Buttons.dot && (n1.isEmpty || n1 == Buttons.n0)) {
        // ex: number1 = "" | "0"
        value = "0.";
      }
      n1 += value;
    }
    // assign value to number2 variable
    else if (n2.isEmpty || operand.isNotEmpty) {
      // check if value is "." | ex: number1 = "1.2"
      if (value == Buttons.dot && n2.contains(Buttons.dot)) return;
      if (value == Buttons.dot && (n2.isEmpty || n2 == Buttons.n0)) {
        // number1 = "" | "0"
        value = "0.";
      }
      n2 += value;
    }

    notifyListeners();
  }

  void buttonPressed(String value) {
    if (value == Buttons.del) {
      erase();
      return;
    }

    if (value == Buttons.clr) {
      clearAll();
      return;
    }

    if (value == Buttons.per || value == Buttons.sqrt) {
      unaryOperators(value);
      return;
    }

    if (value == Buttons.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }
}
