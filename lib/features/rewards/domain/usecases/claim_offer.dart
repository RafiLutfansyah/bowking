import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/offer.dart';
import '../repositories/rewards_repository.dart';

class ClaimOffer {
  final RewardsRepository repository;

  ClaimOffer(this.repository);

  Future<Either<Failure, Offer>> call({
    required String userId,
    required String offerId,
  }) async {
    return await repository.claimOffer(
      userId: userId,
      offerId: offerId,
    );
  }
}
