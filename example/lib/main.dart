import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quick_db_example/database.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  final db = await $AppDatabase.createInstance(
    () => getApplicationDocumentsDirectory().then((dir) {
      return File(join(dir.path, "main.db"));
    }),
  );

  // From here, you can use [appDatabase] however you wish

  runApp(MainApp(db: db));
}

class MainApp extends StatelessWidget {
  final $AppDatabase db;

  const MainApp({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
