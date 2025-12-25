import '../../domain/entities/booking.dart';
import '../../domain/entities/service.dart';
import 'service_model.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.userId,
    required super.service,
    required super.dateTime,
    required super.status,
    required super.amountPaidRM,
    required super.amountPaidTokens,
    required super.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      service: ServiceModel.fromJson(json['service']),
      dateTime: DateTime.parse(json['date_time'] as String),
      status: _parseBookingStatus(json['status'] as String),
      amountPaidRM: _parseDouble(json['amount_paid_rm']),
      amountPaidTokens: _parseDouble(json['amount_paid_tokens']),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    if (value is num) return value.toDouble();
    return 0.0;
  }

  static BookingStatus _parseBookingStatus(String status) {
    switch (status) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'service': ServiceModel.fromEntity(service).toJson(),
      'dateTime': dateTime.toIso8601String(),
      'status': status.name,
      'amountPaidRM': amountPaidRM,
      'amountPaidTokens': amountPaidTokens,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BookingModel.fromEntity(Booking booking) {
    return BookingModel(
      id: booking.id,
      userId: booking.userId,
      service: booking.service,
      dateTime: booking.dateTime,
      status: booking.status,
      amountPaidRM: booking.amountPaidRM,
      amountPaidTokens: booking.amountPaidTokens,
      createdAt: booking.createdAt,
    );
  }
}
