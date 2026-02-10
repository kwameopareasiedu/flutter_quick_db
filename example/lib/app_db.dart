import 'package:flutter_quick_db/flutter_quick_db.dart';
import 'package:flutter_quick_db_example/models/post.dart';
import 'package:flutter_quick_db_example/models/user.dart';

part "app_db.db.dart";

@QuickDatabase(models: [User, Post])
class AppDatabase {}
