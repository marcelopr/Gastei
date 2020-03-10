import 'package:carteira/models/monthly_balance.dart';
import 'package:carteira/models/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final Firestore _firestore = Firestore.instance;
  final String uid;
  FirestoreService({this.uid});

  //Docs para paginação
  DocumentSnapshot _lastMBDocument;
  DocumentSnapshot _lastRegisterDocument;

  //Referências do Firestore
  DocumentReference _userRef() => _firestore.collection('users').document(uid);
  CollectionReference _userPosts() =>
      _firestore.collection('users').document(uid).collection('posts');
  CollectionReference _userMonthlyBalance() => _firestore
      .collection('users')
      .document(uid)
      .collection('monthly_balance');

  ///Stram dos dados principais do usuário, retornando o model UserData
  Stream<DocumentSnapshot> get userData {
    print("STREAM UserData");
    return _userRef().snapshots();
    //.map((snapshot) => UserData()..fromSnapshot(snapshot));
    //.map(_userDataFromSnapshot);
  }

  ///Remove user basic data
  Future deleteUserBasicInfo() async {
    return await _userRef().delete();
  }

  ///Removendo posts do user
  Future deleteUserPosts() async {
    await _userPosts().getDocuments().then((snapshot) {
      ///Atualmente (03/2020) o firestore não remove coleções inteiras,
      ///então tem que ser documento por documento.
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
  }

  ///Removendo posts do user
  Future deleteUserMonthlyBalances() async {
    await _userMonthlyBalance().getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
  }

  ///Stream para consultar post mais recente do usuário
  Stream<QuerySnapshot> mostRecentPost() {
    return _userPosts().orderBy('date', descending: true).limit(1).snapshots();
  }

  ///Retorna os posts do mês desejado
  Future<List<Register>> postsFromMonth(String date) async {
    DateTime start = DateTime.utc(
      int.parse(date.substring(0, 4)),
      int.parse(date.substring(4, 6)),
    );
    DateTime end = DateTime.utc(
      int.parse(date.substring(0, 4)),
      int.parse(date.substring(4, 6)) + 1,
    );
    List<Register> registerList = [];
    await _userPosts()
        .where(
          'date',
          isGreaterThanOrEqualTo: start,
          isLessThan: end,
        )
        .getDocuments()
        .then(
      (QuerySnapshot snapshot) {
        snapshot.documents.forEach(
          (document) {
            registerList.add(Register()..fromSnapshot(document));
          },
        );
      },
    );

    return registerList;
  }

  ///Stram do documento relativo ao Balanço Mensal do mês atual (para a tela inicial)
  Stream<MonthlyBalance> currentMonthlyBalanceStream(String docId) {
    return _userMonthlyBalance()
        .document(docId)
        .snapshots()
        .map((document) => MonthlyBalance()..fromSnapshot(document));
  }

  ///Stream dos Balanços Mensais
  Stream<QuerySnapshot> monthlyBalanceStream() {
    return _userMonthlyBalance().orderBy('docId', descending: true).snapshots();
  }

  //Query dos Balanços Mensais
  Future<List<MonthlyBalance>> getMonthlyBalances({bool firstLoad}) async {
    var ref = _userMonthlyBalance().orderBy('docId', descending: true).limit(7);
    Query querySnapshot =
        firstLoad ? ref : ref.startAfterDocument(_lastMBDocument);

    List<MonthlyBalance> list = [];
    await querySnapshot.getDocuments().then(
      (QuerySnapshot snapshot) {
        if (snapshot.documents.isNotEmpty) {
          snapshot.documents.forEach(
            (document) {
              list.add(MonthlyBalance()..fromSnapshot(document));
              _lastMBDocument = document;
            },
          );
        }
      },
    );
    return list;
  }

  //Snapshot do Balanço Mensal requerido
  Future<MonthlyBalance> monthlyBalanceSnap({String mbId}) async {
    var snap = await _userMonthlyBalance().document(mbId).get();
    return MonthlyBalance()..fromSnapshot(snap);
  }

  //Query dos Registros do Usuário
  Future<List<Register>> getRegisters({bool firstLoad}) async {
    var ref = _userPosts().orderBy('date', descending: true).limit(8);
    Query querySnapshot =
        firstLoad ? ref : ref.startAfterDocument(_lastRegisterDocument);

    List<Register> list = [];
    await querySnapshot.getDocuments().then(
      (QuerySnapshot snapshot) {
        snapshot.documents.forEach(
          (document) {
            list.add(Register()..fromSnapshot(document));
            _lastRegisterDocument = document;
          },
        );
      },
    );
    return list;
  }

  //Stram dos documentos para a tela de pesquisa
  Stream<QuerySnapshot> registerSearchStream({String search}) {
    return _userPosts()
        .where('flags', arrayContains: '$search')
        .orderBy('date', descending: true)
        .limit(10)
        .snapshots();
  }

  //Atualizar Balanço Mensal
  Future updateMonthlyBalance({MonthlyBalance monthlyBalance}) async {
    return await _userMonthlyBalance()
        .document(monthlyBalance.docId)
        .setData(monthlyBalance.toMap(), merge: true);
  }

  /*Atualizar Balanço dos meses passados:
  O método é separado porque para chamá-lo, preciso consultar o 
  documento antigo e pegar seus dados para calcular a nova
  inserção, enquanto que o doc. atual já é passado por parâmetro 
  para a post_screen.*/
  Future updateOldMonthlyBalance(
      {String docId, bool isIncome, int registerValue}) async {
    var oldDocSnap = await _userMonthlyBalance().document(docId).get();

    MonthlyBalance oldMB = MonthlyBalance()..fromSnapshot(oldDocSnap);

    isIncome ? oldMB.income += registerValue : oldMB.outcome += registerValue;
    oldMB.docId = docId;

    return await updateMonthlyBalance(monthlyBalance: oldMB);
  }

  //Atualizar Visibilidade do Saldo
  Future updateBalanceVisibility({bool balanceVisible}) async {
    return await _userRef()
        .setData({'balanceVisible': balanceVisible}, merge: true);
  }

  //Editar Saldo
  Future editBalance({int balance}) async {
    return await _userRef().setData({'balance': balance}, merge: true);
  }

  //Editar nome
  Future updateName({String newName}) async {
    return await _userRef().setData({'name': newName}, merge: true);
  }

  //Adicionar post
  Future addRegister({Map<String, dynamic> register}) async {
    return await _userPosts().add(register);
  }

  ///Remover Post:
  ///1º Remover documento; 2º Atualizar Saldo, 3º Atualizar Balanço Mensal
  ///Retorno o saldo atualizado, para futuras exclusões, já que o saldo é
  ///passado por parâmetro e não é atualizado automaticamente
  Future<int> deleteRegister(
      {Register register, int balance, String mbId}) async {
    await _userPosts().document(register.documentID).delete();
    await editBalance(
        balance: register.isIncome()
            ? balance -= register.value
            : balance += register.value);

    var mbSnap = await monthlyBalanceSnap(mbId: mbId);
    if (register.isIncome()) mbSnap.income -= register.value;
    if (!register.isIncome()) mbSnap.outcome -= register.value;

    print("mb > ${mbSnap.docId} ${mbSnap.income} ${mbSnap.outcome}");
    await updateMonthlyBalance(monthlyBalance: mbSnap);
    return balance;
  }
}
