import 'package:build/build.dart';
import 'package:flutter_quick_db/codegen/generator.dart';
import 'package:source_gen/source_gen.dart';

export 'package:flutter_quick_db/codegen/annotations.dart';
export 'package:flutter_quick_db/data_store.dart';
export 'package:sembast/sembast_io.dart' show Database, databaseFactoryIo;

Builder buildDb(BuilderOptions options) {
  return PartBuilder(
    [QuickDatabaseGenerator()],
    ".g.dart",
    header: "// Generated code - do not modify by hand\n\n",
  );
}
