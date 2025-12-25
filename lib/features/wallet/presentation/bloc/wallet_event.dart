import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class LoadWallet extends WalletEvent {
  final String userId;
  final bool forceRefresh;

  const LoadWallet(this.userId, {this.forceRefresh = false});

  @override
  List<Object?> get props => [userId, forceRefresh];
}

class DeductBalance extends WalletEvent {
  final String userId;
  final double amountRM;
  final double amountTokens;
  final String description;

  const DeductBalance({
    required this.userId,
    required this.amountRM,
    required this.amountTokens,
    required this.description,
  });

  @override
  List<Object?> get props => [userId, amountRM, amountTokens, description];
}

class LoadTransactionHistory extends WalletEvent {
  final String userId;
  final bool forceRefresh;

  const LoadTransactionHistory(this.userId, {this.forceRefresh = false});

  @override
  List<Object?> get props => [userId, forceRefresh];
}
