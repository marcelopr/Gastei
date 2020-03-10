import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carteira/constants/constants.dart';

class Register {
  int type;
  int category;
  int value;
  String title;
  DateTime date;
  String documentID;

  Register(
      {this.type,
      this.category,
      this.value,
      this.title,
      this.date,
      this.documentID});

  bool validateRegister() {
    if (type == null ||
        category == null ||
        title == null ||
        value == null ||
        date == null) {
      return false;
    }
    return true;
  }

  String formattedValue() {
    return 'R\$ ${value.toStringAsFixed(2)}';
  }

  fromSnapshot(DocumentSnapshot document) {
    type = document.data['type'];
    category = document.data['category'];
    value = document.data['value'];
    title = document.data['title'];
    date = document.data['date'].toDate();
    documentID = document.documentID;
  }

  bool isIncome() => type == 2;

  String get categoryName =>
      type == 2 ? 'Entrada' : '${kRegisterCategories[category]}';
}
