import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/wallet.dart';
import '../repositories/wallet_repository.dart';

class GetWallet {
  final WalletRepository repository;

  GetWallet(this.repository);

  Future<Either<Failure, Wallet>> call(String userId) async {
    return await repository.getWallet(userId);
  }
}
