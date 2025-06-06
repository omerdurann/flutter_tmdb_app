// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SpokenLanguagesModel {
  String? englishName;
  String? iso6391;
  String? name;
  SpokenLanguagesModel({
    this.englishName,
    this.iso6391,
    this.name,
  });

  SpokenLanguagesModel copyWith({
    String? englishName,
    String? iso6391,
    String? name,
  }) {
    return SpokenLanguagesModel(
      englishName: englishName ?? this.englishName,
      iso6391: iso6391 ?? this.iso6391,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'english_name': englishName,
      'iso_639_1': iso6391,
      'name': name,
    };
  }

  factory SpokenLanguagesModel.fromMap(Map<String, dynamic> map) {
    return SpokenLanguagesModel(
      englishName:
          map['english_name'] != null ? map['english_name'] as String : null,
      iso6391: map['iso_639_1'] != null ? map['iso_639_1'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SpokenLanguagesModel.fromJson(String source) =>
      SpokenLanguagesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SpokenLanguagesModel(english_name: $englishName, iso_639_1: $iso6391, name: $name)';

  @override
  bool operator ==(covariant SpokenLanguagesModel other) {
    if (identical(this, other)) return true;

    return other.englishName == englishName &&
        other.iso6391 == iso6391 &&
        other.name == name;
  }

  @override
  int get hashCode => englishName.hashCode ^ iso6391.hashCode ^ name.hashCode;
}
