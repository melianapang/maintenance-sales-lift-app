import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/shared_preferences_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel({
    required DioService dioService,
    required AuthenticationService authenticationService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDio(),
          ),
        ),
        _sharedPreferencesService = SharedPreferencesService(),
        _authenticationService = authenticationService;

  final ApiService _apiService;
  final SharedPreferencesService _sharedPreferencesService;
  final AuthenticationService _authenticationService;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isUsernameValid = true;
  bool get isUsernameValid => _isUsernameValid;

  bool _isPasswordValid = true;
  bool get isPasswordValid => _isPasswordValid;

  bool _showPassword = false;
  bool get showPassword => _showPassword;

  String _inputUser = "Uname22";
  // String _inputUser = "Ananta99";
  String get inputUser => _inputUser;

  String _password = "Hello789";
  String get password => _password;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);

    // Dummy
    usernameController.text = _inputUser;
    passwordController.text = _password;
    // await _fetchDataHasLogin();
    setBusy(false);
  }

  void onChangedUsername(String value) {
    _isUsernameValid = value.isNotEmpty;
    notifyListeners();
  }

  void onChangedPassword(String value) {
    _isPasswordValid = value.isNotEmpty;
    notifyListeners();
  }

  Future<bool> requestLogin() async {
    final response = await _apiService.requestLogin(
      inputUser: usernameController.text,
      password: passwordController.text,
    );

    if (response.isRight) {
      await _authenticationService.setLogin(response.right);
      return true;
    }
    _errorMsg = response.left.message;
    return false;
  }

  void setShowPassword(bool value) {
    _showPassword = value;
    notifyListeners();
  }

  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      _isUsernameValid = false;
      return 'Username tidak boleh kosong';
    }
    _isUsernameValid = true;
    return null;
  }
}
