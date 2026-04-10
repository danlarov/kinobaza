import 'package:equatable/equatable.dart';

class Cast extends Equatable {
  final String name;
  final String profileUrl;
  final int gender;
  final String staffRole;

  const Cast({
    required this.name,
    required this.profileUrl,
    required this.gender,
    this.staffRole = '',
  });

  @override
  List<Object?> get props => [name, profileUrl, gender, staffRole];
}