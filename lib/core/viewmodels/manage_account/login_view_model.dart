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

  bool? _isValid;
  bool? get isValid => _isValid;

  bool _showPassword = false;
  bool get showPassword => _showPassword;

  String _inputUser = "Uname22";
  String get inputUser => _inputUser;

  String _password = "Hello789";
  String get password => _password;

  // @override
  // Future<void> initModel() async {
  //   setBusy(true);
  //   await _fetchDataHasLogin();
  //   setBusy(false);
  // }

  void setInputUser({required String inputUser}) {
    _inputUser = inputUser;
  }

  void setPassword({required String password}) {
    _password = password;
  }

  Future<bool> requestLogin() async {
    setBusy(true);
    final response = await _apiService.requestLogin(
      inputUser: _inputUser,
      password: _password,
    );

    if (response != null) await _authenticationService.setLogin(response);

    setBusy(false);
    return response != null;
  }

  void setShowPassword(bool value) {
    _showPassword = value;
    notifyListeners();
  }
}
