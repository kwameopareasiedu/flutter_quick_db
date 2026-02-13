// dart format width=80
// Generated code - do not modify by hand

part of 'app_db.dart';

// **************************************************************************
// QuickDatabaseGenerator
// **************************************************************************

typedef LocationGetter = Future<File> Function();

class $AppDatabase {
  final $UsersDataStore users;
  final $DependentsDataStore dependents;
  final $PostsDataStore posts;

  $AppDatabase._(Database db)
    : users = $UsersDataStore(db),
      dependents = $DependentsDataStore(db),
      posts = $PostsDataStore(db);

  /// Create an instance of the database backed by a file stored in the
  /// file returned by [getLocation]
  static Future<$AppDatabase> createInstance(LocationGetter getLocation) async {
    final dbPath = await getLocation().then((file) => file.path);
    final sembastDb = await databaseFactoryIo.openDatabase(dbPath);
    return $AppDatabase._(sembastDb);
  }
}

class $UsersDataStore extends AbstractDataStore<User> {
  $UsersDataStore(Database db) : super(db, "users");

  @override
  User fromMap(Map<String, dynamic> data) {
    return User.fromMap(data);
  }
}

class $DependentsDataStore extends AbstractDataStore<User> {
  $DependentsDataStore(Database db) : super(db, "dependents");

  @override
  User fromMap(Map<String, dynamic> data) {
    return User.fromMap(data);
  }
}

class $PostsDataStore extends AbstractDataStore<Post> {
  $PostsDataStore(Database db) : super(db, "posts");

  @override
  Post fromMap(Map<String, dynamic> data) {
    return Post.fromMap(data);
  }
}
