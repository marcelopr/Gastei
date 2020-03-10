import 'package:carteira/models/category_expenses.dart';
import 'package:carteira/utils/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carteira/constants/constants.dart';
import 'package:carteira/utils/currency_formatter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CategoryExpensesItem extends StatelessWidget {
  final CategoryExpenses categoryExpenses;
  final Function showList;

  CategoryExpensesItem({@required this.categoryExpenses, this.showList});

  final CurrencyFormatter _currencyFormatter = CurrencyFormatter();

  String _registerCount(int length) {
    return length <= 1 ? '$length registro' : '$length registros';
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        showList(categoryExpenses.categoryItems);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: _buildBalanceIndicator(context),
                ),
                SizedBox(width: 16.0),
                Flexible(
                  flex: 6,
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${kRegisterCategories[categoryExpenses.category]}: ${categoryExpenses.percentage.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        '${_registerCount(categoryExpenses.categoryItems.length)} com valor total de R\$ ${_currencyFormatter.realSign(categoryExpenses.totalExpended)}',
                        textAlign: TextAlign.start,
                        style: kMBInfoDetails,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceIndicator(BuildContext context) {
    return Center(
      child: CircularPercentIndicator(
        progressColor: Colors.red,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        percent: categoryExpenses.percentage * 0.01,
        animation: true,
        animationDuration: 500,
        radius: 40.0,
        lineWidth: 2.0,
        circularStrokeCap: CircularStrokeCap.round,
        center: SvgPicture.asset(
          CustomIcons.getCategoryIcon(categoryExpenses.category),
          height: 20,
          width: 20,
          color: Colors.black,
        ),
      ),
    );
  }
}
