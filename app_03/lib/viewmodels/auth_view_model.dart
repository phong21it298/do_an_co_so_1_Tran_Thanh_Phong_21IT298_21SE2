import 'package:flutter/material.dart';
import 'package:app_03/model/local/user.dart';
import 'package:app_03/services/anime_database_helper.dart';

class AuthViewModel extends ChangeNotifier {
  final AnimeDatabaseHelper _dbHelper = AnimeDatabaseHelper();
  User? _currentUser;

  User? get currentUser => _currentUser;

  int get currentUserId => _currentUser?.id ?? 0;

  //bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    final user = await _dbHelper.getUserByEmailAndPassword(email, password);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      await _dbHelper.insertUser(User(name: name, email: email, password: password));
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
