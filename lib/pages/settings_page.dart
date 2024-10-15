import 'package:expensetracker/controller/database_controller.dart';
import 'package:expensetracker/provider/max_spending_provider.dart';
import 'package:expensetracker/provider/user_provider.dart';
import 'package:expensetracker/widgets/change_settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String numberFormated(double number) {
    // Create a NumberFormat instance with two decimal places
    final formatter = NumberFormat('#,##0.00', 'de_DE');
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 81, 81, 81),
        title: const Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('General'),
            tiles: [
              SettingsTile(
                title: const Text('Delete all Expenses'),
                leading: const Icon(Icons.delete_forever),
                onPressed: (BuildContext context) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete Expenses'),
                        content: const Text(
                            'Are you sure you want to delete all Expenses?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () {
                              DatabaseController databaseController =
                                  DatabaseController();
                              databaseController.deleteAllExpenses();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Account'),
            tiles: [
              SettingsTile(
                title: const Text('Change Username'),
                description: Text(ref.watch(userProvider).getUsername),
                leading: const Icon(Icons.person),
                onPressed: (BuildContext context) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ChangeSettingsDialog(
                        title: 'Username',
                        hintText: 'Enter your new Username',
                        keyboardType: TextInputType.text,
                        onSave: (newUsername) {
                          ref.read(userProvider).setUsername(newUsername);
                        },
                      );
                    },
                  );
                },
              ),
              SettingsTile(
                title: const Text('Change Max. Spending'),
                description: Text(numberFormated(
                    ref.watch(maxSepndingProvider).getMaxSpendings)),
                leading: const Icon(Icons.person),
                onPressed: (BuildContext context) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ChangeSettingsDialog(
                        title: 'Max. Spending',
                        hintText: 'Enter your new Max. Spending',
                        keyboardType: TextInputType.number,
                        onSave: (newMaxSpending) {
                          if (double.parse(newMaxSpending) <= 0) {
                            debugPrint('Value must be greater than 0');
                            newMaxSpending = '1.0';
                          }
                          ref
                              .read(maxSepndingProvider)
                              .setNewMaxSpendings(double.parse(newMaxSpending));
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SettingsSection(title: const Text('About'), tiles: [
            SettingsTile(
              title: const Text('About'),
              leading: const Icon(Icons.info),
              onPressed: (BuildContext context) {
                showAboutDialog(
                  context: context,
                  applicationName: 'Expense Tracker',
                  applicationIcon: CircleAvatar(
                    child: Image.asset('assets/images/AppLogo.png'),
                  ),
                  applicationVersion: '1.0.0',
                  children: [
                    const Text(
                        'A simple expense tracker app.\nBy Finn Rehnert'),
                  ],
                  applicationLegalese: '© 2024 Expense Tracker',
                );
              },
            ),
            SettingsTile(
              title: const Text('Acknowledgements'),
              leading: const Icon(Icons.favorite),
              onPressed: (BuildContext context) => showAdaptiveDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Acknowledgements'),
                      content: SizedBox(
                        height: 140,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                                'This app was designed by Elisa Maglio.\nThank you!'),
                            const SizedBox(height: 10),
                            const Text('The Icons are partly from Flaticons.'),
                            TextButton(
                              onPressed: () async {
                                try {
                                  await launchUrl(
                                      Uri.parse("https://www.flaticon.com/"));
                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                              },
                              child: const Text('Visit Flaticons here!',
                                  style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    );
                  }),
            )
          ]),
        ],
      ),
    );
  }
}
