// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductionCompanyModel {
  final int? id;
  final String? logoPath;
  final String? name;
  final String? originCountry;
  ProductionCompanyModel({
    this.id,
    this.logoPath,
    this.name,
    this.originCountry,
  });

  ProductionCompanyModel copyWith({
    int? id,
    String? logoPath,
    String? name,
    String? originCountry,
  }) {
    return ProductionCompanyModel(
      id: id ?? this.id,
      logoPath: logoPath ?? this.logoPath,
      name: name ?? this.name,
      originCountry: originCountry ?? this.originCountry,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'logo_path': logoPath,
      'name': name,
      'origin_country': originCountry,
    };
  }

  factory ProductionCompanyModel.fromMap(Map<String, dynamic> map) {
    return ProductionCompanyModel(
      id: map['id'] != null ? map['id'] as int : null,
      logoPath: map['logo_path'] != null ? map['logo_path'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      originCountry:
          map['origin_country'] != null ? map['origin_country'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductionCompanyModel.fromJson(String source) =>
      ProductionCompanyModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductionCompanyModel(id: $id, logo_path: $logoPath, name: $name, origin_country: $originCountry)';
  }

  @override
  bool operator ==(covariant ProductionCompanyModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.logoPath == logoPath &&
        other.name == name &&
        other.originCountry == originCountry;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        logoPath.hashCode ^
        name.hashCode ^
        originCountry.hashCode;
  }
}
