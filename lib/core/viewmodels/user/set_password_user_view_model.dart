import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/profile/profile_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class SetPasswordViewUserModel extends BaseViewModel {
  SetPasswordViewUserModel({
    ProfileData? profileData,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _profileData = profileData;

  final ApiService _apiService;

  final ProfileData? _profileData;

  final newPasswordController = TextEditingController();
  final newConfirmPasswordController = TextEditingController();

  String _newPassword = "";
  String get newPassword => _newPassword;

  String _newConfirmPassword = "";
  String get newConfirmPassword => _newConfirmPassword;

  bool _isNewPasswordValid = true;
  bool get isNewPasswordValid => _isNewPasswordValid;

  bool _isConfirmPasswordValid = true;
  bool get isConfirmPasswordValid => _isConfirmPasswordValid;

  bool _showNewPassword = false;
  bool get showNewPassword => _showNewPassword;

  bool _showConfirmNewPassword = false;
  bool get showConfirmNewPassword => _showConfirmNewPassword;

  String? _errorMsg = "";
  String? get errorMsg => _errorMsg;

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

  void onChangedNewPassword(String value) {
    _isNewPasswordValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedConfirmNewPassword(String value) {
    _isConfirmPasswordValid = value.isNotEmpty;
    notifyListeners();
  }

  bool _isValid() {
    _isConfirmPasswordValid = newConfirmPasswordController.text.isNotEmpty;
    _isNewPasswordValid = newPasswordController.text.isNotEmpty;
    notifyListeners();

    return _isNewPasswordValid && _isConfirmPasswordValid;
  }

  Future<bool> requestCreateUser() async {
    setBusy(true);

    if (!_isValid()) {
      _errorMsg = "Pastikan semua kolom terisi";
      return false;
    }

    final response = await _apiService.requestCreateUser(
      idRole: int.parse(
        mappingRoleToNumberString(
          Role.Admin,
        ),
      ),
      name: _profileData?.name ?? "",
      username: _profileData?.username ?? "",
      phoneNumber: _profileData?.phoneNumber ?? "",
      address: _profileData?.address ?? "",
      city: _profileData?.city ?? "",
      email: _profileData?.email ?? "",
      password: newPasswordController.text,
      passwordConfirmation: newConfirmPasswordController.text,
    );
    setBusy(false);

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }
}
