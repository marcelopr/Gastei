import 'package:flutter/material.dart';

const kPrimaryColor = const Color(0xFF7142ce);
const kPrimaryColorDark = const Color(0xFF552ea5);
const kAccentColor = const Color(0xFF38e4ad);
const kLoginTextFieldColor = const Color(0xFFF5F5F5);
const kToastBackgroundColor = const Color(0xFF636363);
const kOrange = const Color(0xFFf9811e);
const kOrangeLight = const Color(0xFFfca258);
const kBlue = const Color(0xFF0fb9c5);
const kBlueLight = const Color(0xFF4fcfd8);
const kPurple = const Color(0xFF5d74f4);

const kButtonBorderRadius = 12.0;

enum DialogType {
  balanceVisibility,
  editBalance,
  changePassword,
  resetAccount,
  removeAccount,
}

const kAppBarTitleStyle = TextStyle(
  color: Colors.black87,
  fontSize: 18,
  fontWeight: FontWeight.bold,
  fontFamily: 'Quicksand',
);

const kSliverAppBarDetail = TextStyle(
  color: Colors.black54,
  fontWeight: FontWeight.bold,
);

const kListMessageStyle = TextStyle(
  color: Colors.black,
  fontSize: 18,
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: '',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kRegisterTitleStyle = TextStyle(
  fontSize: 17,
);

const kRegisterDateStyle = TextStyle(
  fontSize: 16,
  color: Colors.black38,
);

const kRegisterValueStyle = TextStyle(
  fontSize: 18,
);

const kDrawerHeaderTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 22,
  color: Colors.black,
);

const kDrawerItemTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

const kAppBarBalanceStyle = TextStyle(
  color: Colors.black,
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
);

const kBottomSheetText = TextStyle(
  color: kAccentColor,
  fontSize: 14,
);

const kTextFieldLabel = TextStyle(
  fontSize: 16,
  color: Colors.black45,
  fontWeight: FontWeight.bold,
);

const kLoginTextFieldDecoration = InputDecoration(
  hintText: '',
  hintStyle: kTextFieldHint,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(kButtonBorderRadius)),
    borderSide: BorderSide(
      width: 0,
      style: BorderStyle.none,
    ),
  ),
  filled: true,
  fillColor: kLoginTextFieldColor,
  contentPadding: EdgeInsets.all(16.0),
);

const kTextFieldHint = TextStyle(
  color: Colors.black38,
  fontSize: 16,
);

const kMonthlyBalanceDataTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black38,
);

const Map<int, String> kRegisterTypes = {
  1: 'Saída',
  2: 'Entrada',
};

const Map<int, String> kRegisterCategories = {
  1: 'Outro',
  3: 'Alimentação',
  9: 'Barbeiro',
  4: 'Carro',
  6: 'Cartão de crédito',
  10: 'Compras',
  5: 'Conta',
  15: 'Estudos',
  7: 'Farmácia',
  8: 'Festa',
  2: 'Mercado',
  11: 'Moradia',
  18: 'Presente',
  16: 'Salão',
  12: 'Saúde',
  14: 'Serviço',
  19: 'Trabalho',
  13: 'Transporte',
  17: 'Viagem',
};

//NEW STYLES

const kBalanceTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 26.0,
  fontWeight: FontWeight.w700,
);

const kGreetingsTextStyle = TextStyle(
  fontSize: 26.0,
  fontWeight: FontWeight.w200,
  color: Colors.black,
);

const kMainHeaderTextStyle =
    TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold);

const kLastRegisterInfoTextStyle =
    TextStyle(fontSize: 21.0, color: Colors.white, fontWeight: FontWeight.bold);

const kMonthlyBalanceTextStyle = TextStyle(fontSize: 18.0);

const kCircularPercentTextStyle = TextStyle(
  color: kBlue,
  fontSize: 13.0,
  fontWeight: FontWeight.w500,
);

const kMBInfoHeaderTextStyle = TextStyle(fontSize: 22.0);

const kMBInfoDetails = TextStyle(fontSize: 16.0, color: Colors.black54);

const kFormTextStyle = TextStyle(fontSize: 18.0);
