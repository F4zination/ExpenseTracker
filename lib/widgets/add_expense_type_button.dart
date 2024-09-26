import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddExpenseTypeButton extends ConsumerWidget {
  const AddExpenseTypeButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final bool passthrough = true;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  icon: const Icon(Icons.post_add_rounded))),
        ),
        Text(text,
            style: const TextStyle(
              fontSize: 15,
            )),
      ],
    );
  }
}
