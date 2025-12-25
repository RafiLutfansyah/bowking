import 'package:equatable/equatable.dart';

class UserBalance extends Equatable {
  final double balanceRM;
  final double balanceTokens;

  const UserBalance({
    required this.balanceRM,
    required this.balanceTokens,
  });

  bool canAfford({required double requiredRM, required double requiredTokens}) {
    return balanceRM >= requiredRM && balanceTokens >= requiredTokens;
  }

  bool canAffordWithCurrency(double requiredRM) {
    return balanceRM >= requiredRM;
  }

  bool canAffordWithTokens(double requiredTokens) {
    return balanceTokens >= requiredTokens;
  }

  bool canAffordEither({required double requiredRM, required double requiredTokens}) {
    return canAffordWithCurrency(requiredRM) || canAffordWithTokens(requiredTokens);
  }

  @override
  List<Object?> get props => [balanceRM, balanceTokens];
}
