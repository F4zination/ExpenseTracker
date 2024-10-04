import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/provider/expense_types_provider.dart';
import 'package:expensetracker/widgets/circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart' hide serializeIcon;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool _recurringExpense = false;

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
      configuration: SinglePickerConfiguration(
        iconPackModes: const [
          IconPack.fontAwesomeIcons,
          IconPack.lineAwesomeIcons,
          IconPack.allMaterial,
        ],
        backgroundColor: const Color(0xFF373737),
        iconColor: Colors.white,
        noResultsText: 'No results found',
        searchHintText: 'Search Icon for ${titleController.text}',
      ),
    );
    if (icon == null) return;
    _icon = icon;
    setState(() {});

    debugPrint('Picked Icon:  ${icon.data}');
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    CircleIcon(
                        icon: _icon ??
                            const IconPickerIcon(
                                name: 'question_mark',
                                data: Icons.question_mark_rounded,
                                pack: IconPack.material),
                        color:
                            _color ?? const Color.fromARGB(255, 161, 161, 161),
                        iconColor: _color == null
                            ? const Color.fromARGB(255, 138, 138, 138)
                            : null,
                        width: 90,
                        height: 90,
                        iconSize: 55,
                        onPressed: _pickIcon),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'New Category',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Padding(
                          padding: _recurringExpense
                              ? const EdgeInsets.symmetric(vertical: 1)
                              : const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              FlutterSwitch(
                                  height: 26,
                                  width: 45,
                                  padding: 3,
                                  activeColor:
                                      const Color.fromARGB(255, 161, 161, 161),
                                  inactiveColor:
                                      const Color.fromARGB(255, 127, 127, 127),
                                  value: _recurringExpense,
                                  onToggle: (value) {
                                    setState(() {
                                      _recurringExpense = value;
                                    });
                                  }),
                              const SizedBox(width: 16),
                              Text(
                                  _recurringExpense
                                      ? 'recurring'
                                      : 'occasional',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 156, 156, 156),
                                      fontSize: 18)),
                              const SizedBox(width: 8),
                              _recurringExpense
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.calendar_month_outlined,
                                        color:
                                            Color.fromARGB(255, 156, 156, 156),
                                      ),
                                      onPressed: () {})
                                  : const SizedBox(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
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
                    canRequestFocus: true,
                    controller: titleController,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    decoration: InputDecoration(
                      labelText: 'Name of category',
                      alignLabelWithHint: true,
                      labelStyle: GoogleFonts.asapCondensed(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(171, 255, 255, 255),
                          fontSize: 18,
                          wordSpacing: 1.5,
                          letterSpacing: 0.5,
                        ),
                      ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Center(
                      child: RadioListTile<String>(
                        title: const Text('Expenses',
                            style:
                                TextStyle(fontSize: 17, color: Colors.white)),
                        value: 'Expenses',
                        groupValue: _isExpense ? 'Expenses' : 'Income',
                        onChanged: (value) {
                          setState(() {
                            _isExpense = value! == 'Expenses';
                          });
                        },
                        contentPadding: const EdgeInsets.all(0),
                        activeColor: const Color.fromARGB(159, 255, 255, 255),
                        fillColor: WidgetStateProperty.all(
                            const Color.fromARGB(60, 255, 255, 255)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Center(
                      child: RadioListTile<String>(
                        title: const Text('Income',
                            style:
                                TextStyle(fontSize: 17, color: Colors.white)),
                        value: 'Income',
                        groupValue: _isExpense ? 'Expenses' : 'Income',
                        onChanged: (value) {
                          setState(() {
                            _isExpense = value! == 'Expenses';
                          });
                        },
                        contentPadding: const EdgeInsets.all(0),
                        activeColor: const Color.fromARGB(159, 255, 255, 255),
                        fillColor: WidgetStateProperty.all(
                            const Color.fromARGB(60, 255, 255, 255)),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              const Color.fromARGB(117, 127, 127, 127)),
                        ),
                        onPressed: () async {
                          final Color? color = await showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: const Text('Pick a color',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                                backgroundColor:
                                    const Color.fromARGB(255, 127, 127, 127),
                                children: [
                                  SingleChildScrollView(
                                      child: ColorPicker(
                                    pickerColor: _color ?? Colors.white,
                                    onColorChanged: (color) {
                                      _color = color;
                                    },
                                  )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                    const Color.fromARGB(
                                                        40, 91, 91, 91)),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                    const Color.fromARGB(
                                                        40, 91, 91, 91)),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop(_color);
                                          },
                                          child: const Text('Select',
                                              style: TextStyle(
                                                  color: Colors.white))),
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
                        child: SizedBox(
                          width: 85,
                          child: _color == null
                              ? Text(
                                  'Pick a color',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          171, 255, 255, 255),
                                      fontSize: 16,
                                      fontFamily: GoogleFonts.asapCondensed()
                                          .fontFamily,
                                      wordSpacing: 1.5,
                                      letterSpacing: 0.5,
                                      fontStyle: FontStyle.italic),
                                )
                              : CircleAvatar(
                                  backgroundColor: _color,
                                  radius: 15,
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              const Color.fromARGB(117, 127, 127, 127)),
                        ),
                        onPressed: _pickIcon,
                        child: SizedBox(
                          width: 85,
                          child: _icon == null
                              ? Text('Pick an icon',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          171, 255, 255, 255),
                                      fontSize: 16,
                                      fontFamily: GoogleFonts.asapCondensed()
                                          .fontFamily,
                                      wordSpacing: 1.5,
                                      letterSpacing: 0.5,
                                      fontStyle: FontStyle.italic))
                              : Icon(_icon!.data, color: _color, size: 30),
                        ),
                      ),
                    ),
                  ),
                ],
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
                      submit();
                    },
                    icon:
                        const Icon(Icons.check, color: Colors.green, size: 30),
                  ),
                ],
              ),
            ],
          )),
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
