part of "flutter_quick_db.dart";

class QuickDatabase {
  final String? name;
  final String path;
  final List<Type> models;

  const QuickDatabase({this.name, this.path = "main.db", required this.models});
}
