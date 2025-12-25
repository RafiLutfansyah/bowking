import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/entities/wallet_transaction.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/remote_wallet_datasource.dart';

class WalletRepositoryImpl implements WalletRepository {
  final RemoteWalletDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WalletRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Wallet>> getWallet(String userId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final wallet = await remoteDataSource.getWallet(userId);
      return Right(wallet);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Wallet>> deductBalance({
    required String userId,
    required double amountRM,
    required double amountTokens,
    required String description,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final wallet = await remoteDataSource.deductBalance(
        userId: userId,
        amountRM: amountRM,
        amountTokens: amountTokens,
        description: description,
      );
      return Right(wallet);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Wallet>> addBalance({
    required String userId,
    required double amountRM,
    required double amountTokens,
    required String description,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final wallet = await remoteDataSource.addBalance(
        userId: userId,
        amountRM: amountRM,
        amountTokens: amountTokens,
        description: description,
      );
      return Right(wallet);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WalletTransaction>>> getTransactionHistory(String userId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final transactions = await remoteDataSource.getTransactionHistory(userId);
      return Right(transactions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
