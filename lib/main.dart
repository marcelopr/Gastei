import 'package:carteira/models/user.dart';
import 'package:carteira/services/auth.dart';
import 'package:carteira/ui/screens/wrapper.dart';
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
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Gastei',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        home: Wrapper(),
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
      ),
    );
  }
}
