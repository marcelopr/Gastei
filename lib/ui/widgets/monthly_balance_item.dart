import 'package:carteira/constants/constants.dart';
import 'package:carteira/models/monthly_balance.dart';
import 'package:carteira/routes/routing_constants.dart';
import 'package:carteira/utils/currency_formatter.dart';
import 'package:carteira/utils/date_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MonthlyBalanceItem extends StatelessWidget {
  final MonthlyBalance mb;
  MonthlyBalanceItem({@required this.mb});

  final CurrencyFormatter currencyFormatter = CurrencyFormatter();

  String _monthYear() {
    return DateFormatter().getMonthName(int.parse(mb.getMonth())) +
        '\n' +
        mb.getYear();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        Navigator.pushNamed(
          context,
          MonthlyBalanceDetaisRoute,
          arguments: mb,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(_monthYear(),
                    style: kMonthlyBalanceTextStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.black45,
                    )),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '+ R\$ ${currencyFormatter.realSign(mb.income)}',
                  style: kMonthlyBalanceTextStyle,
                ),
                Text('- R\$ ${currencyFormatter.realSign(mb.outcome)}',
                    style: kMonthlyBalanceTextStyle),
                Text('R\$ ${mb.monthlyBalance()}',
                    style: kMonthlyBalanceTextStyle.copyWith(
                        color: mb.isMonthlyBalancePositive() ? kBlue : kOrange))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
