import 'package:carteira/models/user.dart';
import 'package:carteira/ui/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:carteira/ui/screens/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return SignInScreen();
    } else {
      return ChangeNotifierProvider<UserData>(
        create: (_) => UserData(),
        child: Home(),
      );
    }
  }
}
