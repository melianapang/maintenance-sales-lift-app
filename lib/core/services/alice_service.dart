import 'package:alice_lightweight/core/alice_core.dart';
import 'package:alice_lightweight/ui/page/alice_calls_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/env.dart';
import 'package:shake/shake.dart';

class AliceService {
  AliceService(GlobalKey<NavigatorState> navigatorKey) {
    bool enableAlice = false;

    switch (EnvConstants.env) {
      case EnvironmentEnum.dev:
      case EnvironmentEnum.staging:
        enableAlice = true;
        break;
      case EnvironmentEnum.production:
        enableAlice = false;
        break;
      default:
    }

    _aliceCore = AliceCore(
      navigatorKey,
      false,
    );

    if (enableAlice) {
      ShakeDetector.autoStart(
        onPhoneShake: navigateToCallListScreen,
        shakeThresholdGravity: 5,
      );
    }
  }
  late AliceCore _aliceCore;
  AliceCore get aliceCore => _aliceCore;

  bool _isInspectorOpened = false;

  void navigateToCallListScreen() {
    final BuildContext? context = _aliceCore.getContext();
    if (context != null && !_isInspectorOpened) {
      _isInspectorOpened = true;
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => AliceCallsListScreen(_aliceCore),
        ),
      ).then((_) => _isInspectorOpened = false);
    }
  }
}
