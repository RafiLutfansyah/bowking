import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/offer.dart';
import '../repositories/rewards_repository.dart';

class GetClaimedOffers {
  final RewardsRepository repository;

  GetClaimedOffers(this.repository);

  Future<Either<Failure, List<Offer>>> call(String userId) async {
    return await repository.getClaimedOffers(userId);
  }
}
