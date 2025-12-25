import 'package:dartz/dartz.dart';
import '../../../../core/domain/payment/payment_method.dart';
import '../../../../core/domain/payment/payment_repository.dart';
import '../../../../core/domain/payment/payment_result.dart';
import '../../../../core/domain/payment/user_balance.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/wallet_repository.dart';

class WalletPaymentAdapter implements PaymentRepository {
  final WalletRepository walletRepository;

  WalletPaymentAdapter({required this.walletRepository});

  @override
  Future<Either<Failure, UserBalance>> getUserBalance(String userId) async {
    final result = await walletRepository.getWallet(userId);
    return result.fold(
      (failure) => Left(failure),
      (wallet) => Right(UserBalance(
        balanceRM: wallet.balanceRM,
        balanceTokens: wallet.balanceTokens,
      )),
    );
  }

  @override
  Future<Either<Failure, PaymentResult>> processPayment({
    required String userId,
    required PaymentMethod paymentMethod,
    required String description,
  }) async {
    if (!paymentMethod.isValid) {
      return const Left(ValidationFailure('Invalid payment method'));
    }

    final result = await walletRepository.deductBalance(
      userId: userId,
      amountRM: paymentMethod.amountRM,
      amountTokens: paymentMethod.amountTokens,
      description: description,
    );

    return result.fold(
      (failure) => Right(PaymentResult.failure(errorMessage: failure.message)),
      (wallet) => Right(PaymentResult.success(
        transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
        amountPaidRM: paymentMethod.amountRM,
        amountPaidTokens: paymentMethod.amountTokens,
      )),
    );
  }
}
