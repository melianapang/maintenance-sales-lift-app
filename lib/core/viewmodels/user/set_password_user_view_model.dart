import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class SetPasswordViewUserModel extends BaseViewModel {
  SetPasswordViewUserModel();

  final newPasswordController = TextEditingController();
  final newConfirmPasswordController = TextEditingController();

  String _newPassword = "";
  String get newPassword => _newPassword;

  String _newConfirmPassword = "";
  String get newConfirmPassword => _newConfirmPassword;

  bool? _isValid;
  bool? get isValid => _isValid;

  bool _showNewPassword = false;
  bool get showNewPassword => _showNewPassword;

  bool _showConfirmNewPassword = false;
  bool get showConfirmNewPassword => _showConfirmNewPassword;

  @override
  Future<void> initModel() async {}

  void setNewPassword(String value) {
    _newPassword = value;
    notifyListeners();
  }

  void setNewConfirmPassword(String value) {
    _newConfirmPassword = value;
    notifyListeners();
  }

  void setShowNewPassword() {
    _showNewPassword = !_showNewPassword;
    notifyListeners();
  }

  void setShowConfirmNewPassword() {
    _showConfirmNewPassword = !_showConfirmNewPassword;
    notifyListeners();
  }
}
