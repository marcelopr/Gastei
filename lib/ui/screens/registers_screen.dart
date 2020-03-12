import 'package:carteira/constants/constants.dart';
import 'package:carteira/models/register.dart';
import 'package:carteira/models/user.dart';
import 'package:carteira/services/firestore.dart';
import 'package:carteira/ui/screens/register_search_screen.dart';
import 'package:carteira/ui/widgets/register_item.dart';
import 'package:carteira/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class RegistersScreen extends StatefulWidget {
  static const id = 'registers';

  final Map<String, dynamic> arguments;

  RegistersScreen({@required this.arguments});

  @override
  _RegistersScreenState createState() => _RegistersScreenState();
}

class _RegistersScreenState extends State<RegistersScreen> {
  UserData _userData;
  List<Register> _registerList = [];
  ScrollController _scrollController;

  bool _isLoading = false, _firstDataLoad = true, _allLoaded = false;
  FirestoreService _firestore;
  DateTime _dateToday;

  @override
  void initState() {
    _userData = widget.arguments['userData'];
    print('initialBalance: ' + _userData.balance.toString());
    _dateToday = DateTime.now();
    _firestore = FirestoreService(uid: _userData.uid);
    _scrollController = ScrollController()..addListener(_scrollListener);
    _loadPosts();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < _registerList.length) {
      print('LOG > scrollListener() Final da Lista');
      if (!_allLoaded) {
        if (!_isLoading) {
          _loadPosts();
        } else {
          print('LOG > scrollListener() > Já está carregando');
        }
      } else {
        print('LOG > scrollListener() > allLoaded');
      }
    }
  }

  /* 1º Consultar documentos; 2º Adicioná-los à lista; 3º setState */
  void _loadPosts() async {
    setState(() => _isLoading = true);

    var docs = await _firestore.getRegisters(firstLoad: _firstDataLoad);

    if (docs.isNotEmpty) {
      docs.forEach(
        (document) {
          _registerList.add(document);
        },
      );
    }

    setState(() {
      _firstDataLoad = false;
      _isLoading = false;
      if (docs.isEmpty) _allLoaded = true;
      if (docs.length < 8) _allLoaded = true;
    });
  }

  _removeRegister(Register register) async {
    var updatedBalance = await _firestore.deleteRegister(
        register: register,
        balance: _userData.balance,
        mbId: DateFormatter(dateToday: register.date).monthlyBalanceDocId);
    _userData.setBalance(updatedBalance);
    setState(() {
      _registerList
          .removeWhere((item) => item.documentID == register.documentID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Histórico',
          style: Theme.of(context).textTheme.subhead,
        ),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              var result = await showSearch(
                context: context,
                delegate: RegisterSearch(
                  dateToday: _dateToday,
                  userData: _userData,
                ),
              );
              if (result == "updated") Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildList()),
          if (_isLoading) LinearProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (!_firstDataLoad && _registerList.isEmpty) {
      return _message();
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: _registerList.length,
      itemBuilder: (context, index) {
        return RegisterItem(
          register: _registerList[index],
          dateToday: _dateToday,
          onRemove: _removeRegister,
        );
      },
    );
  }

  Center _message() {
    return Center(
      child: Text('Não existem registros.',
          style: Theme.of(context).textTheme.body1),
    );
  }
}
