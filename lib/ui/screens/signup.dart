import 'package:carteira/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:carteira/constants/constants.dart';

class SignUp extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _authService = AuthService();
  bool _showSpinner = false;

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
  void dispose() {
    _password1FocusNode.dispose();
    _password2FocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
    super.dispose();
  }

  _spinner(bool show) {
    setState(() {
      _showSpinner = show;
    });
  }

  _showMessage(String warningMessage) {
    Fluttertoast.showToast(
        msg: warningMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        //backgroundColor: kToastBackgroundColor,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Criar conta',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Builder(
              builder: (context) => Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    /*Hero(
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
                      decoration: kLoginTextFieldDecoration.copyWith(
                          hintText: 'Digite seu email',
                          errorText: _emailError ?? _emailError),
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_password1FocusNode);
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
                      decoration: kLoginTextFieldDecoration.copyWith(
                          hintText: 'Digite sua senha',
                          errorText: _passwordError ?? _passwordError),
                      onFieldSubmitted: (value) => FocusScope.of(context)
                          .requestFocus(_password2FocusNode),
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
                      decoration: kLoginTextFieldDecoration.copyWith(
                          hintText: 'Repita sua senha',
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
                    FlatButton(
                      child: Text('Criar conta'),
                      color: Colors.blueAccent,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _spinner(true);
                          dynamic result = await _authService
                              .registerWithEmailAndPassword(_email, _password);
                          if (result is String) {
                            _spinner(false);
                            _showMessage(result);
                          } else {
                            Navigator.pop(context);
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
      ),
    );
  }
}
