# Flutter Quick DB

A dead simple Flutter database package built on top of the awesome No-SQL Sembast library, which
offers code generation, simplifying database creation in your Flutter app.

## Features

- No-SQL database
- Simple database setup
- Auto-generated database class and stores implementation via annotations

## Getting started

Flutter Quick DB uses annotations for setup, hence you need to install the `build_runner` as a dev
dependency in your project.

> It is also recommended to install the `path_provider` package to provide a directory for
> Flutter Quick DB instance.

## Usage

The sample below shows a complete setup for a database with users and posts collections

`database.dart`

```dart
import "package:flutter_quick_db/flutter_quick_db.dart";

// IMPORTANT! Declare the generated file as part of your file
// Generated files have the {{filename}}.db.dart extension
part "database.db.dart";


/// [User] extends from [StringStoreModel] because its [id] is a string
class User with StringStoreModel {
  /// Required override to provide the id of each instance
  /// In this example, it is the same as the [id] field
  @override
  final String id;

  final String name;
  final DateTime dob;

  User(this.id, this.name, this.dob);

  /// Required factory constructor to create a user from the saved map
  factory User.fromMap(Map map) {
    return User(map["id"], map["name"], DateTime.parse(map["dob"]));
  }

  /// Required override to serialize the instance to a map to be saved in the db
  @override
  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "dob": dob.toIso8601String()};
  }

  User copyWith({ String? id, String? name, DateTime? dob }) {
    return User(id ?? this.id, name ?? this.name, dob ?? this.dob);
  }
}

/// [Post] extends from [IntStoreModel] because its [id] is a int
class Post with IntStoreModel {
  @override
  final int id;

  final String content;
  final String userId;

  Post(this.id, this.content, this.userId);

  factory Post.fromMap(Map map) {
    return Post(map["id"], map["name"], map["userId"]);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "content": content,
      "userId": userId,
    };
  }
}

@QuickDatabase(
  /// [models] is a map of table/store names to class types
  /// This allows you to setup multiple tables/stores with the same type
  models = {
    "users": User,
    "deletedUsers": User,
    "posts": Post
  }
)
class AppDatabase {}
```

`main.dart`

```dart
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import './database.dart';

void main() async {
  // The generated database class will be named $AppDatabase
  final db = await $AppDatabase.createInstance(
    () => getApplicationDocumentsDirectory().then((dir) {
      // Create database in <DOCS_DIR>/main.db
      return File(join(dir.path, "main.db"));
    })
  );

  final user = User("1", "Kwame Opare Asiedu", DateTime.now());
  await db.users.create(user);

  final userKwame = await db.users.get("1");
  final kwamePosts = await db.posts.list(
      Finder(filter: Filter.equals("userId", userKwame.id))
  );
  await db.users.update(user.copyWith(name: "Kwame Asiedu"));

  runApp(/* Flutter app instance */);
}
```

Don't forget to invoke `build_runner` to update the database when models are added/removed from your
database.

```bash
dart run build_runner build --delete-conflicting-outputs
# or
dart run build_runner build -d
```
