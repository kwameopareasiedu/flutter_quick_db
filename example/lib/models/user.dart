import "package:flutter_quick_db/flutter_quick_db.dart";

class User with DataStoreEntity {
  final String _id;
  final String name;
  final String address;
  final String _dob;

  User(this._id, this.name, this.address, this._dob);

  factory User.fromMap(Map map) {
    return User(map["id"], map["name"], map["address"], map["dob"]);
  }

  @override
  String get id => _id;

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }
}
