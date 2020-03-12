import 'package:carteira/ui/theme/app_theme.dart';
import 'package:carteira/utils/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carteira/constants/constants.dart';

class ReAuthDialog extends StatefulWidget {
  final FirebaseUser user;
  final DialogType action;
  ReAuthDialog({@required this.user, @required this.action});

  _ReAuthDialogState createState() => _ReAuthDialogState();
}

class _ReAuthDialogState extends State<ReAuthDialog> {
  final _passwordController = TextEditingController();
  String _dialogTitle;
  String _message = '';
  bool _validPassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dialogTitle = _getDialogTitle();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  String _getDialogTitle() {
    switch (widget.action) {
      case DialogType.editBalance:
        return 'Confirme sua identidade para alterar o saldo';
        break;
      case DialogType.balanceVisibility:
        return 'Confirme sua identidade para alterar a visibilidade do saldo';
        break;
      case DialogType.removeAccount:
        return 'Confirme sua identidade para excluir sua conta';
        break;
      case DialogType.resetAccount:
        return 'Confirme sua identidade para restaurar a configuração inicial';
        break;

      default:
        return 'Confirme sua identidade';
    }
  }

  void loadingLayout(bool show) {
    setState(() {
      _validPassword = show;
      _isLoading = show;
    });
  }

  _authenticate(AuthCredential credential) async {
    loadingLayout(true);
    try {
      var result = await widget.user.reauthenticateWithCredential(credential);
      if (result.user != null) {
        Navigator.pop(context, true);
        print(result.user.email);
      } else {
        setState(() {
          _message = 'Senha incorreta';
        });
      }
    } on PlatformException catch (e) {
      if (mounted) {
        setState(() {
          _message = PlatformExceptions().errorMessage(e.code);
        });
        print(e.toString());
      }
    } catch (e) {
      //Bug do Firebase quando o método retorna um usuário válido
      print('LOG > ${e.toString()}');
      if (mounted) {
        setState(() {
          _message = '';
        });
      }
      Navigator.pop(context);
    } finally {
      loadingLayout(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        titleTextStyle: AppTheme.lightSubHeadTextStyle,
        title: Text(
          _dialogTitle,
          style: Theme.of(context).textTheme.body1,
        ),
        content: TextField(
          enabled: _isLoading ? false : true,
          controller: _passwordController,
          obscureText: true,
          maxLines: 1,
          autofocus: true,
          decoration: InputDecoration(
              hintText: 'Informe sua senha',
              errorText: _validPassword ? null : _message,
              errorMaxLines: 3,
              suffix: _isLoading ? CircularProgressIndicator() : null),
          onSubmitted: (passwordSubmitted) async {
            if (_passwordController.text.length == 0) {
              setState(() {
                _validPassword = false;
                _message = 'Preencha o campo';
              });
            } else {
              AuthCredential credential = EmailAuthProvider.getCredential(
                email: widget.user.email.toString(),
                password: _passwordController.text.trim().toString(),
              );
              _authenticate(credential);
            }
          },
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('Verificar'),
            onPressed: () async {
              if (_passwordController.text.length == 0) {
                setState(() {
                  _validPassword = false;
                  _message = 'Preencha o campo';
                });
              } else {
                AuthCredential credential = EmailAuthProvider.getCredential(
                  email: widget.user.email.toString(),
                  password: _passwordController.text.trim().toString(),
                );
                _authenticate(credential);
              }
            },
          )
        ]);
  }
}
