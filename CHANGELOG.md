## 0.4.0

- Replaced `DataStoreEntity` mixin with `StringDataStore` and `IntDataStore` mixins
- Merged `create(T data)` and `update(T data)` methods into `upsert(T data)` in `DataStore` class
- Replaced `createMany(List<T> data)` method with `upsertMany(List<T> data)` in `DataStore` class

## 0.3.0

- Removed `name` and `path` fields from `@QuickDatabase` annotation
- Changed `model` field of `@QuickDatabase` from a list to a map of store names to types

## 0.2.0

- Added `update` function to `AbstractDataStore` class
- Removed `id` parameter from `AbstractDataStore.create` function

## 0.1.0

- Implemented code generator for `@QuickDatabase` annotation
- Included `example` app for reference