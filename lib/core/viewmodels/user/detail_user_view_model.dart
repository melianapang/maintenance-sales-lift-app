import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/user/user_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailUserViewModel extends BaseViewModel {
  DetailUserViewModel({
    UserData? userData,
    required DioService dioService,
    required AuthenticationService authenticationService,
  })  : _userData = userData,
        _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _authenticationService = authenticationService;

  final ApiService _apiService;
  final AuthenticationService _authenticationService;

  UserData? _userData;
  UserData? get userData => _userData;

  bool _isAllowedToDeleteUser = false;
  bool get isAllowedToDeleteUser => _isAllowedToDeleteUser;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await _checkIsAllowedToDeleteUser();
    setBusy(false);
  }

  Future<void> _checkIsAllowedToDeleteUser() async {
    Role role = await _authenticationService.getUserRole();
    _isAllowedToDeleteUser = role == Role.Admin || role == Role.SuperAdmin;
  }

  Future<bool> requestDeleteUser() async {
    final response = await _apiService.requestDeleteUser(
      userId: int.parse(_userData?.userId ?? "0"),
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }

  Future<void> requestGetDetailCustomer() async {
    setBusy(true);
    final response = await _apiService.requestUserDetail(
      userId: int.parse(_userData?.userId ?? "0"),
    );

    if (response.isRight) {
      _userData = response.right;
      notifyListeners();
    }
    setBusy(false);
  }
}
