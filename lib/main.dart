import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/theme.dart';
import 'app/routes.dart';
import 'core/locale/app_locale.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appLocale.load();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const CabaDzApp());
}

class CabaDzApp extends StatelessWidget {
  const CabaDzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appLocale,
      builder: (context, _) {
        return MaterialApp(
          title: 'CabaDZ',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          locale: appLocale.locale,
          supportedLocales: const [
            Locale('ar', 'DZ'),
            Locale('fr', 'FR'),
            Locale('en', 'US'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return Directionality(
              textDirection: appLocale.textDirection,
              child: child!,
            );
          },
          navigatorObservers: [appRouteObserver],
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}
