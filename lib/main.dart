import 'package:carteira/models/user.dart';
import 'package:carteira/state/theme_state.dart';
import 'package:carteira/ui/screens/landing_screen.dart';
import 'package:carteira/ui/theme/app_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carteira/routes/router.dart' as router;

void main() {
  ///Setando orientação em portrait para o app
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(MultiProvider(providers: [
        Provider<User>(create: (context) => User()),
        ChangeNotifierProvider<ThemeState>(create: (context) => ThemeState())
      ], child: MyApp())
          /*ChangeNotifierProvider<ThemeState>(
          create: (context) => ThemeState(),
          child: MyApp(),
        ),*/
          );
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeState>(
      builder: (context, themeState, child) {
        return MaterialApp(
          title: 'Gastei',
          debugShowCheckedModeBanner: false,
          //Talvez desativar o theme
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeState.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
          home: LandingScreen(),
          onGenerateRoute: router.generateRoute,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'), // English
            const Locale('pt'), // Portuguese
          ],
        );
      },
    );
  }
}
