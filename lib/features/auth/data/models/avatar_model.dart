// ignore_for_file: public_member_api_docs, sort_constructors_first

// Dart imports:
import 'dart:convert';

class AvatarModel {
  final String? id;
  String name;
  String src;
  String location;
  final int version;
  AvatarModel({
    this.id,
    required this.name,
    required this.src,
    required this.location,
    required this.version,
  });

  AvatarModel copyWith({
    String? id,
    String? name,
    String? src,
    String? location,
    int? version,
  }) {
    return AvatarModel(
      id: id ?? this.id,
      name: name ?? this.name,
      src: src ?? this.src,
      location: location ?? this.location,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'src': src,
      'location': location,
    };
  }

  factory AvatarModel.fromMap(Map<String, dynamic> map) {
    return AvatarModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      src: map['src'] ?? '',
      location: map['location'] ?? '',
      version: map['v'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AvatarModel.fromJson(String source) =>
      AvatarModel.fromMap(json.decode(source));

  @override
  String toString() => 'AvatarModel(id: $id, name: $name, src: $src)';

  @override
  bool operator ==(covariant AvatarModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.src == src &&
        other.location == location &&
        other.version == version;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        src.hashCode ^
        location.hashCode ^
        version.hashCode;
  }
}
