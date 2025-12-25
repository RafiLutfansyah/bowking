import 'package:equatable/equatable.dart';

enum PaymentType {
  currency,
  tokens,
  mixed,
}

class PaymentMethod extends Equatable {
  final double amountRM;
  final double amountTokens;

  const PaymentMethod({
    required this.amountRM,
    required this.amountTokens,
  });

  PaymentType get type {
    if (amountRM > 0 && amountTokens > 0) return PaymentType.mixed;
    if (amountTokens > 0) return PaymentType.tokens;
    return PaymentType.currency;
  }

  bool get isValid => amountRM >= 0 && amountTokens >= 0 && (amountRM > 0 || amountTokens > 0);

  @override
  List<Object?> get props => [amountRM, amountTokens];
}
