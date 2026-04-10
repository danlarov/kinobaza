import 'package:kinobaza/movies/domain/entities/cast.dart';

class CastModel extends Cast {
  const CastModel({
    required super.name,
    required super.profileUrl,
    required super.gender,
    super.staffRole = '',
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      name: json['nameRu'] ?? json['nameEn'] ?? 'Неизвестно',
      profileUrl: json['posterUrl'] ?? '',
      gender: json['sex'] == 'MALE' ? 1 : json['sex'] == 'FEMALE' ? 2 : 0,
      staffRole: json['professionKey'] ?? '',
    );
  }
}