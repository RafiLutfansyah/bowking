import 'package:equatable/equatable.dart';
import '../../domain/payment/user_balance.dart';
import '../../domain/payment/payment_result.dart';

class PaymentState extends Equatable {
  final UserBalance? balance;
  final bool isLoadingBalance;
  final String? balanceError;
  final bool isProcessingPayment;
  final PaymentResult? lastPaymentResult;

  const PaymentState({
    this.balance,
    this.isLoadingBalance = false,
    this.balanceError,
    this.isProcessingPayment = false,
    this.lastPaymentResult,
  });

  PaymentState copyWith({
    UserBalance? balance,
    bool? isLoadingBalance,
    String? balanceError,
    bool clearBalanceError = false,
    bool? isProcessingPayment,
    PaymentResult? lastPaymentResult,
    bool clearLastPaymentResult = false,
  }) {
    return PaymentState(
      balance: balance ?? this.balance,
      isLoadingBalance: isLoadingBalance ?? this.isLoadingBalance,
      balanceError: clearBalanceError ? null : (balanceError ?? this.balanceError),
      isProcessingPayment: isProcessingPayment ?? this.isProcessingPayment,
      lastPaymentResult: clearLastPaymentResult ? null : (lastPaymentResult ?? this.lastPaymentResult),
    );
  }

  @override
  List<Object?> get props => [
        balance,
        isLoadingBalance,
        balanceError,
        isProcessingPayment,
        lastPaymentResult,
      ];
}
