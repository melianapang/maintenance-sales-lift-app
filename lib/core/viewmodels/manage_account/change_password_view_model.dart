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

  String _oldPassword = "";
  String get oldPassword => _oldPassword;

  String _newPassword = "";
  String get newPassword => _newPassword;

  String _confirmNewPassword = "";
  String get confirmNewPassword => _confirmNewPassword;

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

  void setOldPassword({required String password}) {
    _oldPassword = password;
  }

  void setNewPassword({required String password}) {
    _newPassword = password;
  }

  void setConfirmNewPassword({required String password}) {
    _confirmNewPassword = password;
  }

  Future<bool> requrestChangePassword() async {
    return await _apiService.requestChangePassword(
      oldPassword: _oldPassword,
      newPassword: _newPassword,
      passwordConfirmation: _confirmNewPassword,
    );
  }
}
