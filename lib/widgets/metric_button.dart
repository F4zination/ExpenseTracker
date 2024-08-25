import 'package:flutter/material.dart';

class MetricButton extends StatelessWidget {
  final String title;
  final void Function() onPressed;

  const MetricButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 75,
        width: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF5D9FAE),
              fontSize: 15,
            ),
          ),
          onPressed: () => onPressed(),
        ));
  }
}
