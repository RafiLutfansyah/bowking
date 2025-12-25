import 'package:equatable/equatable.dart';

enum TransactionType { debit, credit }

class WalletTransaction extends Equatable {
  final String id;
  final String userId;
  final TransactionType type;
  final double amountRM;
  final double amountTokens;
  final String description;
  final DateTime timestamp;

  const WalletTransaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amountRM,
    required this.amountTokens,
    required this.description,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, userId, type, amountRM, amountTokens, description, timestamp];
}
