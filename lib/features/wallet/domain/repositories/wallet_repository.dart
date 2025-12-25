import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/wallet.dart';
import '../entities/wallet_transaction.dart';

abstract class WalletRepository {
  Future<Either<Failure, Wallet>> getWallet(String userId);
  Future<Either<Failure, Wallet>> deductBalance({
    required String userId,
    required double amountRM,
    required double amountTokens,
    required String description,
  });
  Future<Either<Failure, Wallet>> addBalance({
    required String userId,
    required double amountRM,
    required double amountTokens,
    required String description,
  });
  Future<Either<Failure, List<WalletTransaction>>> getTransactionHistory(String userId);
}
