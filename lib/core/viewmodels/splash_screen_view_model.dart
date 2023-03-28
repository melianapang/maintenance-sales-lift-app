import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/onesignal_service.dart';
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
  }

  Future<bool> isLoggedIn() async {
    return await _apisService.isLoggedIn();
  }
}
