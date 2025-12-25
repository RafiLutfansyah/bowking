import 'package:equatable/equatable.dart';

class PaymentResult extends Equatable {
  final bool success;
  final String? transactionId;
  final double amountPaidRM;
  final double amountPaidTokens;
  final String? errorMessage;

  const PaymentResult({
    required this.success,
    this.transactionId,
    required this.amountPaidRM,
    required this.amountPaidTokens,
    this.errorMessage,
  });

  const PaymentResult.success({
    required String transactionId,
    required double amountPaidRM,
    required double amountPaidTokens,
  }) : this(
          success: true,
          transactionId: transactionId,
          amountPaidRM: amountPaidRM,
          amountPaidTokens: amountPaidTokens,
        );

  const PaymentResult.failure({
    required String errorMessage,
  }) : this(
          success: false,
          errorMessage: errorMessage,
          amountPaidRM: 0,
          amountPaidTokens: 0,
        );

  @override
  List<Object?> get props => [success, transactionId, amountPaidRM, amountPaidTokens, errorMessage];
}
