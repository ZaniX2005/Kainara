import 'dart:math';

import 'package:flutter/foundation.dart';

import 'profile_store.dart';

enum AuthResult { ok, emailNotFound, wrongPassword }

enum AccountUpdateResult {
  ok,
  invalidEmail,
  emailAlreadyExists,
  accountNotFound,
  weakPassword,
}

class _User {
  String name, password;
  _User(this.name, this.password);
}

class AuthStore extends ChangeNotifier {
  AuthStore._();
  static final instance = AuthStore._();

  final Map<String, _User> _users = {
    'danielle21@gmail.com': _User('Danielle', 'Kainara123'),
  };

  bool loggedIn = false;

  static final _emailRe = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
  static bool validEmail(String e) => _emailRe.hasMatch(e.trim());

  AuthResult login(String email, String password) {
    final u = _users[email.trim().toLowerCase()];
    if (u == null) return AuthResult.emailNotFound;
    if (u.password != password) return AuthResult.wrongPassword;
    loggedIn = true;
    ProfileStore.instance.update(
      name: u.name,
      email: email.trim(),
      password: u.password,
    );
    notifyListeners();
    return AuthResult.ok;
  }

  /// false jika email sudah terdaftar
  bool register(String name, String email, String password) {
    final key = email.trim().toLowerCase();
    if (_users.containsKey(key)) return false;
    _users[key] = _User(name.trim(), password);
    login(email, password);
    return true;
  }

  bool emailExists(String email) =>
      _users.containsKey(email.trim().toLowerCase());

  void resetPassword(String email, String newPassword) {
    final key = email.trim().toLowerCase();
    final u = _users[key];
    if (u != null) u.password = newPassword;
    if (ProfileStore.instance.email.toLowerCase() == key) {
      ProfileStore.instance.update(password: newPassword);
    }
  }

  AccountUpdateResult updateEmail(String email) {
    final value = email.trim();
    if (!validEmail(value)) return AccountUpdateResult.invalidEmail;

    final currentKey = ProfileStore.instance.email.trim().toLowerCase();
    final nextKey = value.toLowerCase();
    final user = _users[currentKey];
    if (user == null) return AccountUpdateResult.accountNotFound;
    if (nextKey == currentKey) return AccountUpdateResult.ok;
    if (_users.containsKey(nextKey)) {
      return AccountUpdateResult.emailAlreadyExists;
    }

    _users.remove(currentKey);
    _users[nextKey] = user;
    ProfileStore.instance.update(email: value, verified: false);
    return AccountUpdateResult.ok;
  }

  AccountUpdateResult updatePassword(String password) {
    if (password.length < 6) return AccountUpdateResult.weakPassword;
    final user = _users[ProfileStore.instance.email.trim().toLowerCase()];
    if (user == null) return AccountUpdateResult.accountNotFound;
    user.password = password;
    ProfileStore.instance.update(password: password);
    return AccountUpdateResult.ok;
  }

  bool updateName(String name) {
    final user = _users[ProfileStore.instance.email.trim().toLowerCase()];
    if (user == null) return false;
    user.name = name.trim();
    ProfileStore.instance.update(name: user.name);
    return true;
  }

  void logout() {
    loggedIn = false;
    notifyListeners();
  }
}

enum OtpPurpose { register, reset }

/// Data yang dibawa selama alur OTP.
class OtpFlow {
  final OtpPurpose purpose;
  final String email, name, password;
  late String code;

  OtpFlow({
    required this.purpose,
    required this.email,
    this.name = '',
    this.password = '',
  }) {
    regenerate();
  }

  void regenerate() => code = (10000 + Random().nextInt(90000)).toString();
}
