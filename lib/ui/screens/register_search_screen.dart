import 'package:carteira/constants/constants.dart';
import 'package:carteira/models/register.dart';
import 'package:carteira/models/user.dart';
import 'package:carteira/services/firestore.dart';
import 'package:carteira/ui/widgets/loading_indicator.dart';
import 'package:carteira/ui/widgets/register_item.dart';
import 'package:carteira/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterSearch extends SearchDelegate<String> {
  RegisterSearch({@required this.dateToday, @required this.userData});

  final DateTime dateToday;
  final UserData userData;

  String listUpdate;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          showResults(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, listUpdate);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: FirestoreService(uid: Provider.of<User>(context).uid)
          .registerSearchStream(search: query.trim().toLowerCase()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingIndicator();
        }
        if (snapshot.data.documents.isEmpty) {
          return _message(context);
        } else {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              Register register = Register()
                ..fromSnapshot(
                  snapshot.data.documents[index],
                );

              return RegisterItem(
                dateToday: dateToday,
                register: register,
                onRemove: _removeRegister,
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  String get searchFieldLabel => 'Digite o título do registro';

  _removeRegister(Register register) async {
    FirestoreService _firestore = FirestoreService(uid: userData.uid);
    var updatedBalance = await _firestore.deleteRegister(
        register: register,
        balance: userData.balance,
        mbId: DateFormatter(dateToday: register.date).monthlyBalanceDocId);
    userData.setBalance(updatedBalance);
    listUpdate = "updated";
  }

  Widget _message(BuildContext context) {
    return Center(
      child: Text(
        'Nenhum resultado para \'${query.trim()}\'.',
        style: Theme.of(context).textTheme.body1,
      ),
    );
  }
}
