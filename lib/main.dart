import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/routes.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';
import 'package:rejo_jaya_sakti_apps/providers.dart';
import 'package:rejo_jaya_sakti_apps/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: 'assets/config/base.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'PT REJO JAYA SAKTI',
            theme: getThemeData(),
            builder: BotToastInit(),
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: const [
              Locale('id', ''),
            ],
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: Routes.splashScreen,
            navigatorKey: Provider.of<NavigationService>(context).navigatorKey,
            navigatorObservers: <NavigatorObserver>[
              routeObserver,
              BotToastNavigatorObserver()
            ],
          );
        },
      ),
    );
  }
}

ThemeData getThemeData() {
  return ThemeData(
    scaffoldBackgroundColor: MyColors.darkBlack01,
  );
}
