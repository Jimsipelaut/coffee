import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String? _userEmail;

  String? get userEmail => _userEmail;

  void login(String email) {
    _userEmail = email;
    notifyListeners();
  }

  void logout() {
    _userEmail = null;
    notifyListeners();
  }
}