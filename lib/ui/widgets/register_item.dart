import 'package:carteira/models/register.dart';
import 'package:carteira/ui/theme/app_theme.dart';
import 'package:carteira/utils/custom_icons.dart';
import 'package:carteira/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    ThemeData theme = Theme.of(context);
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.20,
      child: Container(
        padding: EdgeInsets.only(top: 24.0, bottom: 24, left: 32, right: 32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.buttonColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppTheme.categoryIconBorderRadius),
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
                    color: theme.accentIconTheme.color,
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
                      style: theme.textTheme.subtitle
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      register.title,
                      style: theme.textTheme.body1.copyWith(
                        color: register.isIncome()
                            ? Colors.greenAccent
                            : theme.textTheme.body1.color,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      _dateFormatter.formattedItemDate(
                          now: dateToday, date: register.date),
                      style: theme.textTheme.body2.copyWith(
                          color:
                              _dateFormatter.isToday(dateToday, register.date)
                                  ? theme.colorScheme.primary
                                  : theme.textTheme.body2.color),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 0,
              child: Text(
                'R\$ ${register.value}',
                style: theme.textTheme.body1.copyWith(
                  color: register.isIncome()
                      ? Colors.greenAccent
                      : theme.textTheme.body1.color,
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
                color: theme.scaffoldBackgroundColor,
                foregroundColor: Colors.red,
                icon: Icons.delete,
                onTap: () async {
                  onRemove(register);
                },
              ),
            ],
    );
  }
}
