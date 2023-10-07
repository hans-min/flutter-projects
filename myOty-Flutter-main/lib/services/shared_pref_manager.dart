import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

enum SharedPrefKey {
  token,
  username,
  userUUID,
  clientUUID,
  networkID,
  networkColor,
  placemarks,
}

class SharedPrefs {
  static late final SharedPreferences _prefsInstance;
  static Future<SharedPreferences> init() async =>
      _prefsInstance = await SharedPreferences.getInstance();
  static String? get token => getValue(SharedPrefKey.token);
  static String? get username => getValue<String>(SharedPrefKey.username);
  static String? get userUUID => getValue(SharedPrefKey.userUUID);
  static String? get clientUUID => getValue(SharedPrefKey.clientUUID);
  static String? get networkID => getValue(SharedPrefKey.networkID);
  static String? get networkColor => getValue(SharedPrefKey.networkColor);

  static Future<bool> setToken(String newValue) async =>
      setValue(SharedPrefKey.token, newValue);

  static void clearWithoutUsername() {
    for (final key in SharedPrefKey.values) {
      if (key == SharedPrefKey.username) continue;
      _prefsInstance.remove(key.name);
    }
  }

  static set username(String? newValue) {
    setValue(SharedPrefKey.username, newValue);
  }

  static set networkID(String? newValue) {
    setValue(SharedPrefKey.networkID, newValue);
  }

  static set networkColor(String? newValue) {
    setValue(SharedPrefKey.networkColor, newValue);
  }

  static set clientUUID(String? newValue) {
    setValue(SharedPrefKey.clientUUID, newValue);
  }

  static set userUUID(String? newValue) {
    setValue(SharedPrefKey.userUUID, newValue);
  }

  static T? getValue<T>(SharedPrefKey key) {
    switch (T) {
      case int:
        return _prefsInstance.getInt(key.name) as T?;
      case double:
        return _prefsInstance.getDouble(key.name) as T?;
      case String:
        return _prefsInstance.getString(key.name) as T?;
      case bool:
        return _prefsInstance.getBool(key.name) as T?;
      default:
        log("why does it go to default ??");
    }
    return null;
  }

  static Future<bool> setValue<T>(SharedPrefKey key, T? value) {
    if (value == null) {
      return Future.value(false);
    }
    switch (T) {
      case int:
        return _prefsInstance.setInt(key.name, value as int);
      case double:
        return _prefsInstance.setDouble(key.name, value as double);
      case String:
        return _prefsInstance.setString(key.name, value as String);
      case bool:
        return _prefsInstance.setBool(key.name, value as bool);
      default:
        assert(
          value is Map<String, dynamic>,
          'value must be int, double, String, bool or Map<String, dynamic>',
        );
        return Future.value(false);
      // final stringObject = jsonEncode(value);
      // _prefsInstance.setString(key.name, stringObject);
    }
  }
}
