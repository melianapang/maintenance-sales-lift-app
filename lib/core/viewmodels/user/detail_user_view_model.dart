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

  bool _isPreviousPageNeedRefresh = false;
  bool get isPreviousPageNeedRefresh => _isPreviousPageNeedRefresh;

  UserData? _userData;
  UserData? get userData => _userData;

  bool _isAllowedToDeleteEditUser = false;
  bool get isAllowedToDeleteEditUser => _isAllowedToDeleteEditUser;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await _checkIsAllowedToDeleteAndEditUser();
    setBusy(false);
  }

  void setPreviousPageNeedRefresh(bool value) {
    _isPreviousPageNeedRefresh = value;
  }

  Future<void> _checkIsAllowedToDeleteAndEditUser() async {
    Role role = await _authenticationService.getUserRole();
    Role dataRole = mappingStringToRole(_userData?.roleName ?? "Teknisi");

    if (_userData?.userId == "1") {
      _isAllowedToDeleteEditUser = false;
      return;
    }

    _isAllowedToDeleteEditUser =
        (dataRole != Role.SuperAdmin && role == Role.Admin) ||
            role == Role.SuperAdmin;
  }

  void resetErrorMsg() {
    _errorMsg = null;
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

  Future<void> refreshPage() async {
    setBusy(true);
    resetErrorMsg();
    await requestGetDetailCustomer();
    setBusy(false);
  }
}
