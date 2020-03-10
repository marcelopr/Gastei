import 'package:carteira/constants/constants.dart';
import 'package:carteira/services/auth.dart';
import 'package:flutter/material.dart';

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
                SizedBox(height: 12.0),
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

                        dynamic result = await _authService
                            .signInWithEmailAndPassword(_email, _password);

                        if (result is String) {
                          _showSpinner(false);
                          _showMessage(result);
                        }
                      }
                    },
                  ),
                ),
                SizedBox(height: 12.0),
                FlatButton(
                  child: Text('Esqueceu sua senha?',
                      textAlign: TextAlign.end,
                      style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    var email = _emailController.text.trim();
                    if (email.isEmpty) {
                      setState(() {
                        email = 'Informe seu email';
                      });
                      return;
                    }
                    if (email != null) {
                      email = null;
                    }
                    // _authService.sendResetPasswordEmail(email);
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
