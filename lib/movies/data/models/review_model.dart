import 'package:kinobaza/movies/domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.authorName,
    required super.authorUserName,
    required super.avatarUrl,
    required super.rating,
    required super.content,
    required super.elapsedTime,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      authorName: json['reviewAutor'] ?? 'Аноним',
      authorUserName: '@${json['reviewAutor'] ?? 'аноним'}',
      avatarUrl: '',
      rating: -1,
      content: json['reviewDescription'] ?? '',
      elapsedTime: json['reviewData'] ?? '',
    );
  }
}