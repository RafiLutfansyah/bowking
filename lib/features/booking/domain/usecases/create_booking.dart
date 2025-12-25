import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking.dart';
import '../entities/service.dart';
import '../repositories/booking_repository.dart';

class CreateBooking {
  final BookingRepository repository;

  CreateBooking(this.repository);

  Future<Either<Failure, Booking>> call({
    required String userId,
    required Service service,
    required DateTime dateTime,
    required double amountPaidRM,
    required double amountPaidTokens,
  }) async {
    return await repository.createBooking(
      userId: userId,
      service: service,
      dateTime: dateTime,
      amountPaidRM: amountPaidRM,
      amountPaidTokens: amountPaidTokens,
    );
  }
}
