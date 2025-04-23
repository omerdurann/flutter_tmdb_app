// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductionCountriesModel {
  String? iso31661;
  String? name;
  ProductionCountriesModel({
    this.iso31661,
    this.name,
  });

  ProductionCountriesModel copyWith({
    String? iso31661,
    String? name,
  }) {
    return ProductionCountriesModel(
      iso31661: iso31661 ?? this.iso31661,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'iso_3166_1': iso31661,
      'name': name,
    };
  }

  factory ProductionCountriesModel.fromMap(Map<String, dynamic> map) {
    return ProductionCountriesModel(
      iso31661: map['iso_3166_1'] != null ? map['iso_3166_1'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductionCountriesModel.fromJson(String source) =>
      ProductionCountriesModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ProductionCountriesModel(iso_3166_1: $iso31661, name: $name)';

  @override
  bool operator ==(covariant ProductionCountriesModel other) {
    if (identical(this, other)) return true;

    return other.iso31661 == iso31661 && other.name == name;
  }

  @override
  int get hashCode => iso31661.hashCode ^ name.hashCode;
}
