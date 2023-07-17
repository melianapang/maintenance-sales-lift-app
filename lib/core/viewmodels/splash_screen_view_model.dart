import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/gcloud_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/onesignal_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/remote_config_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/shared_preferences_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/app_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/permission_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/update_apk/update_apk_view.dart';

class SplashScreenViewModel extends BaseViewModel {
  SplashScreenViewModel({
    required DioService dioService,
    required NavigationService navigationService,
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
        _navigationService = navigationService,
        _authenticationService = authenticationService,
        _sharedPreferencesService = sharedPreferencesService,
        _oneSignalService = oneSignalService,
        _gCloudService = gCloudService,
        _remoteConfigService = remoteConfigService;

  final ApiService _apiService;
  final NavigationService _navigationService;
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

    await checkAppVersion();
    await _getApprovalNotificationBatchNumber();
    setBusy(false);

    await PermissionUtils.requestPermissions(listPermission: [
      Permission.notification,
      Permission.storage,
      Permission.photos,
      Permission.videos,
    ]);
  }

  Future<void> checkAppVersion() async {
    String minVersion = _remoteConfigService.appMinVersion ?? "";

    bool isUpdateRequied = await AppUtils.hasToUpdateApp(
      requiredVersion: minVersion,
    );

    if (!isUpdateRequied) return;

    final packageInfo = await PackageInfo.fromPlatform();
    _navigationService.popAllAndNavigateTo(
      Routes.updateApk,
      arguments: UpdateApkViewParam(
        minVersion: minVersion,
        currentVersion: packageInfo.version,
      ),
    );
  }

  Future<bool> isLoggedIn() async {
    return await _authenticationService.isLoggedIn();
  }

  Future<void> _getApprovalNotificationBatchNumber() async {
    if (!await isLoggedIn()) return;

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
