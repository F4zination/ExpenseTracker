import 'package:expensetracker/provider/user_provider.dart';
import 'package:expensetracker/widgets/change_username_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('General'),
            tiles: [
              SettingsTile(
                title: Text('Language'),
                leading: const Icon(Icons.language),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: Text('Theme'),
                leading: const Icon(Icons.brightness_6),
                onPressed: (BuildContext context) {},
              ),
            ],
          ),
          SettingsSection(
            title: Text('Account'),
            tiles: [
              SettingsTile(
                title: const Text('Change Username'),
                description: Text(ref.watch(userProvider).getUsername),
                leading: const Icon(Icons.person),
                onPressed: (BuildContext context) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ChangeUsernameDialog();
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
