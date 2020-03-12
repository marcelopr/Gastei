import 'package:carteira/constants/constants.dart';
import 'package:carteira/ui/widgets/signup_form.dart';
import 'package:carteira/ui/widgets/singin_form.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignInScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _showSpinner = false;

  _spinner(bool show) {
    setState(() {
      _showSpinner = show;
    });
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

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    var screenHeigth = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            body: Column(
              children: <Widget>[
                Container(
                  height: screenHeigth / 2.8,
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/assets/images/icon_wallet.png',
                          width: 40.0,
                          height: 40.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Gastei',
                          style: theme.textTheme.title,
                        ),
                      ],
                    ),
                  ),
                ),
                PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TabBar(
                      indicatorColor: theme.colorScheme.primary,
                      unselectedLabelColor: theme.textTheme.body2.color,
                      labelColor: theme.textTheme.body1.color,
                      labelStyle: theme.textTheme.subtitle,
                      indicatorWeight: 4.0,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: <Widget>[
                        Tab(child: Text('Entrar')),
                        Tab(child: Text('Criar Conta')),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      SignInForm(
                          showSpinner: _spinner, showMessage: _showMessage),
                      SignUpForm(
                          showSpinner: _spinner, showMessage: _showMessage),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
