import "package:flutter_quick_db/flutter_quick_db.dart";

class User with StringStoreModel {
  @override
  final String id;

  final String name;
  final String address;
  final DateTime dob;

  User(this.id, this.name, this.address, this.dob);

  factory User.fromMap(Map map) {
    return User(
      map["id"],
      map["name"],
      map["address"],
      DateTime.parse(map["dob"]),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "address": address,
      "dob": dob.toIso8601String(),
    };
  }
}

class Post with IntStoreModel {
  final int postId;
  final String content;
  final String userId;

  Post(this.postId, this.content, this.userId);

  factory Post.fromMap(Map map) {
    return Post(map["id"], map["content"], map["userId"]);
  }

  @override
  int get id => postId;

  @override
  Map<String, dynamic> toMap() {
    return {"id": postId, "content": content, "userId": userId};
  }
}
