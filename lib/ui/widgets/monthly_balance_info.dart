import 'package:carteira/constants/constants.dart';
import 'package:carteira/models/monthly_balance.dart';
import 'package:flutter/material.dart';

class MonthlyBalanceInfo extends StatelessWidget {
  const MonthlyBalanceInfo({
    Key key,
    @required MonthlyBalance mb,
  })  : _mb = mb,
        super(key: key);

  final MonthlyBalance _mb;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildColumn(
              icon: Icons.keyboard_arrow_up,
              value: _mb.income,
              color: kBlue,
              theme: theme),
          _buildColumn(
              icon: Icons.keyboard_arrow_down,
              value: _mb.outcome,
              color: Colors.red,
              theme: theme),
          _buildColumn(
              icon: Icons.attach_money,
              value: _mb.monthlyBalance(),
              color: _mb.isMonthlyBalancePositive() ? kBlue : Colors.red,
              theme: theme),
        ],
      ),
    );
  }

  Widget _buildColumn(
      {IconData icon, int value, Color color, ThemeData theme}) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                border: Border.all(
                    width: 1,
                    color: theme.iconTheme.color,
                    style: BorderStyle.solid)),
            child: Icon(
              icon,
            ),
          ),
          SizedBox(height: 12.0),
          Text(
            'R\$ $value',
            style: theme.textTheme.body1.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
