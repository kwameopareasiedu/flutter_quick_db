// dart format width=80
// Generated code - do not modify by hand

part of 'database.dart';

// **************************************************************************
// QuickDatabaseGenerator
// **************************************************************************

typedef LocationGetter = Future<File> Function();

class $AppDatabase {
  final $UsersStore users;
  final $DependentsStore dependents;
  final $PostsStore posts;

  $AppDatabase._($DatabaseWrapper wrapper)
    : users = $UsersStore(wrapper),
      dependents = $DependentsStore(wrapper),
      posts = $PostsStore(wrapper);

  /// Create an instance of the database backed by a file stored in the
  /// file returned by [getLocation]
  static Future<$AppDatabase> createInstance(LocationGetter getLocation) async {
    final dbPath = await getLocation().then((file) => file.path);
    final sembastDb = await databaseFactoryIo.openDatabase(dbPath);
    return $AppDatabase._($DatabaseWrapper(sembastDb));
  }
}

class $UsersStore extends StringStore<User> {
  $UsersStore($DatabaseWrapper wrapper) : super(wrapper.db, "users");

  @override
  User fromMap(Map<String, dynamic> data) {
    return User.fromMap(data);
  }
}

class $DependentsStore extends StringStore<User> {
  $DependentsStore($DatabaseWrapper wrapper) : super(wrapper.db, "dependents");

  @override
  User fromMap(Map<String, dynamic> data) {
    return User.fromMap(data);
  }
}

class $PostsStore extends IntStore<Post> {
  $PostsStore($DatabaseWrapper wrapper) : super(wrapper.db, "posts");

  @override
  Post fromMap(Map<String, dynamic> data) {
    return Post.fromMap(data);
  }
}
