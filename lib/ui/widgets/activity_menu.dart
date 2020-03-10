import 'package:carteira/ui/widgets/current_month_balance.dart';
import 'package:carteira/ui/widgets/recent_register.dart';
import 'package:flutter/material.dart';

class ActivityMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: RecentRegister(),
          ),
          SizedBox(width: 16.0),
          Expanded(
            flex: 3,
            child: CurrentMonthBalance(),
          ),
        ],
      ),
    );
  }
}
