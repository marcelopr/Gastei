import 'package:carteira/models/user.dart';
import 'package:carteira/services/firestore.dart';
import 'package:carteira/ui/widgets/activity_menu.dart';
import 'package:carteira/ui/widgets/loading_indicator.dart';
import 'package:carteira/ui/widgets/main_balance.dart';
import 'package:carteira/ui/widgets/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserData userData;

  @override
  void initState() {
    String uid = Provider.of<User>(context, listen: false).uid;
    userData = Provider.of<UserData>(context, listen: false);
    userData.setUid = uid;
    _listenToUser();
    super.initState();
  }

  _listenToUser() {
    print("Started listen to user UID: ${userData.uid}");
    FirestoreService(uid: userData.uid).userData.listen((snapshot) {
      userData.fromSnapshot(snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD HOME");
    return Scaffold(
      ///resize.. Evita que o RenderFlex Overflow quando o teclado aparece nos dialogs
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 4,
            child: MainBalance(),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 8,
            child: ActivityMenu(),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 4,
            child: MainMenu(),
          ),
        ],
      ),
    );
  }
}
