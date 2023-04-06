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

  bool? _isValid;
  bool? get isValid => _isValid;

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _showOldPassword = false;
  bool get showOldPassword => _showOldPassword;

  bool _showNewPassword = false;
  bool get showNewPassword => _showNewPassword;

  bool _showConfirmNewPassword = false;
  bool get showConfirmNewPassword => _showConfirmNewPassword;

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

  Future<bool> requestChangePassword() async {
    var result = await _apiService.requestChangePassword(
      oldPassword: oldPasswordController.text,
      newPassword: newPasswordController.text,
      passwordConfirmation: confirmPasswordController.text,
    );

    if (result.isRight) return result.right;
    return false;
  }
}
