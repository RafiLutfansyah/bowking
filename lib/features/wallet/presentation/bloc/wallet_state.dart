import 'package:equatable/equatable.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/entities/wallet_transaction.dart';

class WalletState extends Equatable {
  final Wallet? wallet;
  final List<WalletTransaction>? transactions;
  final bool isBalanceLoading;
  final bool isTransactionsLoading;
  final String? balanceError;
  final String? transactionsError;

  const WalletState({
    this.wallet,
    this.transactions,
    this.isBalanceLoading = false,
    this.isTransactionsLoading = false,
    this.balanceError,
    this.transactionsError,
  });

  WalletState copyWith({
    Wallet? wallet,
    List<WalletTransaction>? transactions,
    bool? isBalanceLoading,
    bool? isTransactionsLoading,
    String? balanceError,
    String? transactionsError,
    bool clearBalanceError = false,
    bool clearTransactionsError = false,
  }) {
    return WalletState(
      wallet: wallet ?? this.wallet,
      transactions: transactions ?? this.transactions,
      isBalanceLoading: isBalanceLoading ?? this.isBalanceLoading,
      isTransactionsLoading: isTransactionsLoading ?? this.isTransactionsLoading,
      balanceError: clearBalanceError ? null : (balanceError ?? this.balanceError),
      transactionsError: clearTransactionsError ? null : (transactionsError ?? this.transactionsError),
    );
  }

  @override
  List<Object?> get props => [
        wallet,
        transactions,
        isBalanceLoading,
        isTransactionsLoading,
        balanceError,
        transactionsError,
      ];
}

// Legacy state classes for backward compatibility
class WalletInitial extends WalletState {
  const WalletInitial() : super();
}

class BalanceLoading extends WalletState {
  const BalanceLoading() : super(isBalanceLoading: true);
}

class BalanceLoaded extends WalletState {
  const BalanceLoaded(Wallet wallet) : super(wallet: wallet);
}

class TransactionsLoading extends WalletState {
  const TransactionsLoading() : super(isTransactionsLoading: true);
}

class TransactionHistoryLoaded extends WalletState {
  const TransactionHistoryLoaded(List<WalletTransaction> transactions)
      : super(transactions: transactions);
}

class WalletError extends WalletState {
  final String message;
  final bool canRetry;

  const WalletError({
    required this.message,
    this.canRetry = true,
  }) : super(
    isBalanceLoading: false,
    isTransactionsLoading: false,
  );

  @override
  List<Object?> get props => [message, canRetry, ...super.props];
}
