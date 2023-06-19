import 'dart:convert';
import 'package:rejo_jaya_sakti_apps/core/models/profile/profile_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SharedPrefKeys {
  profileData,
  authenticationToken,
  userId,
  approvalNotificationBatchNumber,
}

extension SharedPrefKeysExt on SharedPrefKeys {
  static const Map<SharedPrefKeys, String> _labels = <SharedPrefKeys, String>{
    SharedPrefKeys.profileData: 'profile_data',
    SharedPrefKeys.authenticationToken: 'authentication_token',
    SharedPrefKeys.userId: "user_id",
    SharedPrefKeys.approvalNotificationBatchNumber:
        "approval_notif_batch_number",
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
      case SharedPrefKeys.profileData:
        final String? raw = _sharedPreferences.getString(
          SharedPrefKeys.profileData.label,
        );
        if (raw == null) {
          return null;
        }
        try {
          final Map<String, dynamic> result = json.decode(raw);
          return ProfileData.fromJson(result);
        } catch (e) {
          return null;
        }
      case SharedPrefKeys.authenticationToken:
      case SharedPrefKeys.userId:
      case SharedPrefKeys.approvalNotificationBatchNumber:
        final String? raw = _sharedPreferences.getString(
          key.label,
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

  Future<void> remove(SharedPrefKeys key) async {
    await _getSharedPreferences();
    await _sharedPreferences.remove(key.label);
  }

  Future<void> clearStorage() async {
    await _sharedPreferences.clear();
  }
}
