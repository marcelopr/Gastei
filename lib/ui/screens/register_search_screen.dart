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
          if (query.trim().isEmpty) {
            _message(context, 'Informe o título do registro');
          } else {
            showResults(context);
          }
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
          return _message(context,
              'Nenhum registro com o título "${query.trim()}" encontrado.');
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
  String get searchFieldLabel => 'Título do registro';

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: theme.primaryColor,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme,
    );
  }

  _removeRegister(Register register) async {
    FirestoreService _firestore = FirestoreService(uid: userData.uid);
    var updatedBalance = await _firestore.deleteRegister(
        register: register,
        balance: userData.balance,
        mbId: DateFormatter(dateToday: register.date).monthlyBalanceDocId);
    userData.setBalance(updatedBalance);
    listUpdate = "updated";
  }

  Widget _message(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body1,
        ),
      ),
    );
  }
}
