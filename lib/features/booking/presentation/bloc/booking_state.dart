import 'package:equatable/equatable.dart';
import '../../domain/entities/service.dart';
import '../../domain/entities/booking.dart';

class BookingState extends Equatable {
  final List<Service>? services;
  final List<Booking>? bookings;
  final bool isServicesLoading;
  final bool isBookingsLoading;
  final bool isCreatingBooking;
  final String? servicesError;
  final String? bookingsError;
  final Booking? createdBooking;

  const BookingState({
    this.services,
    this.bookings,
    this.isServicesLoading = false,
    this.isBookingsLoading = false,
    this.isCreatingBooking = false,
    this.servicesError,
    this.bookingsError,
    this.createdBooking,
  });

  BookingState copyWith({
    List<Service>? services,
    List<Booking>? bookings,
    bool? isServicesLoading,
    bool? isBookingsLoading,
    bool? isCreatingBooking,
    String? servicesError,
    String? bookingsError,
    Booking? createdBooking,
    bool clearServicesError = false,
    bool clearBookingsError = false,
    bool clearCreatedBooking = false,
  }) {
    return BookingState(
      services: services ?? this.services,
      bookings: bookings ?? this.bookings,
      isServicesLoading: isServicesLoading ?? this.isServicesLoading,
      isBookingsLoading: isBookingsLoading ?? this.isBookingsLoading,
      isCreatingBooking: isCreatingBooking ?? this.isCreatingBooking,
      servicesError: clearServicesError ? null : (servicesError ?? this.servicesError),
      bookingsError: clearBookingsError ? null : (bookingsError ?? this.bookingsError),
      createdBooking: clearCreatedBooking ? null : (createdBooking ?? this.createdBooking),
    );
  }

  @override
  List<Object?> get props => [
        services,
        bookings,
        isServicesLoading,
        isBookingsLoading,
        isCreatingBooking,
        servicesError,
        bookingsError,
        createdBooking,
      ];
}

// Legacy state classes for backward compatibility
class BookingInitial extends BookingState {
  const BookingInitial() : super();
}

class BookingLoading extends BookingState {
  const BookingLoading() : super(isServicesLoading: true);
}

class ServicesLoaded extends BookingState {
  final String? errorMessage;

  const ServicesLoaded(
    List<Service> services, {
    this.errorMessage,
    super.isCreatingBooking = false,
  }) : super(
          services: services,
          servicesError: errorMessage,
        );
}

class ServiceSelected extends BookingState {
  final Service service;

  const ServiceSelected(this.service) : super();

  @override
  List<Object?> get props => [service, ...super.props];
}

class BookingCreated extends BookingState {
  const BookingCreated(Booking booking) : super(createdBooking: booking);

  Booking get booking => createdBooking!;
}

class UserBookingsLoaded extends BookingState {
  const UserBookingsLoaded(List<Booking> bookings) : super(bookings: bookings);
}

class BookingError extends BookingState {
  final String message;
  final bool canRetry;

  const BookingError({
    required this.message,
    this.canRetry = true,
  }) : super();

  @override
  List<Object?> get props => [message, canRetry, ...super.props];
}
