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
    }

    if (result % 1 == 0)
      n1 = result.toStringAsFixed(0);
    else {
      n1 = result.toStringAsPrecision(16);
      int end = n1.length-1;
      while (true) {
        if (n1[end] == "0")
          end--;
        else
          break;
      }
      n1 = n1.substring(0, end+1);
    }

    operand = "";
    n2 = "";

    notifyListeners();
  }

  void unaryOperators(String value) {
    if (n1.isNotEmpty && operand.isNotEmpty && n2.isNotEmpty)
      calculate();

    if (operand.isNotEmpty)
      return;

    if (n1.isEmpty)
      return;

    var result = double.parse(n1);
    if (value == Buttons.per)
      result /= 100;
    else
      result = sqrt(result);
    if (result % 1 == 0)
      n1 = result.toStringAsFixed(0);
    else
      n1 = result.toStringAsPrecision(16);
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
      if (operand.isNotEmpty && n2.isNotEmpty)
        calculate();
      operand = value;
    }
    // assign value to number1 variable
    else if (n1.isEmpty || operand.isEmpty) {
      // check if value is "." | ex: number1 = "1.2"
      if (value == Buttons.dot && n1.contains(Buttons.dot))
        return;
      n1 += value;
    }
    // assign value to number2 variable
    else if (n2.isEmpty || operand.isNotEmpty) {
      // check if value is "." | ex: number1 = "1.2"
      if (value == Buttons.dot && n2.contains(Buttons.dot))
        return;
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
