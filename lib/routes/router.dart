import 'package:carteira/models/user.dart';
import 'package:carteira/routes/routing_constants.dart';
import 'package:carteira/ui/screens/account_screen.dart';
import 'package:carteira/ui/screens/home.dart';
import 'package:carteira/ui/screens/monthy_balance_details_screen.dart';
import 'package:carteira/ui/screens/monthly_balance_screen.dart';
import 'package:carteira/ui/screens/post_screen2.dart';
import 'package:carteira/ui/screens/registers_screen.dart';
import 'package:carteira/ui/screens/signin%20copy.dart';
import 'package:carteira/ui/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  Widget _transitionBuilder(Animation animation, Widget child) {
    var begin = Offset(0.0, 1.0);
    var end = Offset.zero;
    var curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  switch (settings.name) {
    case LoginRoute:
      return MaterialPageRoute(builder: (context) => SignInScreen());

    case RegistrationRoute:
      return MaterialPageRoute(builder: (context) => SignUp());

    case HomeRoute:
      return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<UserData>(
          create: (_) => UserData(),
          child: Home(),
        ),
      );

    case PostRoute:
      var arguments = settings.arguments;
      return PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, __, ___) {
          return PostScreen2(arguments: arguments);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _transitionBuilder(animation, child);
        },
      );

    case MonthlyBalanceRoute:
      return PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, __, ___) {
          return MBScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _transitionBuilder(animation, child);
        },
      );

    case MonthlyBalanceDetaisRoute:
      var arguments = settings.arguments;
      return PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, __, ___) {
          return MonthlyBalanceDetails(mb: arguments);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _transitionBuilder(animation, child);
        },
      );

    case RegistersRoute:
      var arguments = settings.arguments;
      return PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, __, ___) {
          return RegistersScreen(arguments: arguments);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _transitionBuilder(animation, child);
        },
      );

    case AccountRoute:
      var arguments = settings.arguments;
      return PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, __, ___) {
          return AccountScreen(name: arguments);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _transitionBuilder(animation, child);
        },
      );
  }
}
