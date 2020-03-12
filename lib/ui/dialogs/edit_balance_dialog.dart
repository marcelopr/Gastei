import 'package:carteira/models/user.dart';
import 'package:carteira/services/firestore.dart';
import 'package:carteira/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditBalanceDialog extends StatefulWidget {
  final UserData userData;
  const EditBalanceDialog({@required this.userData});

  _EditBalanceDialogState createState() => _EditBalanceDialogState();
}

class _EditBalanceDialogState extends State<EditBalanceDialog> {
  final _balanceController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage;

  @override
  void initState() {
    super.initState();
    _balanceController.text = widget.userData.balance.toString();
  }

  @override
  void dispose() {
    _balanceController.dispose();
    super.dispose();
  }

  _loadingLayout(loading) {
    setState(() {
      _errorMessage = null;
      _isLoading = loading;
    });
  }

  void _editBalance() async {
    _loadingLayout(true);
    var result = await FirestoreService(uid: widget.userData.uid)
        .editBalance(balance: int.parse(_balanceController.text));
    _loadingLayout(false);
    if (result == null) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _errorMessage = result.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titleTextStyle: AppTheme.lightSubHeadTextStyle,
      title: Text('Editar saldo:'),
      content: TextField(
        keyboardType: TextInputType.number,
        enabled: _isLoading ? false : true,
        controller: _balanceController,
        maxLines: 1,
        autofocus: true,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
            hintText: 'Informe seu saldo',
            errorText: _errorMessage ?? _errorMessage,
            errorMaxLines: 3,
            suffix: _isLoading ? CircularProgressIndicator() : null),
        onSubmitted: (balanceSubmitted) async {
          if (_balanceController.text.length == 0) {
            setState(() {
              _errorMessage = 'Preencha o campo';
            });
          } else {
            _editBalance();
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
          child: Text('Ok'),
          onPressed: () async {
            if (_balanceController.text.length == 0) {
              setState(() {
                _errorMessage = 'Preencha o campo';
              });
            } else {
              _editBalance();
            }
          },
        )
      ],
    );
  }
}
