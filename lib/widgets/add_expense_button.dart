import 'package:flutter/material.dart';

class AddExpenseButton extends StatelessWidget {
  const AddExpenseButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.onPressed,
      this.passthrough = false});

  final String icon;
  final String text;
  final bool passthrough;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: passthrough ? Colors.white : const Color(0xFFC4D5E8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: passthrough
                ? const BorderSide(
                    color: Color(0xFF5D9FAE),
                    width: 2,
                  )
                : BorderSide.none,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: onPressed,
              icon: Image.asset(icon, width: 50),
            ),
          ),
        ),
        Text(text,
            style: const TextStyle(
              fontSize: 15,
            )),
      ],
    );
  }
}
