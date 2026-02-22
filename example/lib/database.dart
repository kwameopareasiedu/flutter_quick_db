import 'package:flutter_quick_db/flutter_quick_db.dart';
import 'package:flutter_quick_db_example/models.dart';

part "database.db.dart";

@QuickDatabase(models: {"users": User, "dependents": User, "posts": Post})
class AppDatabase {}
