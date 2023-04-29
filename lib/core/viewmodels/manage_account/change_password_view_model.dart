import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ChangePasswordViewModel extends BaseViewModel {
  ChangePasswordViewModel({
    required DioService dioService,
  }) : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        );

  final ApiService _apiService;

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _showOldPassword = false;
  bool get showOldPassword => _showOldPassword;

  bool _showNewPassword = false;
  bool get showNewPassword => _showNewPassword;

  bool _showConfirmNewPassword = false;
  bool get showConfirmNewPassword => _showConfirmNewPassword;

  bool _isOldPasswordValid = true;
  bool get isOldPasswordValid => _isOldPasswordValid;

  bool _isNewPasswordValid = true;
  bool get isNewPasswordValid => _isNewPasswordValid;

  bool _isConfirmPasswordValid = true;
  bool get isConfirmPasswordValid => _isConfirmPasswordValid;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {}

  void setShowOldPassword(bool value) {
    _showOldPassword = value;
    notifyListeners();
  }

  void setShowNewPassword(bool value) {
    _showNewPassword = value;
    notifyListeners();
  }

  void setShowConfirmNewPassword(bool value) {
    _showConfirmNewPassword = value;
    notifyListeners();
  }

  void onChangedOldPassword(String value) {
    _isOldPasswordValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedNewPassword(String value) {
    _isNewPasswordValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedConfirmNewPassword(String value) {
    _isConfirmPasswordValid = value.isNotEmpty;
    notifyListeners();
  }

  bool isValidToRequest() {
    _isOldPasswordValid = oldPasswordController.text.isNotEmpty;
    _isConfirmPasswordValid = confirmPasswordController.text.isNotEmpty;
    _isNewPasswordValid = newPasswordController.text.isNotEmpty;
    notifyListeners();

    return _isOldPasswordValid &&
        _isNewPasswordValid &&
        _isConfirmPasswordValid;
  }

  void resetErrorMsg() {
    _errorMsg = null;
  }

  Future<bool> requestChangePassword() async {
    if (_isOldPasswordValid && _isNewPasswordValid && _isConfirmPasswordValid) {
      var result = await _apiService.requestChangePassword(
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
        passwordConfirmation: confirmPasswordController.text,
      );

      if (result.isRight) return result.right;

      _errorMsg = result.left.message;
      return false;
    }

    _errorMsg = "Tolong isi semua informasi dengan benar.";
    return false;
  }
}
