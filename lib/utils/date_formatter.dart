class DateFormatter {
  DateTime dateToday;
  DateFormatter({this.dateToday});

  String sliverDate({DateTime today}) {
    return '${today.day} de ${getMonthName(today.month).toLowerCase()}';
  }

  bool isToday(DateTime now, DateTime dateTime) {
    final today = DateTime(now.year, now.month, now.day);
    final registerDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return today == registerDate;
  }

  String getDayName(int weekday) {
    switch (weekday) {
      case 1:
        {
          return 'Segunda-feira';
        }
        break;
      case 2:
        {
          return 'Terça-feira';
        }
        break;
      case 3:
        {
          return 'Quarta-feira';
        }
        break;
      case 4:
        {
          return 'Quinta-feira';
        }
        break;
      case 5:
        {
          return 'Sexta-feira';
        }
        break;
      case 6:
        {
          return 'Sábado';
        }
        break;
      default:
        {
          return 'Domingo';
        }
        break;
    }
  }

  String getMonthName(int month) {
    switch (month) {
      case 1:
        {
          return 'Janeiro';
        }
        break;
      case 2:
        {
          return 'Fevereiro';
        }
        break;
      case 3:
        {
          return 'Março';
        }
        break;
      case 4:
        {
          return 'Abril';
        }
        break;
      case 5:
        {
          return 'Maio';
        }
        break;
      case 6:
        {
          return 'Junho';
        }
        break;
      case 7:
        {
          return 'Julho';
        }
        break;
      case 8:
        {
          return 'Agosto';
        }
        break;
      case 9:
        {
          return 'Setembro';
        }
        break;
      case 10:
        {
          return 'Outubro';
        }
        break;
      case 11:
        {
          return 'Novembro';
        }
        break;
      default:
        {
          return 'Dezembro';
        }
        break;
    }
  }

  String getYearNumber(int year) {
    return year.toString().substring(2);
  }

  String getDayNumber(int day) {
    return day.toString().length == 1 ? '0$day' : day.toString();
  }

  String getMonthNumber(int month) {
    return month.toString().length == 1 ? '0$month' : month.toString();
  }

  String formattedItemDate({DateTime now, DateTime date}) {
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final itemDate = DateTime(date.year, date.month, date.day);

    if (itemDate == today) {
      return 'Hoje';
    } else if (itemDate == yesterday) {
      return 'Ontem';
    } else if (now.year != date.year) {
      return '${getDayNumber(date.day)}/${getMonthNumber(date.month)}/${getYearNumber(date.year)}';
    } else {
      return '${getDayNumber(date.day)}/${getMonthNumber(date.month)}';
    }
  }

  String get monthlyBalanceDocId {
    return '${dateToday.year}${getMonthNumber(dateToday.month)}';
  }
}
