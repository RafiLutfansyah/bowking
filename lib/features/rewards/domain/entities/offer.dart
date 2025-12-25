import 'package:equatable/equatable.dart';

class Offer extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int requiredTokens;
  final DateTime? expiresAt;
  final DateTime? claimedAt;
  final DateTime? usedAt;
  final bool isClaimed;
  final String category;

  const Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.requiredTokens,
    this.expiresAt,
    this.claimedAt,
    this.usedAt,
    required this.isClaimed,
    required this.category,
  });

  Offer copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    int? requiredTokens,
    DateTime? expiresAt,
    DateTime? claimedAt,
    DateTime? usedAt,
    bool? isClaimed,
    String? category,
  }) {
    return Offer(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      requiredTokens: requiredTokens ?? this.requiredTokens,
      expiresAt: expiresAt ?? this.expiresAt,
      claimedAt: claimedAt ?? this.claimedAt,
      usedAt: usedAt ?? this.usedAt,
      isClaimed: isClaimed ?? this.isClaimed,
      category: category ?? this.category,
    );
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get isUsed => usedAt != null;

  Duration? get timeRemaining {
    if (expiresAt == null || isExpired) return null;
    return expiresAt!.difference(DateTime.now());
  }

  @override
  List<Object?> get props => [id, title, description, imageUrl, requiredTokens, expiresAt, claimedAt, usedAt, isClaimed, category];
}
