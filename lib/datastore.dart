part of "flutter_quick_db.dart";

/// Mixes in methods to convert a class to a store model
abstract mixin class _StoreModel<T> {
  /// Returns the unique [id] of this object
  T get id;

  /// Returns a [Map] representation of this object to store in the db
  Map<String, dynamic> toMap();
}

abstract mixin class IntStoreModel implements _StoreModel<int> {}

abstract mixin class StringStoreModel implements _StoreModel<String> {}

/// Base store class which is comparable to a table in an SQL database
abstract class _DataStore<T, Model extends _StoreModel<T>> {
  final Database _db;
  late final StoreRef<T, Map<String, Object?>> _store;

  /// Creates a new data store instance with the specified [name]
  _DataStore(this._db, this._store);

  /// Abstract method to recreate a [Model] from the saved map
  Model fromMap(Map<String, dynamic> data);

  /// Inserts an entry into the store or updates an existing one with the
  /// specified [data]
  Future<bool> upsert(Model data) async {
    await _store.record(data.id).put(_db, data.toMap(), merge: true);
    return true;
  }

  /// Inserts or updates multiple entries into the store
  Future<bool> upsertMany(List<Model> data) async {
    for (final item in data) {
      await upsert(item);
    }

    return true;
  }

  /// Retrieves an entry with the specified [id]
  Future<Model?> get(T id) async {
    final rawData = await _store.record(id).get(_db);
    if (rawData == null) return null;
    return fromMap(rawData);
  }

  /// Retrieves entries matching the given [finder] or all entries if no
  /// [finder] is provided
  Future<List<Model>> list([Finder? finder]) async {
    final rawData = await _store.find(_db, finder: finder);
    return [...rawData.map((snapshot) => fromMap(snapshot.value))];
  }

  /// Returns the count of entries matching the given [finder] or all entries
  /// if no [finder] is provided
  Future<int> count([Filter? filter]) {
    return _store.count(_db, filter: filter);
  }

  /// Removes an entry matching the provided [id]
  Future<void> remove(String id) {
    return _store.delete(_db, finder: Finder(filter: Filter.equals("id", id)));
  }

  /// Clears the entire store
  Future<void> clear() {
    return _store.delete(_db);
  }
}

/// A [_DataStore] whose ids/keys are integers
abstract class IntStore<T extends IntStoreModel> extends _DataStore<int, T> {
  /// Creates a new data store instance with the specified [name]
  IntStore(Database db, String name)
    : super(db, intMapStoreFactory.store(name));
}

/// A [_DataStore] whose ids/keys are strings
abstract class StringStore<T extends StringStoreModel>
    extends _DataStore<String, T> {
  /// Creates a new data store instance with the specified [name]
  StringStore(Database db, String name)
    : super(db, stringMapStoreFactory.store(name));
}

/// An simple wrapper for Sembast's [Database], allowing consumers of this
/// package to name their database classes "Database" without name clashes
class $DatabaseWrapper {
  final Database db;

  $DatabaseWrapper(this.db);
}
