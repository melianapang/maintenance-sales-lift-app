import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/models/profile_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/models/role_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/home_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/login_view.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/splash_screen_view.dart';

final RouteObserver<PageRoute<dynamic>> routeObserver =
    RouteObserver<PageRoute<dynamic>>();

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    MaterialPageRoute<T>? buildRoute<T>({
      required Widget Function(BuildContext) builder,
      bool fullscreenDialog = false,
    }) {
      return MaterialPageRoute<T>(
        settings: settings,
        builder: builder,
        fullscreenDialog: fullscreenDialog,
      );
    }

    switch (settings.name) {
      case Routes.splashScreen:
        return buildRoute(
          builder: (_) => const SplashScreenView(),
        );
      case Routes.login:
        return buildRoute(
          builder: (_) => const LoginView(),
        );
      case Routes.home:
        final ProfileData param = settings.arguments is ProfileData
            ? settings.arguments as ProfileData
            : ProfileData(
                username: '',
                firstName: '',
                lastName: '',
                notelp: '',
                email: '',
                address: '',
                city: '',
                role: Role.Admin,
              );
        return buildRoute(
          builder: (_) => HomeView(
            profileData: param,
          ),
        );
    }
  }
}
