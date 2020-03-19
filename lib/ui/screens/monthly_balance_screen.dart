import 'package:carteira/models/monthly_balance.dart';
import 'package:carteira/models/user.dart';
import 'package:carteira/services/firestore.dart';
import 'package:carteira/ui/widgets/monthly_balance_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MBScreen extends StatefulWidget {
  @override
  _MBScreenState createState() => _MBScreenState();
}

class _MBScreenState extends State<MBScreen> {
  List<MonthlyBalance> _mbList = [];
  ScrollController _scrollController;

  bool _isLoading = false, _firstDataLoad = true, _allLoaded = false;
  FirestoreService _firestore;

  @override
  void initState() {
    super.initState();
    String uid = Provider.of<User>(context, listen: false).uid;
    _firestore = FirestoreService(uid: uid);
    _scrollController = ScrollController()..addListener(_scrollListener);
    _loadDocs();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < _mbList.length) {
      if (!_allLoaded) {
        if (!_isLoading) {
          _loadDocs();
        }
      }
    }
  }

  /* 1º Consultar documentos; 2º Adicioná-los à lista; 3º setState */
  void _loadDocs() async {
    setState(() => _isLoading = true);

    var docs = await _firestore.getMonthlyBalances(firstLoad: _firstDataLoad);

    if (docs.isNotEmpty) {
      docs.forEach(
        (document) {
          _mbList.add(document);
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

  Center _message() {
    return Center(
      child: Text('Não existem registros.',
          style: Theme.of(context).textTheme.body1),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('MBBUILD');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Balanço Mensal',
          style: Theme.of(context).textTheme.subhead,
        ),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: <Widget>[
            Expanded(child: _buildList()),
            Visibility(visible: _isLoading, child: LinearProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    if (!_firstDataLoad && _mbList.isEmpty) {
      return _message();
    }
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      controller: _scrollController,
      itemCount: _mbList.length,
      itemBuilder: (context, index) {
        return MonthlyBalanceItem(mb: _mbList[index]);
      },
    );
  }
}
