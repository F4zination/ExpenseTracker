import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/provider/expense_types_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart' hide serializeIcon;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddExpenseTypeDialog extends ConsumerStatefulWidget {
  const AddExpenseTypeDialog({super.key});

  @override
  ConsumerState<AddExpenseTypeDialog> createState() =>
      _AddExpenseTypeDialogState();
}

class _AddExpenseTypeDialogState extends ConsumerState<AddExpenseTypeDialog> {
  final TextEditingController titleController = TextEditingController();

  late final ExpenseTypesProvider _expenseTypeProvider;
  IconPickerIcon? _icon;
  Color? _color;
  bool _isExpense = true;

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _expenseTypeProvider = ref.watch(expenseTypesProvider);
    });
  }

  void submit() {
    String title = titleController.text.trim();

    if (title.isEmpty) {
      debugPrint('Title is empty');
      return;
    }
    if (_icon == null) {
      debugPrint('Icon is null');
      return;
    }
    if (_color == null) {
      debugPrint('Color is null');
      return;
    }

    ExpenseType newExpenseType = ExpenseType(
      name: title,
      icon: _icon!,
      color: _color!,
      isExpense: _isExpense,
    );

    _expenseTypeProvider.addExpenseType(newExpenseType);
    Navigator.of(context).pop();
  }

  _pickIcon() async {
    IconPickerIcon? icon = await showIconPicker(
      context,
      iconPackModes: const [
        IconPack.fontAwesomeIcons,
        IconPack.lineAwesomeIcons,
        IconPack.allMaterial,
      ],
      backgroundColor: const Color(0xFF373737),
      iconColor: _color ?? Colors.white,
      noResultsText: 'No results found',
      searchHintText: 'Search Icon for ${titleController.text}',
    );
    if (icon == null) return;
    _icon = icon;
    setState(() {});

    debugPrint('Picked Icon:  ${icon.data}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF373737),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'Add a new Category',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          TextField(
            autocorrect: true,
            controller: titleController,
            maxLength: 50,
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration:
                const InputDecoration(labelText: 'Title', hintText: 'Title'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(_isExpense ? 'Expense' : 'Income'),
              const SizedBox(width: 16),
              Switch(
                value: _isExpense,
                onChanged: (value) {
                  setState(() {
                    _isExpense = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              ElevatedButton(
                  onPressed: _pickIcon, child: const Text('Open IconPicker')),
              const SizedBox(width: 32),
              _icon != null
                  ? Icon(
                      _icon!.data,
                      color: _color ?? Colors.white,
                    )
                  : const Icon(Icons.error_outline),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final Color? color = await showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: const Text('Pick a color'),
                        children: [
                          SingleChildScrollView(
                              child: ColorPicker(
                            pickerColor: Colors.blue,
                            onColorChanged: (color) {
                              _color = color;
                            },
                          )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel')),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(_color);
                                  },
                                  child: const Text('Select')),
                            ],
                          )
                        ],
                      );
                    },
                  );
                  if (color != null) {
                    _color = color;
                    setState(() {});
                  }
                },
                child: const Text('Pick a color'),
              ),
              const SizedBox(width: 32),
              _color != null
                  ? Container(
                      width: 32,
                      height: 32,
                      color: _color,
                    )
                  : const Icon(Icons.error_outline),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(40, 147, 53, 53)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(40, 34, 255, 0)),
                onPressed: () {
                  debugPrint('Adding expense type');
                  submit();
                },
                child: const Text('Add ExpenseType',
                    style: TextStyle(
                      color: Colors.black,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
