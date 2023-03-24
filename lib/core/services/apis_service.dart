import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';

class ApisService {
  ApisService({
    // add sharedprefservice dependency
    required NavigationService navigationService,
  }) : _navigationService = navigationService;

  final NavigationService _navigationService;

  Future<bool> isLoggedIn() async {
    // get token from sharedpref, if token is not null, return true
    return true;
  }

  Future<void> logout() async {
    try {
      // clear sharedpref before navigating to login page
      _navigationService.popAllAndNavigateTo(Routes.login);
    } catch (e) {}
  }

  Future<String?> getAccountId() async {
    // get userID / userGUID from sharedpref
    return '';
  }

  Future<String?> getJwtToken() async {
    // get token from sharedpref
    final String? token = 'use_shared_pref';
    // Below this is optional, check with backend how does token validity work.

    if (token != null) {
      // if token is not null, check if token is VALID. if it is valid, return the token.
      // if token is not valid call logout() and return null
      return token;
    }

    await logout();
    return null;
  }
}
