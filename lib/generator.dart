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

    final dbClassName = "\$${element.name}";
    final dbModelMap = annotation.read("models").mapValue.entries;

    if (dbModelMap.isEmpty) {
      throw "${element.name}, annotated with @QuickDatabase, must specify at least one model type";
    }

    final intStoreModelMixinChecker = TypeChecker.typeNamed(IntStoreModel);
    final stringStoreModelMixinChecker = TypeChecker.typeNamed(
      StringStoreModel,
    );
    final mapTypeChecker = TypeChecker.typeNamed(Map);
    final models = <_ModelData>[];

    for (final entry in dbModelMap) {
      final modelTableName = entry.key!.toStringValue()!;
      final modelElement = entry.value!.toTypeValue()!.element!;

      // Ensure model is a class type
      if (modelElement is! ClassElement) {
        throw "${modelElement.name} is not a class";
      }

      // Ensure model implements the [StoreModel] mixin
      final implementsIntStoreModel = modelElement.mixins.any((mixinType) {
        return intStoreModelMixinChecker.isAssignableFrom(mixinType.element);
      });

      final implementsStringStoreModel = modelElement.mixins.any((mixinType) {
        return stringStoreModelMixinChecker.isAssignableFrom(mixinType.element);
      });

      if (!implementsIntStoreModel && !implementsStringStoreModel) {
        throw "${modelElement.name} must mixin IntStoreModel or StringStoreModel";
      } else if (implementsIntStoreModel && implementsStringStoreModel) {
        throw "${modelElement.name} must mixin only one of IntStoreModel or StringStoreModel";
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

      models.add(
        _ModelData(
          modelElement.name!,
          modelTableName,
          implementsIntStoreModel ? _IdType.int : _IdType.string,
        ),
      );
    }

    final output = <String>[];

    output.add("""
typedef LocationGetter = Future<File> Function();

class $dbClassName {
  ${_generateModelFieldDeclarations(models)}

  $dbClassName._(\$DatabaseWrapper wrapper):
    ${_generateModelConstructorAssignments(models)};

  /// Create an instance of the database backed by a file stored in the 
  /// file returned by [getLocation]
  static Future<$dbClassName> createInstance(LocationGetter getLocation) async {
    final dbPath = await getLocation().then((file) => file.path);
    final sembastDb = await databaseFactoryIo.openDatabase(dbPath);
    return $dbClassName._(\$DatabaseWrapper(sembastDb));
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
  return models.map((model) => model.storeClassDeclaration).join("\n\n");
}

enum _IdType { int, string }

class _ModelData {
  final String className;
  final String storeName;
  final _IdType type;

  _ModelData(this.className, this.storeName, this.type);

  String get storeClassName =>
      "\$${storeName[0].toUpperCase()}${storeName.substring(1)}Store";

  String get storeClassType => switch (type) {
    _IdType.int => "IntStore",
    _IdType.string => "StringStore",
  };

  String get fieldDeclaration => "\tfinal $storeClassName $storeName";

  String get constructorAssignment =>
      "\t\t$storeName = $storeClassName(wrapper)";

  String get storeClassDeclaration {
    return """
class $storeClassName extends $storeClassType<$className> {
  $storeClassName(\$DatabaseWrapper wrapper) : super(wrapper.db, "$storeName");

  @override
  $className fromMap(Map<String, dynamic> data) {
    return $className.fromMap(data);
  }
}
  """;
  }
}
