import 'package:carteira/models/register.dart';
import 'package:flutter/foundation.dart';

class CategoryExpenses {
  final List<Register> categoryItems;
  final int category;
  final int totalExpended;
  final double percentage;

  CategoryExpenses({
    @required this.categoryItems,
    @required this.category,
    @required this.totalExpended,
    @required this.percentage,
  });
}
