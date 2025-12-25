import '../../domain/entities/offer.dart';

class OfferModel extends Offer {
  const OfferModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.requiredTokens,
    super.expiresAt,
    super.claimedAt,
    super.usedAt,
    required super.isClaimed,
    required super.category,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'].toString(),
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: (json['image_url'] as String?) ?? '',
      requiredTokens: _parseInt(json['required_tokens']),
      expiresAt: json['expires_at'] != null 
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      claimedAt: json['claimed_at'] != null
          ? DateTime.parse(json['claimed_at'] as String)
          : null,
      usedAt: json['used_at'] != null
          ? DateTime.parse(json['used_at'] as String)
          : null,
      isClaimed: json['is_claimed'] ?? false,
      category: json['category'] as String,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        // Handle decimal strings like "50.00"
        return double.parse(value).toInt();
      }
    }
    if (value is num) return value.toInt();
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'requiredTokens': requiredTokens,
      'expiresAt': expiresAt?.toIso8601String(),
      'claimedAt': claimedAt?.toIso8601String(),
      'usedAt': usedAt?.toIso8601String(),
      'isClaimed': isClaimed,
      'category': category,
    };
  }

  factory OfferModel.fromEntity(Offer offer) {
    return OfferModel(
      id: offer.id,
      title: offer.title,
      description: offer.description,
      imageUrl: offer.imageUrl,
      requiredTokens: offer.requiredTokens,
      expiresAt: offer.expiresAt,
      claimedAt: offer.claimedAt,
      usedAt: offer.usedAt,
      isClaimed: offer.isClaimed,
      category: offer.category,
    );
  }
}
