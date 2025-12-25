import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/offer.dart';
import '../repositories/rewards_repository.dart';

class GetAvailableOffers {
  final RewardsRepository repository;

  GetAvailableOffers(this.repository);

  Future<Either<Failure, List<Offer>>> call() async {
    return await repository.getAvailableOffers();
  }
}
