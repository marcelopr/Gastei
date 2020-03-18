import 'package:carteira/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carteira/utils/platform_exceptions.dart';
import 'package:flutter/services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> get firebaseUser => _auth.currentUser();

  //retorna User a partir de um FirebaseUSer
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //Stram para verificar se há algum usuário logado
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  //Login com email e senha
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on PlatformException catch (e) {
      print(e.toString());
      return PlatformExceptions().errorMessage(e.code);
    } catch (e) {
      return e.toString();
    }
  }

  //Registrar novo usuário com email e senha
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on PlatformException catch (e) {
      print(e.toString());
      return PlatformExceptions().errorMessage(e.code);
    } catch (e) {
      return e.toString();
    }
  }

  //Enviar Email para alterar senha
  Future sendResetPasswordEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on PlatformException catch (e) {
      return PlatformExceptions().errorMessage(e.code);
    } catch (e) {
      return e.toString();
    }
  }

  //Logoff
  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      return e.toString();
    }
  }
}
