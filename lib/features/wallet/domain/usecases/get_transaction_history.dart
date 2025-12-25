import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/wallet_transaction.dart';
import '../repositories/wallet_repository.dart';

class GetTransactionHistory {
  final WalletRepository repository;

  GetTransactionHistory(this.repository);

  Future<Either<Failure, List<WalletTransaction>>> call(String userId) async {
    return await repository.getTransactionHistory(userId);
  }
}
