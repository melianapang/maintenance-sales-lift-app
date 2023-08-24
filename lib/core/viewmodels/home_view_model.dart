import 'package:package_info_plus/package_info_plus.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/home_item_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/profile/profile_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/shared_preferences_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel({
    required DioService dioService,
    required AuthenticationService authenticationService,
    required SharedPreferencesService sharedPreferencesService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _authenticationService = authenticationService,
        _sharedPreferencesService = sharedPreferencesService;

  final ApiService _apiService;
  final AuthenticationService _authenticationService;
  final SharedPreferencesService _sharedPreferencesService;

  ProfileData? _profileData;
  ProfileData? get profileData => _profileData;

  PackageInfo? _packageInfo;
  PackageInfo? get packageInfo => _packageInfo;

  int _approvalNumbers = 0;
  int get approvalNumbers => _approvalNumbers;

  @override
  Future<void> initModel() async {
    setBusy(true);
    _profileData = await _sharedPreferencesService.get(
      SharedPrefKeys.profileData,
    );
    _approvalNumbers = await _sharedPreferencesService.get(
      SharedPrefKeys.approvalNotificationBatchNumber,
    );
    await _getPackageInfo;
    setBusy(false);
  }

  List<HomeItemModel> getUserMenu() {
    return homeMenu
        .where(
          (element) => element.role.contains(
            _profileData?.role ?? Role.Admin,
          ),
        )
        .toList();
  }

  Future<void> logout() async {
    await _authenticationService.logout();
  }

  Future<void> getApprovalNotificationBatchNumber() async {
    final response =
        await _apiService.requestGetApprovaNotificationBatchlNumber();

    if (response.isRight) {
      _approvalNumbers = response.right.totalData;
      await _sharedPreferencesService.set(
        SharedPrefKeys.approvalNotificationBatchNumber,
        response.right.totalData,
      );
      notifyListeners();
    }
  }

  Future<void> _getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }
}
