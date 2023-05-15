// Dart imports:
import 'dart:convert';

class TokenModel {
  final String accessToken;
  final String refreshToken;
  TokenModel({
    required this.accessToken,
    required this.refreshToken,
  });

  TokenModel copyWith({
    String? accessToken,
    String? refreshToken,
  }) {
    return TokenModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  factory TokenModel.fromMap(Map<String, dynamic> map) {
    return TokenModel(
      accessToken: map['accessToken'] as String,
      refreshToken: map['refreshToken'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TokenModel.fromJson(String source) => TokenModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TokenModel(accessToken: $accessToken, refreshToken: $refreshToken)';

  @override
  bool operator ==(covariant TokenModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.accessToken == accessToken &&
      other.refreshToken == refreshToken;
  }

  @override
  int get hashCode => accessToken.hashCode ^ refreshToken.hashCode;
}
