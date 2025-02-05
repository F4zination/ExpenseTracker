import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthDropdownButton extends StatelessWidget {
  const MonthDropdownButton({
    super.key,
    required this.month,
    required this.existingMonths,
    required this.onChange,
  });

  final DateTime month;
  final Function onChange;
  final List<DateTime> existingMonths;

  @override
  Widget build(BuildContext context) {
    debugPrint(existingMonths.toString());

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 43, 43, 43),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Color.fromARGB(255, 110, 110, 110)),
          underline: Container(),
          dropdownColor: const Color.fromARGB(255, 60, 60, 60),
          style: const TextStyle(color: Colors.white),
          items: existingMonths.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(DateFormat('MMMM-yyyy').format(e),
                  style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (value) {
            onChange(value);
          },
          hint: Text(DateFormat('MMMM-yyyy').format(month),
              style: const TextStyle(color: Colors.white70)),
        ),
      ),
    );
  }
}
