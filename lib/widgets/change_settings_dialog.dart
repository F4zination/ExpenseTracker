import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangeSettingsDialog extends ConsumerStatefulWidget {
  const ChangeSettingsDialog(
      {Key? key,
      required this.title,
      required this.hintText,
      required this.keyboardType,
      required this.onSave})
      : super(key: key);

  final String title;
  final String hintText;
  final TextInputType keyboardType;
  final void Function(dynamic) onSave;

  @override
  ConsumerState<ChangeSettingsDialog> createState() =>
      _ChangeSettingDialogState();
}

class _ChangeSettingDialogState extends ConsumerState<ChangeSettingsDialog> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 81, 81, 81),
      title: Text('Change ${widget.title}',
          style: const TextStyle(color: Colors.white)),
      content: TextField(
        controller: textController,
        autofocus: true,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.hintText,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            if (textController.text.isEmpty) {
              return;
            } else if (widget.keyboardType == TextInputType.number) {
              widget.onSave(double.parse(textController.text));
            } else if (widget.keyboardType == TextInputType.text) {
              widget.onSave(textController.text);
            }
            Navigator.of(context).pop();
          },
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
