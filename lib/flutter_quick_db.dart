import 'package:build/build.dart';
import 'package:flutter_quick_db/generator.dart';
import 'package:sembast/sembast.dart';
import 'package:source_gen/source_gen.dart';

export 'dart:io' show File;

export 'package:sembast/sembast_io.dart'
    show Boundary, Database, databaseFactoryIo, Finder, Filter, SortOrder;

part "annotations.dart";
part "data_store.dart";

Builder buildDb(BuilderOptions options) {
  return PartBuilder(
    [QuickDatabaseGenerator()],
    ".db.dart",
    header: "// Generated code - do not modify by hand\n\n",
  );
}
