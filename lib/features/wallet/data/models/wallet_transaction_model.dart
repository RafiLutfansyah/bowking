import '../../domain/entities/wallet_transaction.dart';

class WalletTransactionModel extends WalletTransaction {
  const WalletTransactionModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.amountRM,
    required super.amountTokens,
    required super.description,
    required super.timestamp,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      type: json['type'] == 'credit' ? TransactionType.credit : TransactionType.debit,
      amountRM: _parseDouble(json['amount_rm']),
      amountTokens: _parseDouble(json['amount_tokens']),
      description: json['description'] as String,
      timestamp: DateTime.parse(json['created_at'] as String),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    if (value is num) return value.toDouble();
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.name,
      'amountRM': amountRM,
      'amountTokens': amountTokens,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
