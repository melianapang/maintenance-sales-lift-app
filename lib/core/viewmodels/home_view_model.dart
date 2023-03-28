import 'package:rejo_jaya_sakti_apps/core/models/home_item_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/profile/profile_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/shared_preferences_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel({
    required AuthenticationService authenticationService,
    required SharedPreferencesService sharedPreferencesService,
  })  : _authenticationService = authenticationService,
        _sharedPreferencesService = sharedPreferencesService;

  final AuthenticationService _authenticationService;
  final SharedPreferencesService _sharedPreferencesService;

  late ProfileData _profileData;
  ProfileData get profileData => _profileData;

  @override
  Future<void> initModel() async {
    setBusy(true);
    _profileData = await _sharedPreferencesService.get(
      SharedPrefKeys.profileData,
    );
    setBusy(false);
  }

  List<HomeItemModel> getUserMenu() {
    return homeMenu
        .where(
          (element) => element.role.contains(
            _profileData.role,
          ),
        )
        .toList();
  }

  Future<void> logout() async {
    await _authenticationService.logout();
  }
}
