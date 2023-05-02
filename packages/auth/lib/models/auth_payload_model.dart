// Dart imports:
import 'dart:convert';

class AuthPayloadModel {
  final String fullName;
  final String? facebookId;
  final String? googleId;
  final String? appleId;
  final String? email;
  AuthPayloadModel({
    required this.fullName,
    this.facebookId,
    this.googleId,
    this.appleId,
    this.email,
  });

  AuthPayloadModel copyWith({
    String? fullName,
    String? email,
    String? facebookId,
    String? googleId,
    String? appleId,
  }) {
    return AuthPayloadModel(
      fullName: fullName ?? this.fullName,
      facebookId: facebookId ?? this.facebookId,
      googleId: googleId ?? this.googleId,
      appleId: appleId ?? this.appleId,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, String> result = {
      'fullname': fullName,
    };

    if (googleId != null) {
      result['googleID'] = googleId!;
    }

    if (appleId != null) {
      result['appleID'] = appleId!;
    }

    if (facebookId != null) {
      result['facebookID'] = facebookId!;
    }

    if (email != null) {
      result['email'] = email!;
    }

    return result;
  }

  factory AuthPayloadModel.fromMap(Map<String, dynamic> map) {
    return AuthPayloadModel(
      fullName: map['fullName'] ?? '',
      facebookId: map['facebookId'],
      googleId: map['googleId'],
      appleId: map['appleId'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthPayloadModel.fromJson(String source) =>
      AuthPayloadModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SocialModel(fullName: $fullName, facebookId: $facebookId, googleId: $googleId, appleId: $appleId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthPayloadModel &&
        other.fullName == fullName &&
        other.facebookId == facebookId &&
        other.googleId == googleId &&
        other.appleId == appleId;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
        facebookId.hashCode ^
        googleId.hashCode ^
        appleId.hashCode;
  }
}
