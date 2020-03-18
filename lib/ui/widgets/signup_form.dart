import 'package:carteira/constants/constants.dart';
import 'package:carteira/models/user.dart';
import 'package:carteira/routes/routing_constants.dart';
import 'package:carteira/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  final Function showSpinner;
  final Function showMessage;

  const SignUpForm({Key key, this.showSpinner, this.showMessage})
      : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  Function _showSpinner, _showMessage;
  AuthService _authService = AuthService();
  final FocusNode _password1FocusNode = FocusNode();
  final FocusNode _password2FocusNode = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();
  String _emailError;
  String _passwordError;
  String _password2Error;
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '', _password2 = '';

  @override
  void initState() {
    _showSpinner = widget.showSpinner;
    _showMessage = widget.showMessage;
    super.initState();
  }

  @override
  void dispose() {
    _password1FocusNode.dispose();
    _password2FocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
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
              children: <Widget>[
                SizedBox(
                  height: 48.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(100),
                  ],
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: 'Digite seu email',
                      hintStyle: theme.textTheme.body2,
                      errorText: _emailError ?? _emailError),
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_password1FocusNode);
                  },
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
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: _passwordController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(60),
                  ],
                  maxLines: 1,
                  obscureText: true, //password mode
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.next,
                  focusNode: _password1FocusNode,
                  decoration: InputDecoration(
                      hintText: 'Digite sua senha',
                      hintStyle: theme.textTheme.body2,
                      errorText: _passwordError ?? _passwordError),
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_password2FocusNode),
                  validator: (input) {
                    input.trim();
                    if (input.isEmpty) {
                      return 'Informe sua senha';
                    }
                    if (input.length < 6) {
                      return 'A senha deve ter no mínimo 6 caracteres';
                    }
                    setState(() => _password = input);
                  },
                  onSaved: (value) {
                    setState(() => _password = value.trim());
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: _password2Controller,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(60),
                  ],
                  maxLines: 1,
                  obscureText: true, //password mode
                  textAlign: TextAlign.center,
                  focusNode: _password2FocusNode,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      hintText: 'Repita sua senha',
                      hintStyle: theme.textTheme.body2,
                      errorText: _password2Error ?? _password2Error),
                  validator: (input) {
                    if (input.trim().isEmpty) {
                      return 'Repita sua senha';
                    }
                    if (input.trim().length < 6) {
                      return 'A senha deve ter no mínimo 6 caracteres';
                    }
                    if (input.trim() != _password) {
                      return 'As senhas não são iguais';
                    }
                  },
                  onSaved: (value) {
                    setState(() => _password2 = value.trim());
                  },
                ),
                SizedBox(
                  height: 24.0,
                ),
                ButtonTheme(
                  minWidth: double.infinity,
                  height: 50,
                  child: FlatButton(
                    color: kBlue,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            new BorderRadius.circular(kButtonBorderRadius)),
                    child: Text('Criar Conta',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _showSpinner(true);
                        dynamic result = await _authService
                            .registerWithEmailAndPassword(_email, _password);
                        _showSpinner(false);
                        if (result is String) {
                          if (result is String) _showMessage(result);
                        } else {
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
