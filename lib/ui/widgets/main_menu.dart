import 'package:carteira/constants/constants.dart';
import 'package:carteira/models/user.dart';
import 'package:carteira/routes/routing_constants.dart';
import 'package:carteira/services/auth.dart';
import 'package:carteira/services/firestore.dart';
import 'package:carteira/ui/dialogs/edit_balance_dialog.dart';
import 'package:carteira/ui/dialogs/reauth_dialog.dart';
import 'package:carteira/ui/widgets/main_menu_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<User>(context, listen: false).uid;
    UserData userData = Provider.of<UserData>(context, listen: true);

    print('BUILD MAIN MENU WIDGET');
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            MainMenuButton(
                icon: Icons.edit,
                title: 'Editar Saldo',
                onPressed: () {
                  _reAuthenticate(
                      context, DialogType.editBalance, uid, userData);
                }),
            MainMenuButton(
                icon: Icons.visibility,
                title: 'Visibilidade do Saldo',
                onPressed: () {
                  _reAuthenticate(
                      context, DialogType.balanceVisibility, uid, userData);
                }),
            MainMenuButton(
              icon: Icons.person,
              title: 'Configurações da Conta',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AccountRoute,
                  arguments: userData.name,
                );
              },
            ),
            MainMenuButton(
              icon: Icons.exit_to_app,
              title: 'Sair',
              onPressed: () async {
                dynamic result = await AuthService().signOut();
                if (result is String) {
                  _showMessage(result);
                } else {
                  Navigator.pushReplacementNamed(context, SignInRoute);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _showMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        //backgroundColor: kToastBackgroundColor,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  _reAuthenticate(BuildContext context, DialogType action, String uid,
      UserData userData) async {
    FirebaseUser user = await AuthService().firebaseUser;

    final result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ReAuthDialog(user: user, action: action);
      },
    );

    if (result == true && action == DialogType.balanceVisibility) {
      FirestoreService(uid: uid)
          .updateBalanceVisibility(balanceVisible: !userData.balanceVisible);
    } else if (result == true && action == DialogType.editBalance) {
      _showEditBalanceDialog(context, userData);
    }
  }

  _showEditBalanceDialog(BuildContext context, UserData userData) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditBalanceDialog(
          userData: userData,
        );
      },
    );
  }
}
