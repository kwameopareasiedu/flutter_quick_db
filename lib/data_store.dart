part of "flutter_quick_db.dart";

mixin DataStoreEntity {
  /// Returns the unique [id] of this object
  String get id;

  /// Returns a [Map] representation of this object to store in the db
  Map<String, dynamic> toMap();
}

/// Base class for a model data store.
abstract class AbstractDataStore<T extends DataStoreEntity> {
  final Database _db;
  late final StoreRef<String, Map<String, Object?>> _store;

  /// Creates a new data store instance with the specified [name]
  AbstractDataStore(this._db, String name) {
    _store = stringMapStoreFactory.store(name);
  }

  T fromMap(Map<String, dynamic> data);

  /// Insert a new entry into the store with the specified [id] and [data]
  Future<bool> create(String id, T data) async {
    await _store.record(id).put(_db, data.toMap(), merge: true);
    return true;
  }

  /// Insert multiple entries into the store
  Future<bool> createMany(List<T> data) async {
    for (final item in data) {
      await create(item.id, item);
    }

    return true;
  }

  /// Retrieves an entry with the specified [id]
  Future<T?> get(String id) async {
    final rawData = await _store.record(id).get(_db);
    if (rawData == null) return null;
    return fromMap(rawData);
  }

  /// Retrieves entries matching the given [finder] or all entries if no
  /// [finder] is provided
  Future<List<T>> list([Finder? finder]) async {
    final rawData = await _store.find(_db, finder: finder);
    return [...rawData.map((snapshot) => fromMap(snapshot.value))];
  }

  /// Counts entries matching the given [finder] or all entries if no
  /// [finder] is provided
  Future<int> count([Filter? filter]) {
    return _store.count(_db, filter: filter);
  }

  /// Removes an entry matching the provided [id]
  Future<void> remove(String id) {
    return _store.delete(_db, finder: Finder(filter: Filter.equals("id", id)));
  }

  /// Clears the store
  Future<void> clear() {
    return _store.delete(_db);
  }
}
