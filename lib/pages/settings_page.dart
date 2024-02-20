import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Section'),
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
                title: Text('Sign out'),
                leading: const Icon(Icons.exit_to_app),
                onPressed: (BuildContext context) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
