import '../../domain/entities/wallet.dart';
import 'wallet_transaction_model.dart';

class WalletModel extends Wallet {
  const WalletModel({
    required super.userId,
    required super.balanceRM,
    required super.balanceTokens,
    required super.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      userId: json['user_id'].toString(),
      balanceRM: _parseDouble(json['balance_rm']),
      balanceTokens: _parseDouble(json['balance_tokens']),
      transactions: [], // Transactions fetched separately
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
      'userId': userId,
      'balanceRM': balanceRM,
      'balanceTokens': balanceTokens,
      'transactions': transactions
          .map((t) => WalletTransactionModel(
                id: t.id,
                userId: t.userId,
                type: t.type,
                amountRM: t.amountRM,
                amountTokens: t.amountTokens,
                description: t.description,
                timestamp: t.timestamp,
              ).toJson())
          .toList(),
    };
  }

  factory WalletModel.fromEntity(Wallet wallet) {
    return WalletModel(
      userId: wallet.userId,
      balanceRM: wallet.balanceRM,
      balanceTokens: wallet.balanceTokens,
      transactions: wallet.transactions,
    );
  }
}
