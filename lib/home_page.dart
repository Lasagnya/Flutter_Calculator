import 'package:calculator/main.dart';
import 'package:calculator/numpad.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String test = "";

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<CalculatorState>();
    String n1 = appState.n1;
    String operand = appState.operand;
    String n2 = appState.n2;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Card(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.8),
              elevation: 0.0,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    "$n1$operand$n2".isNotEmpty ? "$n1$operand$n2" : "0",
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ),
          ),

          Numpad(),
        ],
      ),
    );
  }
}