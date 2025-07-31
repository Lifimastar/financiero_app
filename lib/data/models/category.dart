import 'package:isar/isar.dart';

part 'category.g.dart';

@collection
class Category {
  Id id = Isar.autoIncrement;

  late String name;
  late String icon;
  late String color;

  @enumerated
  late CategoryType type;
}

enum CategoryType { income, expense }
