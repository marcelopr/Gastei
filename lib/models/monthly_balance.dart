import 'package:carteira/utils/date_formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyBalance {
  String docId = '';
  int income = 0;
  int outcome = 0;

  MonthlyBalance();

  fromSnapshot(DocumentSnapshot document) {
    if (document.exists && document.data != null) {
      docId = document.data['docId'] ?? '';
      income = document.data['income'] ?? 0;
      outcome = document.data['outcome'] ?? 0;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'income': income,
      'outcome': outcome,
    };
  }

  setDocId(DateTime dateToday) {
    docId =
        '${dateToday.year}${DateFormatter().getMonthNumber(dateToday.month)}';
  }

  getYear() {
    return docId.substring(0, 4);
  }

  getMonth() {
    return docId.substring(4, 6);
  }

  int monthlyBalance() {
    return income - outcome;
  }

  bool isMonthlyBalancePositive() {
    return monthlyBalance() >= 0;
  }

  int total() => income + outcome;

  double incomePercent() => ((income * 100) / total()) * 0.01;
}
