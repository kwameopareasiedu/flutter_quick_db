# Flutter Quick DB

A dead simple Flutter database package built on top of the awesome No-SQL Sembast library, which
offers code generation, simplifying database creation in your Flutter app.

## Features

- No-SQL database
- Class-based annotation setup

## Getting started

Flutter Quick DB uses annotations for setup, hence you need to install the `build_runner` as a dev
dependency in your project.

It is also recommended to install the `path_provider` package to provide a directory for
Flutter Quick DB instance.

## Usage

The sample below shows a complete setup for a database with users and posts collections

`database.dart`

```dart
import "package:flutter_quick_db/flutter_quick_db.dart";

// Don't forget to declare the generated file as part of your file
// Generated files have the {{filename}}.db.dart extension
part "database.db.dart";

class User with DataStoreEntity {
  final String _id;
  final String name;
  final DateTime dob;

  User(this._id, this.name, this.dob);

  /// Required factory constructor to create a user from the saved map
  factory User.fromMap(Map map) {
    return User(map["id"], map["name"], DateTime.parse(map["dob"]));
  }

  /// Override to provide the id of each instance
  /// In this example, it returns the [_id] field
  @override
  String get id => _id;

  /// Override to serialize the instance to a map to be saved in the db
  @override
  Map<String, dynamic> toMap() {
    return {
      "id": _id,
      "name": name,
      "dob": dob.toIso8601String(),
    };
  }

  User copyWith({
    String? _id,
    String? name,
    DateTime? dob,
  }) {
    return User(
      _id ?? this._id,
      name ?? this.name,
      dob ?? this.dob,
    );
  }
}

class Post with DataStoreEntity {
  final String _id;
  final String content;
  final String userId;

  Post(this._id, this.content, this.userId);

  factory Post.fromMap(Map map) {
    return Post(map["id"], map["name"], map["userId"]);
  }

  @override
  String get id => _id;

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": _id,
      "content": content,
      "userId": userId,
    };
  }
}

@QuickDatabase(models = [User, Post], path: "primary.db")
class AppDatabase {}
```

`main.dart`

```dart
import 'package:path_provider/path_provider.dart';
import './database.dart';

void main() async {
  // The generated database class will be named $AppDatabase
  final db = await $AppDatabase.createInstance(getApplicationDocumentsDirectory);

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

After initial setup and subsequent updates to the model files, the `build_runner` must be run to
update the database.

```bash
dart run build_runner build --delete-conflicting-outputs
# or
dart run build_runner build -d
```

## Additional information

Flutter Quick DB is built on top of the [Sembast](https://pub.dev/packages/sembast). I highly
recommend checking out the Sembast docs on using Sembast-related functions.

> Avoid naming your annotated class "Database" since this conflicts with some imports used by the
> generated file
