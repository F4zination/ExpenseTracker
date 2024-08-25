import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String username = '';

  UserProvider() {
    _loadUsername();
  }

  String get getUsername => username;

  void _loadUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username') ?? '';
    notifyListeners();
  }

  void setUsername(String newUsername) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', newUsername);
    username = newUsername;
    notifyListeners();
  }
}

final userProvider = ChangeNotifierProvider<UserProvider>((ref) {
  return UserProvider();
});
