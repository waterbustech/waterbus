// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:waterbus/features/auth/data/models/user_model.dart';

class User extends Equatable {
  final String id;
  final String fullName;
  final String userName;
  const User({
    required this.id,
    required this.fullName,
    required this.userName,
  });

  User copyWith({
    String? id,
    String? fullName,
    String? userName,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'fullName': fullName,
      'userName': userName,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String,
      fullName: map['fullName'] as String,
      userName: map['userName'] as String,
    );
  }

  factory User.fromUserModel(UserModel userModel) {
    return User(
      id: userModel.id,
      fullName: userModel.fullName,
      userName: userModel.userName,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, fullName, userName];
}
