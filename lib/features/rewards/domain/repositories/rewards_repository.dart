import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/offer.dart';

abstract class RewardsRepository {
  Future<Either<Failure, List<Offer>>> getAvailableOffers();
  Future<Either<Failure, List<Offer>>> getClaimedOffers(String userId);
  Future<Either<Failure, Offer>> claimOffer({
    required String userId,
    required String offerId,
  });
  Future<Either<Failure, Offer>> useVoucher({required String offerId});
}
