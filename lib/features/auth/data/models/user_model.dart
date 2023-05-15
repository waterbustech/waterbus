// ignore_for_file: public_member_api_docs, sort_constructors_first

// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:waterbus/features/auth/data/models/avatar_model.dart';
import 'package:waterbus/features/auth/data/models/token_model.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';

class UserModel {
  final String id;
  final String userName;
  final String fullName;
  final TokenModel? token;
  final AvatarModel? avatar;
  UserModel({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.token,
    required this.avatar,
  });

  UserModel copyWith({
    String? id,
    String? userName,
    String? fullName,
    AvatarModel? avatar,
    TokenModel? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      token: token ?? this.token,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'userName': userName,
      'fullName': fullName,
      'accessToken': token?.accessToken,
      'refreshToken': token?.refreshToken,
      'avatar': avatar?.toMap(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] ?? '',
      userName: map['userName'] ?? '',
      fullName: map['fullName'] ?? '',
      token: TokenModel.fromMap(map),
      avatar: map['avatar'] != null
          ? AvatarModel.fromMap(map['avatar'] as Map<String, dynamic>)
          : null,
    );
  }

  factory UserModel.fromMapRemote(Map<String, dynamic> map) {
    return UserModel(
      id: map['user']['_id'] ?? '',
      userName: map['user']['userName'] ?? '',
      fullName: map['user']['fullName'] ?? '',
      token: TokenModel.fromMap(map),
      avatar: map['user']['avatar'] != null
          ? AvatarModel.fromMap(map['user']['avatar'] as Map<String, dynamic>)
          : null,
    );
  }

  factory UserModel.fromUserEntity(User user) {
    return UserModel(
      id: user.id,
      userName: user.userName,
      fullName: user.fullName,
      token: null,
      avatar: null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userName == userName &&
        other.fullName == fullName &&
        other.token == token &&
        other.avatar == avatar;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userName.hashCode ^
        fullName.hashCode ^
        token.hashCode ^
        avatar.hashCode;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, userName: $userName, fullName: $fullName, token: $token, avatar: $avatar)';
  }
}
