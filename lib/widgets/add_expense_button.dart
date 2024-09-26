import 'package:expensetracker/provider/expense_types_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddExpenseButton extends ConsumerWidget {
  const AddExpenseButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.onPressed,
      this.passthrough = false});

  final IconPickerIcon icon;
  final String text;
  final bool passthrough;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          onLongPress: () {
            showAdaptiveDialog(
                context: context,
                builder: (context) => SimpleDialog(
                      title: const Text(
                          'Are you sure you want to delete this expense type?'),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(expenseTypesProvider.notifier)
                                    .deleteExpenseType(text);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      ],
                    ));
          },
          child: Card(
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
              child: Icon(icon.data, size: 45, color: Colors.black),
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
