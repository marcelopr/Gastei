import 'package:carteira/constants/constants.dart';
import 'package:carteira/models/monthly_balance.dart';
import 'package:carteira/utils/currency_formatter.dart';
import 'package:carteira/utils/date_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MonthYearItem extends StatelessWidget {
  final MonthlyBalance monthlyBalance;
  final Function loadExpenses;

  MonthYearItem({
    @required this.monthlyBalance,
    @required this.loadExpenses,
  });

  final CurrencyFormatter currencyFormatter = CurrencyFormatter();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      onPressed: () {
        print(monthlyBalance.docId);
        this.loadExpenses(monthlyBalance.docId);
      },
      child: Text(
          '${DateFormatter().getMonthName(int.parse(monthlyBalance.getMonth())).substring(0, 3)}. ${monthlyBalance.getYear()}',
          style: kMonthlyBalanceDataTextStyle),
    );
  }
}
