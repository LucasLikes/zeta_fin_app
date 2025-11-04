import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  bool _isLoggedIn;
  String? _name;
  String? _email;

  AuthState({required bool isLoggedIn})
      : _isLoggedIn = isLoggedIn;

  bool get isLoggedIn => _isLoggedIn;
  String get name => _name ?? '';
  String get email => _email ?? '';

  void setUser({required String name, required String email}) {
    _name = name;
    _email = email;
    notifyListeners();
  }

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _name = null;
    _email = null;
    notifyListeners();
  }
}
