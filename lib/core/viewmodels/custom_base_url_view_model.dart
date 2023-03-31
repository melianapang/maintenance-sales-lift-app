import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/services/global_config_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class CustomBaseURLViewModel extends BaseViewModel {
  CustomBaseURLViewModel({
    required GlobalConfigService globalConfigService,
  }) : _globalConfigService = globalConfigService;

  final GlobalConfigService _globalConfigService;

  set baseURL(String? baseURL) => _globalConfigService.setCustomBaseURL(
        baseURL,
      );

  final TextEditingController customBaseURLController = TextEditingController();
}
