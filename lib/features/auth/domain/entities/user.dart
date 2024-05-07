// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:waterbus/features/auth/data/models/user_model.dart';

class User {
  final int id;
  final String fullName;
  String userName;
  final String? bio;
  final String? avatar;
  User({
    required this.id,
    required this.fullName,
    required this.userName,
    this.bio,
    this.avatar,
  });

  User copyWith({
    int? id,
    String? fullName,
    String? userName,
    String? avatar,
    String? bio,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'userName': userName,
      'avatar': avatar,
      'bio': bio,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0,
      fullName: map['fullName'] ?? '',
      userName: map['userName'] ?? '',
      bio: map['bio'] ?? '',
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
    );
  }

  factory User.fromUserModel(UserModel userModel) {
    return User(
      id: userModel.id,
      fullName: userModel.fullName,
      userName: userModel.userName,
      avatar: userModel.avatar,
      bio: userModel.bio,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, fullName: $fullName, bio: $bio, userName: $userName, avatar: $avatar)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fullName == fullName &&
        other.bio == bio &&
        other.userName == userName &&
        other.avatar == avatar;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        bio.hashCode ^
        userName.hashCode ^
        avatar.hashCode;
  }
}
