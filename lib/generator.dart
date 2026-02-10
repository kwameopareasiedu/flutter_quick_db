import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:flutter_quick_db/flutter_quick_db.dart';
import 'package:source_gen/source_gen.dart';

class QuickDatabaseGenerator extends GeneratorForAnnotation<QuickDatabase> {
  @override
  dynamic generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw "@QuickDatabase targets must be a class (${element.name})";
    }

    final dbClassName = !annotation.read("name").isNull
        ? annotation.read("name").stringValue
        : "\$${element.name}";

    final dbFilePath = annotation.read("path").stringValue;

    final dbModelClassElements = annotation
        .read("models")
        .listValue
        .map((dartObj) => dartObj.toTypeValue()!.element!)
        .toList(growable: false);

    if (dbModelClassElements.isEmpty) {
      throw "${element.name}, annotated with @QuickDatabase, must specify at least one model type";
    }

    final dataStoreEntityMixinChecker = TypeChecker.typeNamed(DataStoreEntity);
    final mapTypeChecker = TypeChecker.typeNamed(Map);
    final models = <_ModelData>[];

    for (final modelElement in dbModelClassElements) {
      // Ensure model is a class type
      if (modelElement is! ClassElement) {
        throw "${modelElement.name} is not a class";
      }

      // Ensure model implements the [DataStoreEntity] mixin
      final implementsDataStoreEntity = modelElement.mixins.any((mixinType) {
        return dataStoreEntityMixinChecker.isAssignableFrom(mixinType.element);
      });

      if (!implementsDataStoreEntity) {
        throw "${modelElement.name} must implement DataStoreEntity mixin";
      }

      // Ensure model has a factory [fromMap] method which accepts a Map object
      final fromMapConstructorElement = modelElement.getNamedConstructor(
        "fromMap",
      );

      final fromMapParameters = fromMapConstructorElement?.formalParameters;

      if (fromMapConstructorElement?.isFactory != true ||
          fromMapParameters!.length != 1 ||
          !mapTypeChecker.isAssignableFromType(fromMapParameters.first.type)) {
        throw "${modelElement.name} must have a 'fromMap' factory constructor which accepts a single Map object";
      }

      models.add(_ModelData(modelElement.name!));
    }

    final output = <String>[];

    output.add("""
typedef DirectoryGetter = Future<Directory> Function();

class $dbClassName {
  ${_generateModelFieldDeclarations(models)}

  $dbClassName._(Database db):
    ${_generateModelConstructorAssignments(models)};

  /// Create an instance of the database backed by a file stored in the 
  /// directory returned by [getDir].
  ///
  /// This can be the [getApplicationDocumentsDirectory] function from the 
  /// [path_provider] package
  static Future<$dbClassName> createInstance(DirectoryGetter getDir) async {
    final docsDir = await getDir();
    final dbPath = join(docsDir.path, "$dbFilePath");
    final sembastDb = await databaseFactoryIo.openDatabase(dbPath);
    return $dbClassName._(sembastDb);
  }
}

${_generateModelStoreClassDeclarations(models)}
    """);

    return output.join("\n");
  }
}

String _generateModelFieldDeclarations(List<_ModelData> models) {
  return models.map((model) => "${model.fieldDeclaration};").join("\n");
}

String _generateModelConstructorAssignments(List<_ModelData> models) {
  return models.map((model) => model.constructorAssignment).join(",\n");
}

String _generateModelStoreClassDeclarations(List<_ModelData> models) {
  return models.map((model) => model.dataStoreClassDeclaration).join("\n\n");
}

class _ModelData {
  final String className;

  _ModelData(this.className);

  String get tableName => "${className.toLowerCase()}s";

  String get storeClassName => "\$${className}DataStore";

  String get fieldDeclaration => "\tfinal $storeClassName $tableName";

  String get constructorAssignment => "\t\t$tableName = $storeClassName(db)";

  String get dataStoreClassDeclaration =>
      """
class $storeClassName extends AbstractDataStore<$className> {
  $storeClassName(Database db) : super(db, "$tableName");

  @override
  $className fromMap(Map<String, dynamic> data) {
    return $className.fromMap(data);
  }
}
  """;
}
