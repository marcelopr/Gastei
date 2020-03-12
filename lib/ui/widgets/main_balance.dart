import 'package:carteira/constants/constants.dart';
import 'package:carteira/models/user.dart';
import 'package:carteira/ui/theme/app_theme.dart';
import 'package:carteira/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainBalance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('BUILD MAIN BALANCE WIDGET');
    return Consumer<UserData>(
      builder: (context, userData, child) => SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _getName(userData.getName, context),
              SizedBox(height: 20.0),
              _balanceInfo(userData, context),
            ],
          ),
        ),
      ),
    );
  }

  String _apropriateTimeGreeting() {
    int hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return 'Bom dia, ';
    } else if (hour >= 12 && hour < 18) {
      return 'Boa tarde, ';
    } else if (hour >= 18 || hour < 6 && hour >= 0) {
      return 'Boa noite, ';
    } else {
      return 'Bla, ';
    }
  }

  Widget _getName(String name, BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: '${_apropriateTimeGreeting()}$name',
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontWeight: FontWeight.w200)),
        ],
      ),
    );
  }

  Widget _balanceInfo(UserData userData, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'SALDO ATUAL',
          style: Theme.of(context).textTheme.caption,
        ),
        SizedBox(height: 4.0),
        if (!userData.balanceVisible)
          Text(
            'Oculto',
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(fontWeight: FontWeight.w900),
          ),
        if (userData.balanceVisible)
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: 'R\$ ', style: Theme.of(context).textTheme.body2),
                TextSpan(
                    text: '${CurrencyFormatter().realSign(userData.balance)}',
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontWeight: FontWeight.bold))
              ],
            ),
          ),
      ],
    );
  }
}
