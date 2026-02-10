// dart format width=80
// Generated code - do not modify by hand

part of 'app_db.dart';

// **************************************************************************
// QuickDatabaseGenerator
// **************************************************************************

typedef DirectoryGetter = Future<Directory> Function();

class $AppDatabase {
  final $UserDataStore users;

  $AppDatabase._(Database db) : users = $UserDataStore(db);

  /// Create an instance of the database backed by a file stored in the
  /// directory returned by [getDir].
  ///
  /// This can be the [getApplicationDocumentsDirectory] function from the
  /// [path_provider] package
  static Future<$AppDatabase> createInstance(DirectoryGetter getDir) async {
    final docsDir = await getDir();
    final dbPath = join(docsDir.path, "main.db");
    final sembastDb = await databaseFactoryIo.openDatabase(dbPath);
    return $AppDatabase._(sembastDb);
  }
}

class $UserDataStore extends AbstractDataStore<User> {
  $UserDataStore(Database db) : super(db, "users");

  @override
  User fromMap(Map<String, dynamic> data) {
    return User.fromMap(data);
  }
}
