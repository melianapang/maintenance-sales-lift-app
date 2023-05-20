import 'package:permission_handler/permission_handler.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/gcloud_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/onesignal_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/remote_config_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/shared_preferences_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/permission_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class SplashScreenViewModel extends BaseViewModel {
  SplashScreenViewModel({
    required DioService dioService,
    required AuthenticationService authenticationService,
    required SharedPreferencesService sharedPreferencesService,
    required OneSignalService oneSignalService,
    required GCloudService gCloudService,
    required RemoteConfigService remoteConfigService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _authenticationService = authenticationService,
        _sharedPreferencesService = sharedPreferencesService,
        _oneSignalService = oneSignalService,
        _gCloudService = gCloudService,
        _remoteConfigService = remoteConfigService;

  final ApiService _apiService;
  final AuthenticationService _authenticationService;
  final SharedPreferencesService _sharedPreferencesService;
  final OneSignalService _oneSignalService;
  final GCloudService _gCloudService;
  final RemoteConfigService _remoteConfigService;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await _oneSignalService.initOneSignal();
    await _gCloudService.initialize();
    await _remoteConfigService.initialize();

    await _getApprovalNotificationBatchNumber();
    setBusy(false);

    await PermissionUtils.requestPermissions(listPermission: [
      Permission.notification,
      Permission.storage,
      Permission.photos,
      Permission.videos,
    ]);
  }

  Future<bool> isLoggedIn() async {
    return await _authenticationService.isLoggedIn();
  }

  Future<void> _getApprovalNotificationBatchNumber() async {
    final response =
        await _apiService.requestGetApprovaNotificationBatchlNumber();

    if (response.isRight) {
      await _sharedPreferencesService.set(
        SharedPrefKeys.approvalNotificationBatchNumber,
        response.right.totalData,
      );
    }
  }
}
