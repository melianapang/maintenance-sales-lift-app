import 'package:permission_handler/permission_handler.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/onesignal_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/permission_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class SplashScreenViewModel extends BaseViewModel {
  SplashScreenViewModel({
    required AuthenticationService apisService,
    required OneSignalService oneSignalService,
  })  : _apisService = apisService,
        _oneSignalService = oneSignalService;

  final AuthenticationService _apisService;
  final OneSignalService _oneSignalService;

  @override
  void initModel() async {
    setBusy(true);
    await _oneSignalService.initOneSignal();
    setBusy(false);

    await PermissionUtils.requestPermission(
      Permission.notification,
    );

    await PermissionUtils.requestPermissions(listPermission: [
      Permission.manageExternalStorage,
      Permission.storage,
      Permission.photos,
      Permission.videos,
    ]);
  }

  Future<bool> isLoggedIn() async {
    return await _apisService.isLoggedIn();
  }
}
