import 'package:dartz/dartz.dart';
import '../../error/failures.dart';
import 'payment_method.dart';
import 'payment_result.dart';
import 'user_balance.dart';

abstract class PaymentRepository {
  Future<Either<Failure, UserBalance>> getUserBalance(String userId);
  
  Future<Either<Failure, PaymentResult>> processPayment({
    required String userId,
    required PaymentMethod paymentMethod,
    required String description,
  });
}
