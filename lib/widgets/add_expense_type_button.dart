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
          color: const Color.fromARGB(53, 217, 217, 217),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(90),
          ),
          child: SizedBox(
            width: 75,
            height: 75,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: onPressed,
                    icon: const Icon(Icons.add_rounded,
                        size: 45, color: Colors.white))),
          ),
        ),
        // Text(text,
        //     style: const TextStyle(
        //       fontSize: 15,
        //     )),
      ],
    );
  }
}
