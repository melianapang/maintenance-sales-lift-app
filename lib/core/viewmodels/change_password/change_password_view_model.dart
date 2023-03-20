import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ChangePasswordViewModel extends BaseViewModel {
  ChangePasswordViewModel();

  bool? _isValid;
  bool? get isValid => _isValid;

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
}