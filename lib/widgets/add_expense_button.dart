import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/provider/expense_list_provider.dart';
import 'package:expensetracker/provider/expense_types_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddExpenseButton extends ConsumerWidget {
  const AddExpenseButton({
    super.key,
    required this.expenseType,
    required this.onPressed,
  });

  final ExpenseType expenseType;
  final void Function() onPressed;

  Color reduceLightness(Color color, double factor) {
    // Convert the Color to HSLColor
    HSLColor hslColor = HSLColor.fromColor(color);

    // Reduce the lightness by the factor, ensuring it doesn't go below 0
    double newLightness = (hslColor.lightness * (1 + factor)).clamp(0.0, 1.0);

    // Create a new HSLColor with the reduced lightness
    HSLColor adjustedHslColor = hslColor.withLightness(newLightness);

    // Convert it back to Flutter's Color
    return adjustedHslColor.toColor();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Column(
        children: [
          InkWell(
            onTap: onPressed,
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        backgroundColor: const Color.fromARGB(255, 43, 43, 43),
                        title: const Text('Delete Expense-Type?',
                            style: TextStyle(color: Colors.white)),
                        content: Text(
                            'Are you sure you want to delete the expense type ${expenseType.name}?',
                            style: const TextStyle(color: Colors.white)),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref
                                      .read(expenseTypesProvider.notifier)
                                      .deleteExpenseType(expenseType);
                                  ref
                                      .read(expenseListProvider)
                                      .categoryWasRemoved(expenseType);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Yes',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ],
                      ));
            },
            child: Card(
              color: reduceLightness(expenseType.color, 0.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(90),
              ),
              child: SizedBox(
                width: 75,
                height: 75,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(expenseType.icon.data,
                      size: 45, color: expenseType.color),
                ),
              ),
            ),
          ),
          // Text(text,
          //     style: const TextStyle(
          //       fontSize: 15,
          //     )),
        ],
      ),
    );
  }
}
