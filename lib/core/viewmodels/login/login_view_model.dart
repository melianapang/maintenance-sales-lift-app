import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel();

  bool? _isValid;
  bool? get isValid => _isValid;

  bool _showPassword = false;
  bool get showPassword => _showPassword;

  String _inputUser = "Indra1999@email.com";
  String get inputUser => _inputUser;

  String _password = "Hello6789";
  String get password => _password;

  @override
  Future<void> initModel() async {
    // setBusy(true);
    // await _fetchData();
    // setBusy(false);
  }

  // Future<void> _fetchData() async {
  //   await Future<void>.delayed(const Duration(seconds: 2));
  // }

  void setInputUser({required String inputUser}) {
    _inputUser = inputUser;
  }

  void setPassword({required String password}) {
    _password = password;
  }

  Future<bool> requestLogin() async {
    setBusy(true);

    setBusy(false);
    return true;
  }

  void setShowPassword(bool value) {
    _showPassword = value;
    notifyListeners();
  }
}
