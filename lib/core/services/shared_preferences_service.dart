import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum SharedPrefKeys { loginData, authenticationToken }

extension SharedPrefKeysExt on SharedPrefKeys {
  static const Map<SharedPrefKeys, String> _labels = <SharedPrefKeys, String>{
    SharedPrefKeys.loginData: 'login_data',
    SharedPrefKeys.authenticationToken: 'authentication_token',
  };

  String get label => _labels[this] ?? '';
}

class SharedPreferencesService {
  late SharedPreferences _sharedPreferences;
  bool _ready = false;

  Future<void> _getSharedPreferences() async {
    if (!_ready) {
      _sharedPreferences = await SharedPreferences.getInstance();
      _ready = true;
    }
  }

  Future<dynamic> get(SharedPrefKeys key) async {
    await _getSharedPreferences();
    switch (key) {
      case SharedPrefKeys.loginData:
        final String? raw = _sharedPreferences.getString(
          SharedPrefKeys.loginData.label,
        );
        if (raw == null) {
          return null;
        }
        final Map<String, dynamic> result = json.decode(raw);
        return '';
      // return LoginResponse.fromJson(result);
      case SharedPrefKeys.authenticationToken:
        final String? raw = _sharedPreferences.getString(
          SharedPrefKeys.authenticationToken.label,
        );
        if (raw == null) {
          return null;
        }
        return json.decode(raw);
    }
  }

  Future<void> set(SharedPrefKeys key, dynamic value) async {
    await _getSharedPreferences();
    final String jsonString = json.encode(value);

    await _sharedPreferences.setString(key.label, jsonString);
  }

  Future<void> clearStorage() async {
    await _sharedPreferences.clear();
  }
}
