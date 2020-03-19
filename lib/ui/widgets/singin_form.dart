import 'package:carteira/constants/constants.dart';
import 'package:carteira/models/user.dart';
import 'package:carteira/routes/routing_constants.dart';
import 'package:carteira/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInForm extends StatefulWidget {
  final Function showSpinner;
  final Function showMessage;

  const SignInForm({Key key, this.showSpinner, this.showMessage})
      : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  Function _showSpinner, _showMessage;
  AuthService _authService = AuthService();
  final FocusNode _passwordNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _emailError;
  String _email = '', _password = '';

  @override
  void initState() {
    _showSpinner = widget.showSpinner;
    _showMessage = widget.showMessage;
    super.initState();
  }

  @override
  void dispose() {
    _passwordNode.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Builder(
          builder: (context) => Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(height: 48.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_passwordNode),
                  decoration: InputDecoration(
                      errorText: _emailError,
                      hintText: 'Informe seu email',
                      hintStyle: theme.textTheme.body2),
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
                  decoration: InputDecoration(
                      hintText: 'Informe sua senha',
                      hintStyle: theme.textTheme.body2),
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
                ButtonTheme(
                  minWidth: double.infinity,
                  height: 50,
                  child: FlatButton(
                    color: kBlue,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            new BorderRadius.circular(kButtonBorderRadius)),
                    child: Text('Entrar',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _showSpinner(true);
                        final result = await _authService
                            .signInWithEmailAndPassword(_email, _password);
                        _showSpinner(false);

                        if (result is String) {
                          _showMessage(result);
                        } else if (result != null) {
                          FirebaseUser firebaseUser = result;
                          Provider.of<User>(context, listen: false).userUid =
                              firebaseUser.uid;
                          print(firebaseUser.uid);
                          Navigator.pushReplacementNamed(context, HomeRoute);
                        }
                      }
                    },
                  ),
                ),
                SizedBox(height: 12.0),
                FlatButton(
                  child: Text('Esqueceu sua senha?',
                      textAlign: TextAlign.end,
                      style: theme.textTheme.subtitle),
                  onPressed: () async {
                    var email = _emailController.text.trim();

                    if (email.isEmpty) {
                      setState(() => _emailError = 'Informe seu email');
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(email)) {
                      setState(() => _emailError = 'Informe um email válido');
                    } else {
                      setState(() => _emailError = null);

                      final result =
                          await _authService.sendResetPasswordEmail(email);
                      if (result is String) {
                        _showMessage(result);
                      } else {
                        _showMessage(
                            'Verifique seu email para recuperar sua senha');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
