import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rejo_jaya_sakti_apps/core/services/alice_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/onesignal_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/shared_preferences_service.dart';

List<SingleChildWidget> providers = [
  ...independentProviders,
  ...dependentProviders,
];

List<SingleChildWidget> independentProviders = [
  Provider<NavigationService>(
    create: (_) => NavigationService(),
  ),
  Provider<SharedPreferencesService>(
    create: (_) => SharedPreferencesService(),
  ),
  Provider<OneSignalService>(
    create: (_) => OneSignalService(),
  ),
];

List<SingleChildWidget> dependentProviders = [
  ProxyProvider<NavigationService, AliceService>(
    update: (
      _,
      NavigationService navigationService,
      AliceService? aliceService,
    ) =>
        aliceService ??
        AliceService(
          navigationService.navigatorKey,
        ),
  ),
  ProxyProvider2<NavigationService, SharedPreferencesService,
      AuthenticationService>(
    update: (
      _,
      NavigationService navigationService,
      SharedPreferencesService sharedPreferencesService,
      AuthenticationService? authService,
    ) =>
        authService ??
        AuthenticationService(
          navigationService: navigationService,
          sharedPreferencesService: sharedPreferencesService,
        ),
  ),
  ProxyProvider2<AuthenticationService, AliceService, DioService>(
    update: (
      _,
      AuthenticationService authService,
      AliceService aliceService,
      DioService? dioService,
    ) =>
        dioService ??
        DioService(
          aliceCore: aliceService.aliceCore,
          authenticationService: authService,
        ),
  ),
];
