import '../../domain/entities/service.dart';

class ServiceModel extends Service {
  const ServiceModel({
    required super.id,
    required super.name,
    required super.type,
    required super.priceRM,
    required super.priceTokens,
    required super.isAvailable,
    required super.description,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'].toString(),
      name: json['name'] as String,
      type: _parseServiceType(json['type'] as String),
      priceRM: _parseDouble(json['price_rm']),
      priceTokens: _parseDouble(json['price_tokens']),
      isAvailable: json['is_available'] as bool,
      description: json['description'] as String? ?? '',
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    if (value is num) return value.toDouble();
    return 0.0;
  }

  static ServiceType _parseServiceType(String type) {
    switch (type) {
      case 'valet':
        return ServiceType.valet;
      case 'car_wash':
        return ServiceType.carWash;
      case 'bay_reservation':
        return ServiceType.bayReservation;
      default:
        return ServiceType.valet;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'priceRM': priceRM,
      'priceTokens': priceTokens,
      'isAvailable': isAvailable,
      'description': description,
    };
  }

  factory ServiceModel.fromEntity(Service service) {
    return ServiceModel(
      id: service.id,
      name: service.name,
      type: service.type,
      priceRM: service.priceRM,
      priceTokens: service.priceTokens,
      isAvailable: service.isAvailable,
      description: service.description,
    );
  }
}
