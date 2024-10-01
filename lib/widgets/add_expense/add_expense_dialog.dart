import 'package:expensetracker/provider/expense_list_provider.dart';
import 'package:expensetracker/widgets/circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AddExpenseDialog extends ConsumerStatefulWidget {
  const AddExpenseDialog({super.key, required this.expenseType});

  final ExpenseType expenseType;

  @override
  ConsumerState<AddExpenseDialog> createState() => _AddExpenseState();
}

class _AddExpenseState extends ConsumerState<AddExpenseDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  late final ExpenseListProvider _expenseListProvider;

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _expenseListProvider = ref.watch(expenseListProvider);
    });
  }

  double get amount {
    final amountText = amountController.text;
    String amountWithoutComma = amountText.replaceAll(',', '.');
    // round the amount to 2 decimal places
    return double.tryParse(amountWithoutComma) ?? 0;
  }

  void submitExpense() {
    String title = titleController.text.trim();
    double amount = this.amount;

    final type = widget.expenseType;

    if (title.isEmpty) {
      title = type.name;
    }

    if (amount <= 0) {
      amountController.clear();
      return;
    }

    final newExpense = Expense(
      title: title,
      amount: amount,
      date: DateTime.now(),
      type: widget.expenseType,
    );

    _expenseListProvider.addExpense(newExpense);
    Navigator.of(context).pop();
  }

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
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFF373737),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                CircleIcon(
                  icon: widget.expenseType.icon,
                  color: widget.expenseType.color,
                ),
                const SizedBox(width: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.expenseType.name.replaceFirst(
                          widget.expenseType.name[0],
                          widget.expenseType.name[0].toUpperCase()),
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      widget.expenseType.isExpense ? 'Expense' : 'Income',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )
                  ],
                ),
              ]),
            ),
            const SizedBox(height: 24),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: const Color.fromARGB(117, 127, 127, 127),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: TextField(
                  autocorrect: true,
                  autofocus: false,
                  controller: titleController,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(
                        color: const Color.fromARGB(171, 255, 255, 255),
                        fontSize: 18,
                        fontFamily: GoogleFonts.asapCondensed().fontFamily,
                        wordSpacing: 1.5,
                        letterSpacing: 0.5,
                        fontStyle: FontStyle.italic),
                    contentPadding: const EdgeInsets.only(bottom: 17),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: InputBorder.none,
                    constraints:
                        const BoxConstraints(maxHeight: 46, minHeight: 46),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: const Color.fromARGB(117, 127, 127, 127),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(),
                  autocorrect: true,
                  autofocus: false,
                  controller: amountController,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  decoration: InputDecoration(
                    labelText: 'Amount (€)',
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(
                        color: const Color.fromARGB(171, 255, 255, 255),
                        fontSize: 18,
                        fontFamily: GoogleFonts.asapCondensed().fontFamily,
                        wordSpacing: 1.5,
                        letterSpacing: 0.5,
                        fontStyle: FontStyle.italic),
                    contentPadding: const EdgeInsets.only(bottom: 17),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: InputBorder.none,
                    constraints:
                        const BoxConstraints(maxHeight: 46, minHeight: 46),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // IconButton(
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   icon: const Icon(Icons.close, color: Colors.red),
                // ),
                IconButton(
                  onPressed: () {
                    submitExpense();
                  },
                  icon: const Icon(Icons.check, color: Colors.green, size: 30),
                ),
              ],
            ),
          ])),
      Positioned(
        top: 10,
        left: MediaQuery.of(context).size.width * 0.45,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
          child: Container(
            width: double.infinity,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white54,
            ),
          ),
        ),
      ),
    ]);
  }
}
