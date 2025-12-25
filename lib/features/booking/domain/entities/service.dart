import 'package:equatable/equatable.dart';

enum ServiceType { valet, carWash, bayReservation }

enum BookingStatus { pending, confirmed, cancelled, completed }

class Service extends Equatable {
  final String id;
  final String name;
  final ServiceType type;
  final double priceRM;
  final double priceTokens;
  final bool isAvailable;
  final String description;

  const Service({
    required this.id,
    required this.name,
    required this.type,
    required this.priceRM,
    required this.priceTokens,
    required this.isAvailable,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, type, priceRM, priceTokens, isAvailable, description];
}
