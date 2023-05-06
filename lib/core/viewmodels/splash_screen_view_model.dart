import 'package:permission_handler/permission_handler.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/gcloud_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/onesignal_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/remote_config_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/permission_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class SplashScreenViewModel extends BaseViewModel {
  SplashScreenViewModel({
    required AuthenticationService apisService,
    required OneSignalService oneSignalService,
    required GCloudService gCloudService,
    required RemoteConfigService remoteConfigService,
  })  : _apisService = apisService,
        _oneSignalService = oneSignalService,
        _gCloudService = gCloudService,
        _remoteConfigService = remoteConfigService;

  final AuthenticationService _apisService;
  final OneSignalService _oneSignalService;
  final GCloudService _gCloudService;
  final RemoteConfigService _remoteConfigService;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await _oneSignalService.initOneSignal();
    await _gCloudService.initialize();
    await _remoteConfigService.initialize();
    setBusy(false);

    await PermissionUtils.requestPermissions(listPermission: [
      Permission.notification,
      Permission.storage,
      Permission.photos,
      Permission.videos,
    ]);
  }

  Future<bool> isLoggedIn() async {
    return await _apisService.isLoggedIn();
  }
}
