import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel();

  bool? _isValid;
  bool? get isValid => _isValid;

  bool _showPassword = false;
  bool get showPassword => _showPassword;

  @override
  Future<void> initModel() async {
    // setBusy(true);
    // await _fetchData();
    // setBusy(false);
  }

  // Future<void> _fetchData() async {
  //   await Future<void>.delayed(const Duration(seconds: 2));
  // }

  Future<bool?> requestLogin(String username, String password) async {
    setBusy(true);
    await Future<void>.delayed(const Duration(seconds: 2));
    _isValid = username == "admin" && password == "admin";
    setBusy(false);
    return _isValid;
  }

  void setShowPassword(bool value) {
    _showPassword = value;
    notifyListeners();
  }
}
