import 'package:carteira/constants/constants.dart';
import 'package:carteira/models/register.dart';
import 'package:carteira/models/user.dart';
import 'package:carteira/routes/routing_constants.dart';
import 'package:carteira/services/firestore.dart';
import 'package:carteira/utils/currency_formatter.dart';
import 'package:carteira/utils/custom_icons.dart';
import 'package:carteira/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class RecentRegister extends StatefulWidget {
  @override
  _RecentRegisterState createState() => _RecentRegisterState();
}

class _RecentRegisterState extends State<RecentRegister> {
  Stream _register;
  DateTime _dateToday;
  CurrencyFormatter _currencyFormatter;
  String _registerDate(DateTime date) {
    return DateFormatter()
        .formattedItemDate(now: _dateToday, date: date)
        .toLowerCase();
  }

  ///O Listener deve ser iniciado no initState para que os
  ///rebuilds não acabem realizando novas requests ao Firestore
  @override
  void initState() {
    _dateToday = DateTime.now();
    _currencyFormatter = CurrencyFormatter();
    String uid = Provider.of<User>(context, listen: false).uid;
    _register = FirestoreService(uid: uid).mostRecentPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: kBlue,
      disabledColor: kBlue,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(12.0),
      ),
      padding: EdgeInsets.all(12.0),
      onPressed: () {
        Navigator.pushNamed(
          context,
          RegistersRoute,
          arguments: {
            'userData': Provider.of<UserData>(context, listen: false),
          },
        );
      },
      child: SizedBox(
        width: double.infinity,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Histórico', style: kMainHeaderTextStyle),
              StreamBuilder(
                stream: _register,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.documents.toList().isEmpty) {
                      return Text(
                        'Você ainda não possui registros adicionados',
                        style: kLastRegisterInfoTextStyle,
                      );
                    } else {
                      Register register = Register()
                        ..fromSnapshot(snapshot.data.documents[0]);

                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: kBlueLight,
                              borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SvgPicture.asset(
                                register.type == 2
                                    ? 'lib/assets/icons/ic_money.svg'
                                    : CustomIcons.getCategoryIcon(
                                        register.category),
                                height: 20,
                                width: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Última movimentação foi registrada ${_registerDate(register.date)} com valor de R\$ ${_currencyFormatter.realSign(register.value)}.',
                            style: kLastRegisterInfoTextStyle,
                          ),
                        ],
                      );
                    }
                  } else {
                    return Text(
                      'Você ainda não possui registros adicionados',
                      style: kLastRegisterInfoTextStyle,
                    );

                    ///Evita o erro de layout por causa do snapshot inexistente
                    ///return Container(width: 0.0, height: 0.0);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
