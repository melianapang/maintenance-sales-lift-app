import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/global_config_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class CustomBaseURLViewModel extends BaseViewModel {
  CustomBaseURLViewModel({
    required AuthenticationService apisService,
    required GlobalConfigService globalConfigService,
  })  : _apisService = apisService,
        _globalConfigService = globalConfigService;

  final AuthenticationService _apisService;
  final GlobalConfigService _globalConfigService;

  set baseURL(String? baseURL) => _globalConfigService.setCustomBaseURL(
        baseURL,
      );

  final TextEditingController customBaseURLController = TextEditingController();

  Future<bool> isLoggedIn() async {
    return await _apisService.isLoggedIn();
  }
}
