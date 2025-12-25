import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/service.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/remote_booking_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  final RemoteBookingDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  BookingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Service>>> getAvailableServices() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final services = await remoteDataSource.getAvailableServices();
      return Right(services);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Service?>> getServiceById(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final service = await remoteDataSource.getServiceById(id);
      return Right(service);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Booking>> createBooking({
    required String userId,
    required Service service,
    required DateTime dateTime,
    required double amountPaidRM,
    required double amountPaidTokens,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final booking = await remoteDataSource.createBooking(
        userId: userId,
        service: service,
        dateTime: dateTime,
        amountPaidRM: amountPaidRM,
        amountPaidTokens: amountPaidTokens,
      );
      return Right(booking);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getUserBookings(String userId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final bookings = await remoteDataSource.getUserBookings(userId);
      return Right(bookings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Booking>> updateBookingStatus(String bookingId, BookingStatus status) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final booking = await remoteDataSource.updateBookingStatus(bookingId, status);
      return Right(booking);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
