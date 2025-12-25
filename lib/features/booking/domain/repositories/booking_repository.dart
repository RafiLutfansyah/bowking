import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/service.dart';
import '../entities/booking.dart';

abstract class BookingRepository {
  Future<Either<Failure, List<Service>>> getAvailableServices();
  Future<Either<Failure, Service?>> getServiceById(String id);
  Future<Either<Failure, Booking>> createBooking({
    required String userId,
    required Service service,
    required DateTime dateTime,
    required double amountPaidRM,
    required double amountPaidTokens,
  });
  Future<Either<Failure, List<Booking>>> getUserBookings(String userId);
  Future<Either<Failure, Booking>> updateBookingStatus(String bookingId, BookingStatus status);
}
