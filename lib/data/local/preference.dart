import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PreferenceKey { isLoggedIn }

extension PerferenceKeyExtension on PreferenceKey {
  String get key {
    switch (this) {
      case PreferenceKey.isLoggedIn:
        return dotenv.get('IS_LOGGED_IN');
    }
  }
}

class Preferences {
  // Singleton instance
  static final Preferences _instance = Preferences._internal();

  // Private constructor
  Preferences._internal();

  // Factory constructor to return the same instance
  factory Preferences() {
    return _instance;
  }

  Future<void> setValue(PreferenceKey key, dynamic value) async {
    final preferences = await SharedPreferences.getInstance();
    if (value is bool) {
      await preferences.setBool(key.key, value);
    } else if (value is String) {
      await preferences.setString(key.key, value);
    } else if (value is int) {
      await preferences.setInt(key.key, value);
    } else if (value is double) {
      await preferences.setDouble(key.key, value);
    }
  }

  Future<dynamic> getValue(PreferenceKey key, {dynamic defaultValue}) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.get(key.key) ?? defaultValue;
  }

  Future<void> removeValue(String key) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(key);
  }

  Future<void> login() async {
    final prefrences = await SharedPreferences.getInstance();
    await prefrences.setBool(dotenv.get('IS_LOGGED_IN'), true);
  }

  Future<void> logout() async {
    final prefrences = await SharedPreferences.getInstance();
    await prefrences.setBool(dotenv.get('IS_LOGGED_IN'), false);
  }

  Future<bool?> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(dotenv.get('IS_LOGGED_IN')) ?? false;
  }

  Future<void> saveIsEmailSaved(bool? isSaved) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(dotenv.get('IS_EMAIL_SAVED'), isSaved ?? false);
  }

  Future<bool?> getIsEmailSaved() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(dotenv.get('IS_EMAIL_SAVED'));
  }

  Future<void> saveEmail(String email) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(dotenv.get('EMAIL_KEY'), email);
  }

  Future<void> deleteEmail() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(dotenv.get('EMAIL_KEY'));
  }

  Future<String?> getEmail() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(dotenv.get('EMAIL_KEY'));
  }
}
