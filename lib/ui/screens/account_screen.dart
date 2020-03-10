import 'package:carteira/constants/constants.dart';
import 'package:carteira/models/user.dart';
import 'package:carteira/routes/routing_constants.dart';
import 'package:carteira/services/auth.dart';
import 'package:carteira/services/firestore.dart';
import 'package:carteira/ui/dialogs/reauth_dialog.dart';
import 'package:carteira/ui/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  static const String id = 'account';

  final String name;

  const AccountScreen({Key key, this.name}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _optionsEnabled = true;
  bool _progressPassword = false;
  bool _progressRemove = false;
  bool _progressName = false;
  bool _progressResetConfig = false;
  bool _returnChanges = false;

  TextEditingController _nameController = TextEditingController();
  String _name;
  String _nameError;
  FirestoreService _firestore;

  @override
  void initState() {
    _name = widget.name;
    if (_name.isNotEmpty) _nameController.text = _name;
    _firestore =
        FirestoreService(uid: Provider.of<User>(context, listen: false).uid);
    super.initState();
  }

  Future<FirebaseUser> _firebaseUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

  void _reAuthenticate(BuildContext context, DialogType action) async {
    FirebaseUser user = await _firebaseUser();

    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReAuthDialog(user: user, action: action);
      },
    );

    if (result == true && action == DialogType.resetAccount) {
      _resetAccount();
    } else if (result == true && action == DialogType.changePassword) {
      _sendResetPasswordEmail();
    } else if (result == true && action == DialogType.removeAccount) {
      _removeUser();
    }
  }

  Future _sendResetPasswordEmail() async {
    setState(() {
      _progressPassword = true;
      _optionsEnabled = false;
    });
    FirebaseUser user = await _firebaseUser();
    dynamic result = await AuthService().sendResetPasswordEmail(user.email);
    setState(() {
      _progressPassword = false;
      _optionsEnabled = true;
    });
    result is String
        ? _toast(result)
        : _toast('Verifique seu Email para alterar sua senha');
  }

  Future _resetAccount() async {
    setState(() {
      _progressResetConfig = true;
      _optionsEnabled = false;
    });

    try {
      await _firestore.deleteUserBasicInfo();
      await _firestore.deleteUserPosts();
      await _firestore.deleteUserMonthlyBalances();

      setState(() {
        _nameController.text = '';
      });
      _toast('Configurações iniciais restauradas');
    } catch (e) {
      _toast(e.toString());
    } finally {
      setState(() {
        _progressResetConfig = false;
        _optionsEnabled = true;
      });
    }
  }

  bool _verifyName() {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = 'O nome não pode estar vazio');
      return false;
    }
    setState(() => _nameError = null);
    return true;
  }

  Future _updateName() async {
    setState(() {
      _progressName = true;
      _optionsEnabled = false;
    });
    await _firestore.updateName(newName: _nameController.text.trim());
    setState(() {
      _progressName = false;
      _optionsEnabled = true;
    });
    _toast('Nome atualizado');
  }

  void _removeUser() async {
    setState(() {
      _progressRemove = true;
      _optionsEnabled = false;
    });
    try {
      var user = await _firebaseUser();
      await _firestore.deleteUserBasicInfo();
      await _firestore.deleteUserPosts();
      await _firestore.deleteUserMonthlyBalances();
      await user.delete();
      _toast('Conta removida com sucesso');

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
          ModalRoute.withName(LoginRoute));
    } catch (err) {
      _toast(err.toString());
    } finally {
      setState(() {
        _progressRemove = false;
        _optionsEnabled = true;
      });
    }
  }

  void _toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: kToastBackgroundColor,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minha conta',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context, _returnChanges),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            enabled: _optionsEnabled,
            contentPadding: EdgeInsets.symmetric(horizontal: 32),
            leading: Icon(Icons.person),
            trailing: _progressName ? CircularProgressIndicator() : null,
            title: TextField(
              enabled: _optionsEnabled,
              keyboardType: TextInputType.text,
              controller: _nameController,
              maxLines: 1,
              inputFormatters: [
                LengthLimitingTextInputFormatter(12),
              ],
              decoration: InputDecoration(
                  hintText: 'Informe seu nome',
                  errorText: _nameError ?? _nameError,
                  border: InputBorder.none),
              onSubmitted: (name) {
                _verifyName() ? _updateName() : null;
              },
            ),
          ),
          Divider(),
          ListTile(
              enabled: _optionsEnabled,
              contentPadding: EdgeInsets.symmetric(horizontal: 32),
              title: Text('Alterar senha'),
              subtitle: Text(
                'Um email para alterar sua senha será enviado para o seu endereço.',
                style: TextStyle(fontSize: 14),
              ),
              leading: Icon(Icons.lock),
              trailing: _progressPassword ? CircularProgressIndicator() : null,
              onTap: () => _reAuthenticate(context,
                  DialogType.changePassword) //_sendResetPasswordEmail(),
              ),
          Divider(),
          ListTile(
              enabled: _optionsEnabled,
              contentPadding: EdgeInsets.symmetric(horizontal: 32),
              title: Text('Restaurar configuração inicial'),
              subtitle: Text(
                'Remove todos os seus registros financeiros.',
                style: TextStyle(fontSize: 14),
              ),
              leading: Icon(Icons.settings_backup_restore),
              trailing:
                  _progressResetConfig ? CircularProgressIndicator() : null,
              onTap: () => _reAuthenticate(context, DialogType.resetAccount)
              // _reAuthenticate(context, 'resetConfig'),
              ),
          Divider(),
          ListTile(
              enabled: _optionsEnabled,
              contentPadding: EdgeInsets.symmetric(horizontal: 32),
              title: Text('Remover conta'),
              subtitle: Text(
                  'Remove sua conta e todos os seus registros financeiros.',
                  style: TextStyle(fontSize: 14)),
              leading: Icon(Icons.delete_forever),
              trailing: _progressRemove ? CircularProgressIndicator() : null,
              onTap: () => _reAuthenticate(context, DialogType.removeAccount)),
        ],
      ),
    );
  }
}
