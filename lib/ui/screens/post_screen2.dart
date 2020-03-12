import 'package:carteira/models/monthly_balance.dart';
import 'package:carteira/services/firestore.dart';
import 'package:carteira/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:carteira/constants/constants.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostScreen2 extends StatefulWidget {
  static const id = 'post_screen';

  final Map<String, dynamic> arguments;

  PostScreen2({@required this.arguments});

  _PostScreen2State createState() => _PostScreen2State();
}

class _PostScreen2State extends State<PostScreen2> {
  //parameters
  int _balance;
  String _uid;
  MonthlyBalance _monthlyBalance;

  //lists
  List _registerTypes = kRegisterTypes.values.toList();
  List _registerCategories = kRegisterCategories.values.toList();

  //post fields
  String _type = 'Entrada';
  String _category = 'Outro';
  DateTime _date;

  //date
  final dateToday = DateTime.now();
  final format = DateFormat("dd-MM-yyyy");

  //booleans
  bool _showSpinner = false;
  bool _categoryEnabled = true;

  //textfields focus and controllers
  FocusNode _titleFocusNode = FocusNode();
  TextEditingController _valueController = TextEditingController();
  TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _balance = widget.arguments['balance'];
    _uid = widget.arguments['uid'];
    _monthlyBalance = widget.arguments['monthlyBalance'];
    _type = 'Saída';
    _date = dateToday;
  }

  @override
  void dispose() {
    _valueController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  int _getTypeKey(String type) {
    int typeKey;
    kRegisterTypes.forEach((key, value) {
      if (type == value) {
        typeKey = key;
      }
    });
    return typeKey;
  }

  int _getCategoryKey(String category) {
    int categoryKey = 0;
    kRegisterCategories.forEach(
      (key, value) {
        if (category == value) {
          categoryKey = key;
        }
      },
    );

    return categoryKey;
  }

  bool _validateForm() {
    if (_titleController.text.trim().length == 0 ||
        _valueController.text.length == 0 ||
        _getTypeKey(_type) == null ||
        _getCategoryKey(_category) == null ||
        _date == null) {
      return false;
    } else {
      return true;
    }
  }

  Map<String, dynamic> _registerMap() {
    return {
      'type': _getTypeKey(_type),
      'category': _getCategoryKey(_category),
      'title': _titleController.text.trim(),
      'value': int.parse(_valueController.text),
      'date': _date,
      'flags': _getRegisterFlags()
    };
  }

  void _addRegister() async {
    _spinner(true);
    bool isIncome = _getTypeKey(_type) == 2;
    int registerValue = int.parse(_valueController.text);
    var firestore = FirestoreService(uid: _uid);
    /*Add Post*/
    await firestore.addRegister(register: _registerMap());
    /*Editar Saldo*/
    await firestore.editBalance(
        balance:
            isIncome ? (_balance + registerValue) : (_balance - registerValue));
    /*Atualizar Balanço Mensal -> Verificar se o mês é atual*/
    String mbDocId = DateFormatter(dateToday: _date).monthlyBalanceDocId;

    if (_monthlyBalance.docId == mbDocId) {
      await firestore.updateMonthlyBalance(
          monthlyBalance: _updatedMonthlyBalance(isIncome, registerValue));
    } else {
      await firestore.updateOldMonthlyBalance(
          docId: mbDocId, isIncome: isIncome, registerValue: registerValue);
    }
    Navigator.pop(context);
    _spinner(false);
  }

  //Ajustar ano do MB
  MonthlyBalance _updatedMonthlyBalance(bool isIncome, int registerValue) {
    isIncome
        ? _monthlyBalance.income += registerValue
        : _monthlyBalance.outcome += registerValue;
    print(
        '${_monthlyBalance.docId} ${_monthlyBalance.income} ${_monthlyBalance.outcome}');
    return _monthlyBalance;
  }

  List _getRegisterFlags() {
    var rawFlags = _titleController.text.split(" ");
    var finalFlags = [];
    for (var item in rawFlags) {
      if (item.length > 4 && item.isNotEmpty) {
        finalFlags.add(item.toLowerCase());
      }
    }
    return finalFlags;
  }

  void _spinner(bool show) {
    setState(() {
      _showSpinner = show;
    });
  }

  void _toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  @override
  Widget build(BuildContext context) {
    print('POST BUILD');
    ThemeData theme = Theme.of(context);

    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            buildTopRow(context, theme),
            SizedBox(height: 20),
            buildValueTextField(theme),
            SizedBox(height: 20),
            Divider(),
            buildTitleRow(theme),
            Divider(),
            buildTypeRow(theme),
            buildCategoryRow(theme),
            Divider(),
            buildDateRow(theme),
          ],
        ),
      ),
    );
  }

  Row buildTopRow(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        Flexible(
          flex: 3,
          child: Container(),
        ),
        Flexible(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _validateForm() ? _addRegister() : _toast('Dados inválidos');
            },
          ),
        ),
      ],
    );
  }

  TextField buildValueTextField(ThemeData theme) {
    return TextField(
      keyboardType: TextInputType.number,
      maxLines: 1,
      autofocus: false,
      textInputAction: TextInputAction.next,
      controller: _valueController,
      style: theme.textTheme.title.copyWith(
        fontSize: 50,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration.collapsed(hintText: 'Valor'),
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
      ],
      onSubmitted: (value) {
        FocusScope.of(context).requestFocus(_titleFocusNode);
      },
    );
  }

  Widget buildTitleRow(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Text(
              'Título',
              style:
                  theme.textTheme.body2.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            flex: 2,
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _titleController,
              textAlign: TextAlign.end,
              decoration:
                  InputDecoration.collapsed(hintText: 'Informe o título'),
              focusNode: _titleFocusNode,
              style: kFormTextStyle,
              autocorrect: true,
              autofocus: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTypeRow(ThemeData theme) {
    return FlatButton(
      onPressed: () {
        _showBottomSheetList(1, theme);
      },
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Tipo',
            style: theme.textTheme.body2.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            _type,
            style: theme.textTheme.body1,
          ),
        ],
      ),
    );
  }

  Widget buildCategoryRow(ThemeData theme) {
    return !_categoryEnabled
        ? Container(width: 0.0, height: 0.0)
        : Column(
            children: <Widget>[
              Divider(),
              FlatButton(
                onPressed: () {
                  _showBottomSheetList(2, theme);
                },
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Categoria',
                        style: theme.textTheme.body2
                            .copyWith(fontWeight: FontWeight.bold)),
                    Text(
                      _category,
                      style: theme.textTheme.body1,
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  Padding buildDateRow(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Text('Data',
                style: theme.textTheme.body2
                    .copyWith(fontWeight: FontWeight.bold)),
          ),
          Flexible(
            flex: 2,
            child: DateTimeField(
              keyboardType: TextInputType.datetime,
              style: theme.textTheme.body1,
              format: format,
              textInputAction: TextInputAction.done,
              resetIcon: Icon(Icons.close, size: 24),
              textAlign: TextAlign.end,
              decoration: InputDecoration(hintText: 'Selecione a data'),
              initialValue: _date,
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    locale: const Locale("pt", "PT"),
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
              onChanged: (dateTime) {
                _date = dateTime;
              },
            ),
          ),
        ],
      ),
    );
  }

  _showBottomSheetList(int list, ThemeData theme) {
    ///1 = type; 2 = category
    var selectedList = list == 1 ? _registerTypes : _registerCategories;

    showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (builder) {
        return ListView.builder(
          itemCount: selectedList.length,
          itemBuilder: (context, index) {
            return FlatButton(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              onPressed: () {
                if (mounted) {
                  setState(() {
                    if (list == 1) {
                      _type = selectedList[index];
                      _categoryEnabled = _type == 'Entrada' ? false : true;
                    } else {
                      _category = selectedList[index];
                    }
                  });
                }
                Navigator.pop(context);
              },
              child: Text(
                selectedList[index],
                style: theme.textTheme.body1,
                textAlign: TextAlign.end,
              ),
            );
          },
        );
      },
    );
  }
}
