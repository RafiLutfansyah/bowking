import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_available_services.dart';
import '../../domain/usecases/create_booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/entities/service.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetAvailableServices getAvailableServices;
  final CreateBooking createBooking;
  final BookingRepository bookingRepository;
  
  Timer? _pollingTimer;
  int _pollCount = 0;

  BookingBloc({
    required this.getAvailableServices,
    required this.createBooking,
    required this.bookingRepository,
  }) : super(const BookingState()) {
    on<LoadServices>(_onLoadServices);
    on<SelectService>(_onSelectService);
    on<CreateBookingEvent>(_onCreateBooking);
    on<LoadUserBookings>(_onLoadUserBookings);
    on<StartBookingStatusPolling>(_onStartPolling);
    on<UpdateBookingStatus>(_onUpdateBookingStatus);
    on<StopBookingStatusPolling>(_onStopPolling);
  }

  Future<void> _onLoadServices(
    LoadServices event,
    Emitter<BookingState> emit,
  ) async {
    if (state.isServicesLoading) return;
    
    emit(state.copyWith(isServicesLoading: true, clearServicesError: true));
    final result = await getAvailableServices();
    result.fold(
      (failure) => emit(state.copyWith(
        isServicesLoading: false,
        servicesError: failure.message,
      )),
      (services) => emit(state.copyWith(
        isServicesLoading: false,
        services: services,
      )),
    );
  }

  Future<void> _onSelectService(
    SelectService event,
    Emitter<BookingState> emit,
  ) async {
    emit(ServiceSelected(event.service));
  }

  Future<void> _onCreateBooking(
    CreateBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(isCreatingBooking: true, clearServicesError: true));
    
    final result = await createBooking(
      userId: event.userId,
      service: event.service,
      dateTime: event.dateTime,
      amountPaidRM: event.amountPaidRM,
      amountPaidTokens: event.amountPaidTokens,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isCreatingBooking: false,
        servicesError: failure.message,
      )),
      (booking) {
        emit(state.copyWith(
          isCreatingBooking: false,
          createdBooking: booking,
        ));
        add(StartBookingStatusPolling(booking.id));
      },
    );
  }

  Future<void> _onLoadUserBookings(
    LoadUserBookings event,
    Emitter<BookingState> emit,
  ) async {
    if (state.isBookingsLoading) return;
    
    emit(state.copyWith(isBookingsLoading: true, clearBookingsError: true));
    final result = await bookingRepository.getUserBookings(event.userId);
    result.fold(
      (failure) => emit(state.copyWith(
        isBookingsLoading: false,
        bookingsError: failure.message,
      )),
      (bookings) => emit(state.copyWith(
        isBookingsLoading: false,
        bookings: bookings,
      )),
    );
  }

  Future<void> _onStartPolling(
    StartBookingStatusPolling event,
    Emitter<BookingState> emit,
  ) async {
    // Cancel any existing timer
    _pollingTimer?.cancel();
    _pollCount = 0;

    // Start polling every 5 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // Simulate status progression:
      // 0-5s: pending
      // 5-15s: confirmed
      // 15s+: completed
      String status;
      if (_pollCount < 1) {
        status = 'pending';
      } else if (_pollCount < 3) {
        status = 'confirmed';
      } else {
        status = 'completed';
        // Stop polling when completed
        _pollingTimer?.cancel();
        _pollingTimer = null;
      }

      _pollCount++;
      add(UpdateBookingStatus(status));
    });
  }

  Future<void> _onUpdateBookingStatus(
    UpdateBookingStatus event,
    Emitter<BookingState> emit,
  ) async {
    final currentBooking = state.createdBooking;
    if (currentBooking != null) {
      final updatedBooking = currentBooking.copyWith(status: BookingStatus.pending);
      emit(state.copyWith(createdBooking: updatedBooking));
    }
  }

  Future<void> _onStopPolling(
    StopBookingStatusPolling event,
    Emitter<BookingState> emit,
  ) async {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _pollCount = 0;
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    return super.close();
  }
}
