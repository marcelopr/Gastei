import 'package:carteira/models/user.dart';
import 'package:carteira/routes/routing_constants.dart';
import 'package:carteira/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    _verifyLoggedUser();
    super.initState();
  }

  void _verifyLoggedUser() async {
    final user = await AuthService().firebaseUser;
    //await Future.delayed(const Duration(milliseconds: 2500));
    if (user != null) {
      Provider.of<User>(context, listen: false).userUid = user.uid;
      Navigator.pushReplacementNamed(context, HomeRoute);
    } else {
      Navigator.pushReplacementNamed(context, SignInRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/launcher/launcher_icon_transparent.png',
                width: 40.0,
                height: 40.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
