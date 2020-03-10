import 'package:carteira/routes/routing_constants.dart';
import 'package:carteira/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carteira/constants/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignIn extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthService _authService = AuthService();
  bool _showSpinner = false;
  final FocusNode _passwordNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _emailError;
  String _email = '', _password = '';

  @override
  void dispose() {
    _passwordNode.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  _spinner(bool show) {
    setState(() {
      _showSpinner = show;
    });
  }

  void _showMessage(String warningMessage) {
    Fluttertoast.showToast(
        msg: warningMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        //backgroundColor: kToastBackgroundColor,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            height: MediaQuery.of(context).size.height,
            child: Builder(
              builder: (context) => Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /* Hero(
                      tag: 'logo',
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 48.0,
                        child: Image.asset(
                          'lib/assets/img_empty_wallet.png',
                          color: Colors.black38,
                        ),
                      ),
                    ),*/
                    SizedBox(height: 48.0),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_passwordNode),
                      decoration: kLoginTextFieldDecoration.copyWith(
                          hintText: 'Informe seu email'),
                      validator: (input) {
                        input.trim();
                        if (input.isEmpty) {
                          return 'Informe seu email';
                        }
                        if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(input)) {
                          return 'Informe um email válido';
                        }
                      },
                      onSaved: (value) {
                        setState(() => _email = value.trim());
                      },
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      focusNode: _passwordNode,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) {},
                      decoration: kLoginTextFieldDecoration.copyWith(
                          hintText: 'Informe sua senha'),
                      validator: (input) {
                        input.trim();
                        if (input.isEmpty) {
                          return 'Informe sua senha';
                        }
                      },
                      onSaved: (value) {
                        setState(() => _password = value.trim());
                      },
                    ),
                    SizedBox(height: 24.0),
                    FlatButton(
                      child: Text('Entrar'),
                      color: Colors.black12,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _spinner(true);

                          dynamic result = await _authService
                              .signInWithEmailAndPassword(_email, _password);

                          if (result is String) {
                            _spinner(false);
                            _showMessage(result);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text('Criar conta', style: kBottomSheetText),
              onPressed: () {
                Navigator.pushNamed(context, RegistrationRoute);
              },
            ),
            SizedBox(width: 24),
            FlatButton(
              child: Text('Esqueceu sua senha?', style: kBottomSheetText),
              onPressed: () async {
                var email = _emailController.text.trim();
                if (email.isEmpty) {
                  _showMessage('Informe seu email');
                  return;
                }
                if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(email)) {
                  _showMessage('O email informado é inválido');
                  return;
                }
                _spinner(true);
                var result = await _authService.sendResetPasswordEmail(email);
                if (result is String) {
                  _spinner(false);
                  _showMessage(result);
                } else {
                  _spinner(false);
                  _showMessage('Verifique seu email para modificar sua senha');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
