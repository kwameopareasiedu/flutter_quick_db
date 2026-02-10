import "package:flutter_quick_db/flutter_quick_db.dart";

class Post with DataStoreEntity {
  final String _id;
  final String content;
  final String userId;

  Post(this._id, this.content, this.userId);

  factory Post.fromMap(Map map) {
    return Post(map["id"], map["content"], map["userId"]);
  }

  @override
  String get id => _id;

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }
}
