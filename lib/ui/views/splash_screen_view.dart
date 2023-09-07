import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/gcloud_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/local_notification_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/onesignal_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/remote_config_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/shared_preferences_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/splash_screen_view_model.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();

    // Timer(
    //   const Duration(seconds: 5),
    //   () => Navigator.popAndPushNamed(
    //     context,
    //     Routes.login,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel(
      model: SplashScreenViewModel(
        dioService: Provider.of<DioService>(context),
        navigationService: Provider.of<NavigationService>(context),
        authenticationService: Provider.of<AuthenticationService>(context),
        sharedPreferencesService:
            Provider.of<SharedPreferencesService>(context),
        localNotificationService:
            Provider.of<LocalNotificationService>(context),
        oneSignalService: Provider.of<OneSignalService>(context),
        gCloudService: Provider.of<GCloudService>(context),
        remoteConfigService: Provider.of<RemoteConfigService>(context),
      ),
      onModelReady: (SplashScreenViewModel model) async {
        model.initModel();
        final bool isLoggedIn = await model.isLoggedIn();

        Future.delayed(
            const Duration(
              seconds: 2,
            ), () {
          if (kReleaseMode) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              isLoggedIn ? Routes.home : Routes.login,
              (route) => false,
            );

            return;
          }
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.customBaseURL,
            (route) => false,
          );
        });
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: MyColors.darkBlack01,
          body: Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage(
                    'assets/images/logo_pt_rejo.png',
                  ),
                  width: 200,
                  height: 200,
                ),
                Spacings.vert(18),
                Text(
                  "PT REJO JAYA SAKTI",
                  style: buildTextStyle(
                    fontSize: 24,
                    fontWeight: 800,
                    fontColor: MyColors.lightBlack02,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
