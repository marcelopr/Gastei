import 'package:carteira/constants/constants.dart';
import 'package:carteira/models/category_expenses.dart';
import 'package:carteira/models/monthly_balance.dart';
import 'package:carteira/models/register.dart';
import 'package:carteira/models/user.dart';
import 'package:carteira/services/firestore.dart';
import 'package:carteira/ui/widgets/category_expenses_item.dart';
import 'package:carteira/ui/widgets/loading_indicator.dart';
import 'package:carteira/ui/widgets/monthly_balance_info.dart';
import 'package:carteira/ui/widgets/register_item.dart';
import 'package:carteira/utils/currency_formatter.dart';
import 'package:carteira/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyBalanceDetails extends StatefulWidget {
  final MonthlyBalance mb;

  const MonthlyBalanceDetails({Key key, this.mb}) : super(key: key);

  @override
  _MonthlyBalanceDetailsState createState() => _MonthlyBalanceDetailsState();
}

class _MonthlyBalanceDetailsState extends State<MonthlyBalanceDetails> {
  MonthlyBalance _mb;
  List<Register> _registerList = []; //registros
  List<Register> _incomeList = [];
  List<int> _categoriesList = []; //categorias existentes nos registros
  List<CategoryExpenses> _categoryExpenses = [];
  bool _isLoading = true;

  ///1º Carregar todas as despesas do mês
  ///2º Identificar as categorias existentes
  ///3º Criar objeto CategoryExpenses para cada categoria

  @override
  void initState() {
    _mb = widget.mb;
    _loadRegisters();
    super.initState();
  }

  _loadRegisters() async {
    String uid = Provider.of<User>(context, listen: false).uid;
    _registerList = await FirestoreService(uid: uid).postsFromMonth(_mb.docId);

    ///Criando lista de entradas e lista de categorias
    _registerList.forEach(
      (register) {
        if (register.isIncome()) {
          _incomeList.add(register);
        } else {
          if (!_categoriesList.contains(register.category))
            _categoriesList.add(register.category);
        }
      },
    );
    if (_incomeList.isNotEmpty) {
      _incomeList.sort((a, b) => b.date.compareTo(a.date));
    }
    _registerList.removeWhere((register) => register.type == 2);
    _createCategoryInfo();
  }

  _createCategoryInfo() {
    for (var category in _categoriesList) {
      List<Register> list = [];
      var categoryExpended = 0;
      double percentage = 0;

      for (var register in _registerList) {
        if (register.category == category) {
          list.add(register);
          categoryExpended += register.value;
        }
      }
      list.sort((a, b) => b.date.compareTo(a.date));
      //x = (100 * valor total da categoria) / valor total geral do mês
      percentage = (100 * categoryExpended) / (_mb.outcome);

      _categoryExpenses.add(CategoryExpenses(
        categoryItems: list,
        category: category,
        totalExpended: categoryExpended,
        percentage: percentage,
      ));
    }
    _categoryExpenses.sort((a, b) => b.percentage.compareTo(a.percentage));
    setState(() => _isLoading = false);
  }

  String get appBarTitle =>
      DateFormatter().getMonthName(int.parse(_mb.getMonth())) +
      ' ' +
      _mb.getYear();

  String _registerCount(int length) {
    return length <= 1 ? '$length registro' : '$length registros';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: Theme.of(context).textTheme.subhead,
        ),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MonthlyBalanceInfo(mb: _mb),
                SizedBox(width: 8.0),
                Divider(),
              ],
            ),
          ),
          _isLoading
              ? Expanded(child: LoadingIndicator())
              : _categoriesListBuilder(),
        ],
      ),
    );
  }

  Widget _categoriesListBuilder() => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_incomeList.isNotEmpty) _buildIncomeInfo(),
            Divider(),
            if (_categoryExpenses.isNotEmpty) _buildOutcomeInfo(),
          ],
        ),
      );

  Widget _buildIncomeInfo() {
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      onPressed: () => _showBottomSheetList(_incomeList),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Lucro',
              style: Theme.of(context).textTheme.subhead,
            ),
            SizedBox(height: 8.0),
            Text(
              '${_registerCount(_incomeList.length)} com valor total de R\$ ${CurrencyFormatter().realSign(_mb.income)}',
              style: Theme.of(context).textTheme.body2,
            ),
          ]),
    );
  }

  Widget _buildOutcomeInfo() {
    return Flexible(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 8.0),
            child: Text(
              'Despesas',
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: _categoryExpenses.length,
              itemBuilder: (context, index) {
                return CategoryExpensesItem(
                  categoryExpenses: _categoryExpenses[index],
                  showList: _showBottomSheetList,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  _showBottomSheetList(List<Register> registers) {
    DateTime dateToday = DateTime.now();
    showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (builder) {
        return ListView.builder(
          itemCount: registers.length,
          itemBuilder: (context, index) {
            return RegisterItem(
              dateToday: dateToday,
              register: registers[index],
              onRemove: null,
            );
          },
        );
      },
    );
  }
}
