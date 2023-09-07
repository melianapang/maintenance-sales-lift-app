import 'dart:async';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/profile/profile_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role/role_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/shared_preferences_service.dart';

class AuthenticationService {
  AuthenticationService({
    // add sharedprefservice dependency
    required NavigationService navigationService,
    required SharedPreferencesService sharedPreferencesService,
  })  : _navigationService = navigationService,
        _sharedPreferencesService = sharedPreferencesService;

  final NavigationService _navigationService;
  final SharedPreferencesService _sharedPreferencesService;

  Future<bool> isLoggedIn() async {
    // get token from sharedpref, if token is not null, return true
    String? token = await getJwtToken();
    print("token: $token");

    if (token != null) {
      bool isExpired = Jwt.isExpired(token);
      print("isExpired: $isExpired");

      if (!isExpired) {
        return true;
      }
    }

    return false;
  }

  Future<void> setLogin(String jwtToken) async {
    try {
      await _sharedPreferencesService.set(
          SharedPrefKeys.authenticationToken, jwtToken);

      Map<String, dynamic> payload = Jwt.parseJwt(jwtToken);
      print("payload: $payload");
      ProfileData profileData = ProfileData(
        username: payload['username'],
        name: payload['name'],
        city: payload['city'],
        address: payload['address'],
        phoneNumber: payload['phone_number'],
        email: payload['email'],
        role: mappingStringNumberToRole(
          payload['id_role'],
        ),
      );

      await _sharedPreferencesService.set(
        SharedPrefKeys.userId,
        payload["user_id"],
      );

      await _sharedPreferencesService.set(
        SharedPrefKeys.profileData,
        profileData,
      );

      // DateTime? expiryDate = Jwt.getExpiryDate(jwtToken);
      // print("email: ${expiryDate}");
    } catch (e) {}
  }

  Future<void> logout() async {
    try {
      // clear sharedpref before navigating to login page
      await _sharedPreferencesService.clearStorage();
      _navigationService.popAllAndNavigateTo(Routes.login);
    } catch (e) {}
  }

  Future<String> getUserId() async {
    // get userID / userGUID from sharedpref
    return await _sharedPreferencesService.get(
      SharedPrefKeys.userId,
    );
  }

  Future<Role> getUserRole() async {
    ProfileData profileData = await _sharedPreferencesService.get(
      SharedPrefKeys.profileData,
    );
    return profileData.role;
  }

  Future<String?> getJwtToken() async {
    // get token from sharedpref
    final String? token =
        await _sharedPreferencesService.get(SharedPrefKeys.authenticationToken);

    if (token != null) {
      // if token is not null, check if token is VALID. if it is valid, return the token.
      // if token is not valid call logout() and return null
      return token;
    }
    return null;
  }
}
