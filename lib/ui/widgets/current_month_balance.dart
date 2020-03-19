import 'package:carteira/models/monthly_balance.dart';
import 'package:carteira/models/user.dart';
import 'package:carteira/routes/routing_constants.dart';
import 'package:carteira/services/firestore.dart';
import 'package:carteira/ui/theme/app_theme.dart';
import 'package:carteira/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class CurrentMonthBalance extends StatefulWidget {
  @override
  _CurrentMonthBalanceState createState() => _CurrentMonthBalanceState();
}

class _CurrentMonthBalanceState extends State<CurrentMonthBalance> {
  Stream _currentMonthBalance;
  DateTime _dateToday;
  String _uid;

  @override
  void initState() {
    _dateToday = DateTime.now();
    _uid = Provider.of<User>(context, listen: false).uid;
    _currentMonthBalance = FirestoreService(uid: _uid)
        .currentMonthlyBalanceStream(
            DateFormatter(dateToday: _dateToday).monthlyBalanceDocId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('BUILD CURRENT MONTH BALANCE WIDGET');

    Widget _buildBalanceIndicator(MonthlyBalance mb) {
      return Expanded(
        child: Center(
          child: CircularPercentIndicator(
            progressColor: Theme.of(context).colorScheme.primary,
            backgroundColor: mb.outcome == 0
                ? Colors.grey[300]
                : Theme.of(context).colorScheme.secondary,
            percent: mb.income == 0 ? 0 : mb.incomePercent(),
            animation: true,
            animationDuration: 800,
            radius: 110,
            lineWidth: 10.0,
            circularStrokeCap: CircularStrokeCap.butt,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'R\$ ${mb.income}',
                  style: Theme.of(context).textTheme.subtitle.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Text('R\$ ${mb.outcome}',
                    style: Theme.of(context).textTheme.subtitle.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ))
              ],
            ),
          ),
        ),
      );
    }

    FlatButton _buildCurrentMonth(MonthlyBalance mb) {
      return FlatButton(
        onPressed: () {
          Navigator.pushNamed(context, MonthlyBalanceRoute);
        },
        color: Theme.of(context).buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(AppTheme.borderRadius),
        ),
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                DateFormatter().getMonthName(_dateToday.month),
                style: Theme.of(context).textTheme.body2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              _buildBalanceIndicator(mb),
            ],
          ),
        ),
      );
    }

    Widget _buildAddButton(MonthlyBalance mb) {
      return Consumer<UserData>(
        builder: (context, userData, child) {
          return Container(
            width: double.infinity,
            child: FlatButton(
              color: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      new BorderRadius.circular(AppTheme.borderRadius)),
              child: Text(
                'Add Registro',
                style: Theme.of(context)
                    .textTheme
                    .body2
                    .copyWith(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pushNamed(context, PostRoute, arguments: {
                  'balance': userData.balance,
                  'uid': _uid,
                  'monthlyBalance': mb
                });
              },
            ),
          );
        },
      );
    }

    return StreamBuilder<MonthlyBalance>(
      stream: _currentMonthBalance,
      builder: (context, snapshot) {
        MonthlyBalance monthlyBalance =
            snapshot.hasData ? snapshot.data : MonthlyBalance();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 3, child: _buildCurrentMonth(monthlyBalance)),
            SizedBox(height: 12.0),
            Expanded(flex: 1, child: _buildAddButton(monthlyBalance)),
          ],
        );
      },
    );
  }
}
