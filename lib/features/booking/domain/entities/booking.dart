import 'package:equatable/equatable.dart';
import 'service.dart';

class Booking extends Equatable {
  final String id;
  final String userId;
  final Service service;
  final DateTime dateTime;
  final BookingStatus status;
  final double amountPaidRM;
  final double amountPaidTokens;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.service,
    required this.dateTime,
    required this.status,
    required this.amountPaidRM,
    required this.amountPaidTokens,
    required this.createdAt,
  });

  Booking copyWith({
    String? id,
    String? userId,
    Service? service,
    DateTime? dateTime,
    BookingStatus? status,
    double? amountPaidRM,
    double? amountPaidTokens,
    DateTime? createdAt,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      service: service ?? this.service,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      amountPaidRM: amountPaidRM ?? this.amountPaidRM,
      amountPaidTokens: amountPaidTokens ?? this.amountPaidTokens,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, service, dateTime, status, amountPaidRM, amountPaidTokens, createdAt];
}
