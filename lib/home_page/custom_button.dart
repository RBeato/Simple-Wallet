import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      required this.opacity})
      : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Opacity(
        opacity: opacity,
        child: ElevatedButton(
          child: Text(text),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
