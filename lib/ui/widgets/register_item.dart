import 'package:carteira/constants/constants.dart';
import 'package:carteira/models/register.dart';
import 'package:carteira/utils/custom_icons.dart';
import 'package:carteira/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterItem extends StatelessWidget {
  final Register register;
  final DateTime dateToday;
  final Function onRemove;

  RegisterItem({
    @required this.register,
    @required this.dateToday,
    @required this.onRemove,
  });

  final DateFormatter _dateFormatter = DateFormatter();

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.20,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 24.0, bottom: 24, left: 32, right: 32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    register.type == 2
                        ? 'lib/assets/icons/ic_money.svg'
                        : CustomIcons.getCategoryIcon(register.category),
                    height: 20,
                    width: 20,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      register.categoryName,
                      style: kRegisterDateStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      register.title,
                      style: kRegisterTitleStyle.copyWith(
                        color:
                            register.isIncome() ? Colors.green : Colors.black,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      _dateFormatter.formattedItemDate(
                          now: dateToday, date: register.date),
                      style: kRegisterDateStyle.copyWith(
                          color:
                              _dateFormatter.isToday(dateToday, register.date)
                                  ? kBlue
                                  : Colors.black38),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 0,
              child: Text(
                'R\$ ${register.value}',
                style: kRegisterValueStyle.copyWith(
                  color: register.isIncome() ? Colors.green : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      secondaryActions: onRemove == null
          ? null
          : <Widget>[
              IconSlideAction(
                caption: 'Excluir',
                color: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Colors.red,
                icon: Icons.delete,
                onTap: () async {
                  onRemove(register);
                },
              ),
            ],
    );
  }

  void toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: kToastBackgroundColor,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}
