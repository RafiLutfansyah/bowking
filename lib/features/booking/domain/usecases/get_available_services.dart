import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/service.dart';
import '../repositories/booking_repository.dart';

class GetAvailableServices {
  final BookingRepository repository;

  GetAvailableServices(this.repository);

  Future<Either<Failure, List<Service>>> call() async {
    return await repository.getAvailableServices();
  }
}
