import 'package:equatable/equatable.dart';
import '../../domain/entities/service.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class LoadServices extends BookingEvent {}

class SelectService extends BookingEvent {
  final Service service;

  const SelectService(this.service);

  @override
  List<Object?> get props => [service];
}

class CreateBookingEvent extends BookingEvent {
  final String userId;
  final Service service;
  final DateTime dateTime;
  final double amountPaidRM;
  final double amountPaidTokens;

  const CreateBookingEvent({
    required this.userId,
    required this.service,
    required this.dateTime,
    required this.amountPaidRM,
    required this.amountPaidTokens,
  });

  @override
  List<Object?> get props => [userId, service, dateTime, amountPaidRM, amountPaidTokens];
}

class LoadUserBookings extends BookingEvent {
  final String userId;

  const LoadUserBookings(this.userId);

  @override
  List<Object?> get props => [userId];
}

class StartBookingStatusPolling extends BookingEvent {
  final String bookingId;

  const StartBookingStatusPolling(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

class UpdateBookingStatus extends BookingEvent {
  final String status;

  const UpdateBookingStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class StopBookingStatusPolling extends BookingEvent {
  const StopBookingStatusPolling();
}
