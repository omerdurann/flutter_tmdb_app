// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GenresModel {
  int? id;
  String? name;
  GenresModel({
    this.id,
    this.name,
  });

  GenresModel copyWith({
    int? id,
    String? name,
  }) {
    return GenresModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory GenresModel.fromMap(Map<String, dynamic> map) {
    return GenresModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GenresModel.fromJson(String source) =>
      GenresModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GenresModel(id: $id, name: $name)';

  @override
  bool operator ==(covariant GenresModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
