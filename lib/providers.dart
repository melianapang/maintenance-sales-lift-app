import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rejo_jaya_sakti_apps/core/services/alice_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/authentication_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/download_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/gcloud_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/global_config_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/local_notification_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/notification_handler_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/onesignal_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/remote_config_service.dart';
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
  Provider<GlobalConfigService>(
    create: (_) => GlobalConfigService(),
  ),
  Provider<GCloudService>(
    create: (_) => GCloudService(),
  ),
  Provider<RemoteConfigService>(
    create: (_) => RemoteConfigService(),
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
  ProxyProvider<NavigationService, OneSignalService>(
    update: (
      _,
      NavigationService navigationService,
      OneSignalService? oneSignalService,
    ) =>
        oneSignalService ??
        OneSignalService(
          navigationService: navigationService,
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
  ProxyProvider<AuthenticationService, DownloadService>(
    update: (
      _,
      AuthenticationService authenticationService,
      DownloadService? downloadService,
    ) =>
        downloadService ??
        DownloadService(
          authenticationService: authenticationService,
        ),
  ),
  ProxyProvider3<AuthenticationService, AliceService, GlobalConfigService,
      DioService>(
    update: (
      _,
      AuthenticationService authService,
      AliceService aliceService,
      GlobalConfigService globalConfigService,
      DioService? dioService,
    ) =>
        dioService ??
        DioService(
          aliceCore: aliceService.aliceCore,
          authenticationService: authService,
          globalConfigService: globalConfigService,
        ),
  ),
  ProxyProvider2<NavigationService, AuthenticationService,
      NotificationHandlerService>(
    update: (
      _,
      NavigationService navigationService,
      AuthenticationService authenticationService,
      NotificationHandlerService? notificationHandlerService,
    ) =>
        notificationHandlerService ??
        NotificationHandlerService(
          navigationService: navigationService,
          //authenticationService: authenticationService,
        ),
  ),
  ProxyProvider<NotificationHandlerService, LocalNotificationService>(
    update: (
      _,
      NotificationHandlerService notificationHandlerService,
      LocalNotificationService? localNotificationService,
    ) =>
        localNotificationService ??
        LocalNotificationService(
          notificationHandlerService.handleOnTapLocalNotification,
        ),
  ),
];
