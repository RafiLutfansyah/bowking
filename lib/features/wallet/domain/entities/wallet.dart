import 'package:equatable/equatable.dart';
import 'wallet_transaction.dart';

class Wallet extends Equatable {
  final String userId;
  final double balanceRM;
  final double balanceTokens;
  final List<WalletTransaction> transactions;

  const Wallet({
    required this.userId,
    required this.balanceRM,
    required this.balanceTokens,
    required this.transactions,
  });

  Wallet copyWith({
    String? userId,
    double? balanceRM,
    double? balanceTokens,
    List<WalletTransaction>? transactions,
  }) {
    return Wallet(
      userId: userId ?? this.userId,
      balanceRM: balanceRM ?? this.balanceRM,
      balanceTokens: balanceTokens ?? this.balanceTokens,
      transactions: transactions ?? this.transactions,
    );
  }

  bool hasEnoughBalance({required double requiredRM, required double requiredTokens}) {
    return balanceRM >= requiredRM && balanceTokens >= requiredTokens;
  }

  @override
  List<Object?> get props => [userId, balanceRM, balanceTokens, transactions];
}
