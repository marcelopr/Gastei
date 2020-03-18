import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  String uid;
  User({this.uid});

  set userUid(String uid) {
    this.uid = uid;
  }
}

class UserData extends ChangeNotifier {
  String uid;
  String name = '';
  int balance = 0;
  bool balanceVisible = true;

  UserData();

  fromSnapshot(DocumentSnapshot snapshot) {
    if (!snapshot.exists) return;
    this.name = snapshot.data['name'] ?? '';
    this.balance = snapshot.data['balance'] ?? 0;
    this.balanceVisible = snapshot.data['balanceVisible'] ?? true;

    notifyListeners();
  }

  set setUid(String uid) => this.uid = uid;

  setBalance(int newValue) => balance = newValue;

  String get getName => this.name;

  int get getBalance => this.balance;

  bool get get => this.balanceVisible;
}
