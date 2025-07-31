import 'package:isar/isar.dart';
import '../models/category.dart';

part 'transaction.g.dart';

@collection
class Transaction {
  Id id = Isar.autoIncrement;

  late double amount;
  late String description;
  late DateTime date;

  final category = IsarLink<Category>();
}
