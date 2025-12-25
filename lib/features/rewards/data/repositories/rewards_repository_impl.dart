import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/offer.dart';
import '../../domain/repositories/rewards_repository.dart';
import '../datasources/remote_rewards_datasource.dart';

class RewardsRepositoryImpl implements RewardsRepository {
  final RemoteRewardsDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RewardsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Offer>>> getAvailableOffers() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final offers = await remoteDataSource.getAvailableOffers();
      return Right(offers);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Offer>>> getClaimedOffers(String userId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final offers = await remoteDataSource.getClaimedOffers(userId);
      return Right(offers);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Offer>> claimOffer({
    required String userId,
    required String offerId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final offer = await remoteDataSource.claimOffer(
        userId: userId,
        offerId: offerId,
      );
      return Right(offer);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Offer>> useVoucher({required String offerId}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final offer = await remoteDataSource.useVoucher(offerId: offerId);
      return Right(offer);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
