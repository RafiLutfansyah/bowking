import 'package:equatable/equatable.dart';
import '../../domain/payment/payment_method.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class LoadBalance extends PaymentEvent {
  final String userId;
  final bool forceRefresh;

  const LoadBalance(this.userId, {this.forceRefresh = false});

  @override
  List<Object?> get props => [userId, forceRefresh];
}

class ProcessPayment extends PaymentEvent {
  final String userId;
  final PaymentMethod paymentMethod;
  final String description;

  const ProcessPayment({
    required this.userId,
    required this.paymentMethod,
    required this.description,
  });

  @override
  List<Object?> get props => [userId, paymentMethod, description];
}

class ClearPaymentResult extends PaymentEvent {
  const ClearPaymentResult();
}
