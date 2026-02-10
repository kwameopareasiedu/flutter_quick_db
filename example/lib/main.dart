import 'package:flutter/material.dart';
import 'package:flutter_quick_db_example/app_db.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  final appDatabase = await $AppDatabase.createInstance(
    getApplicationDocumentsDirectory,
  );

  // From here, you can use [appDatabase] however you wish

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
