import 'package:equatable/equatable.dart';
import '../../../../core/domain/entities/user.dart';

class UserModel extends Equatable implements User {
  @override
  final String id;
  @override
  final String email;
  @override
  final String? name;
  @override
  final String? photoUrl;
  @override
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'] as String,
      name: json['name'] as String?,
      photoUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, email, name, photoUrl, createdAt];
}
