import 'package:intl/intl.dart';

class CurrencyFormatter {
  String realSign(int value) {
    final _realFormat = new NumberFormat("#,##0.00", "pt_BRL");
    return '${_realFormat.format(value)}';
  }
}
