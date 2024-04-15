import 'package:flutter/material.dart';
import 'package:calculator/button_values.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import 'main.dart';


class Numpad extends StatelessWidget {
  const Numpad({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CalcButton(
                buttonText: Buttons.buttonValues[0],
                filledButtonStyle: FilledButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.pinkAccent.shade100.withOpacity(0.5),
                ),
              ),
              CalcButton(
                buttonText: Buttons.buttonValues[1],
                fontSize: 40.0,
                fontWeight: FontWeight.w300,
                filledButtonStyle: FilledButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
              CalcButton(
                buttonText: Buttons.buttonValues[2],
                fontSize: 40.0,
                fontWeight: FontWeight.w400,
                filledButtonStyle: FilledButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
              CalcButton(
                buttonText: Buttons.buttonValues[3],
                fontSize: 48.0,
                fontWeight: FontWeight.w300,
                filledButtonStyle: FilledButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
          ]
        ),

        for (int i = 1; i <= 4; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            for (int j = i * 4; j < i * 4 + 3; j++)
              CalcButton(
                buttonText: Buttons.buttonValues[j],
                filledButtonStyle: FilledButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                ),
              ),

              CalcButton(
                buttonText: Buttons.buttonValues[i * 4 + 3],
                fontSize: 48.0,
                fontWeight: FontWeight.w300,
                filledButtonStyle: FilledButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
            ],
          )
      ],
    );
  }
}

class CalcButton extends StatefulWidget {
  final String buttonText;
  final double fontSize;
  final FontWeight fontWeight;
  final ButtonStyle filledButtonStyle;

  const CalcButton({super.key, required this.buttonText, this.filledButtonStyle = const ButtonStyle(), this.fontSize = 30.0, this.fontWeight = FontWeight.normal});

  @override
  State<StatefulWidget> createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton> {
  late Size screenSize;
  late double buttonHeight;
  late double buttonWidth;
  late BorderRadius inactiveBorderRadius;
  late BorderRadius activeBorderRadius;
  late BorderRadius buttonBorder;
  late ButtonStyle buttonStyle;

  @override
  void didChangeDependencies() {
    screenSize = MediaQuery.of(context).size;
    buttonHeight = screenSize.height / 1.85 / 5;
    buttonWidth = (screenSize.width*0.95 - 3*8) / 4;
    inactiveBorderRadius = BorderRadius.circular(buttonWidth > buttonHeight ? buttonHeight/2 : buttonWidth/2);
    activeBorderRadius = inactiveBorderRadius*1 / 2;
    buttonBorder = inactiveBorderRadius;
    buttonStyle = widget.filledButtonStyle.copyWith(shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: inactiveBorderRadius)));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: Colors.black,
      fontSize: widget.fontSize,
      fontWeight: widget.fontWeight,
    );
    final appState = context.watch<CalculatorState>();

    return GestureDetector(
      onTapDown: (tapDownDetails) {
        setState(() {
          buttonBorder = activeBorderRadius;
          buttonStyle = widget.filledButtonStyle.copyWith(shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: activeBorderRadius)));
        });
      },
      onTapUp: (tapUpDetails) {
        setState(() {
          buttonBorder = inactiveBorderRadius;
          buttonStyle = widget.filledButtonStyle.copyWith(shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: inactiveBorderRadius)));
        });
      },
      onTapCancel: () {
        setState(() {
          buttonBorder = inactiveBorderRadius;
          buttonStyle = widget.filledButtonStyle.copyWith(shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: inactiveBorderRadius)));
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: AnimatedClipRRect(
          borderRadius: buttonBorder,
          duration: const Duration(milliseconds: 150),
          child:
          SizedBox(
            height: buttonHeight,
            width: buttonWidth,
            child: FilledButton(
              onPressed: () => appState.buttonPressed(widget.buttonText),
              style: buttonStyle,
              child: Text(
                widget.buttonText,
                style: textStyle,
              ),
            ),
          )
        ),
      ),
    );

    // return GestureDetector(
    //   onTapDown: (tapDownDetails) {
    //     setState(() {
    //       buttonBorder = activeBorderRadius;
    //     });
    //   },
    //   onTapUp: (tapUpDetails) {
    //     setState(() {
    //       buttonBorder = inactiveBorderRadius;
    //     });
    //   },
    //   onTapCancel: () {
    //     setState(() {
    //       buttonBorder = inactiveBorderRadius;
    //     });
    //   },
    //   child: Padding(
    //     padding: const EdgeInsets.all(3.0),
    //     child: AnimatedClipRRect(
    //       borderRadius: buttonBorder,
    //       duration: const Duration(milliseconds: 200),
    //       child:
    //       Container(
    //         color: Theme.of(context).colorScheme.primary,
    //         alignment: Alignment.center,
    //         constraints: BoxConstraints(
    //           maxWidth: buttonWidth,
    //           maxHeight: buttonHeight,
    //         ),
    //         child: Text(
    //           widget.buttonText,
    //           style: textStyle,
    //         ),
    //       )
    //     ),
    //   ),
    // );
  }
}


class AnimatedClipRRect extends StatelessWidget {
  const AnimatedClipRRect({
    super.key,
    required this.duration,
    this.curve = Curves.linear,
    required this.borderRadius,
    required this.child,
  });

  final Duration duration;
  final Curve curve;
  final BorderRadius borderRadius;
  final Widget child;

  static Widget _builder(
      BuildContext context, BorderRadius radius, Widget? child) {
    return ClipRRect(borderRadius: radius, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<BorderRadius>(
      duration: duration,
      curve: curve,
      tween: Tween<BorderRadius>(begin: borderRadius, end: borderRadius),
      builder: _builder,
      child: child,
    );
  }
}