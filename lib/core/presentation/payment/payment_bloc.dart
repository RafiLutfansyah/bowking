import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/payment/payment_repository.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentBloc({required this.paymentRepository}) : super(const PaymentState()) {
    on<LoadBalance>(_onLoadBalance);
    on<ProcessPayment>(_onProcessPayment);
    on<ClearPaymentResult>(_onClearPaymentResult);
  }

  Future<void> _onLoadBalance(
    LoadBalance event,
    Emitter<PaymentState> emit,
  ) async {
    if (state.isLoadingBalance) return;
    if (state.balance != null && !event.forceRefresh) return;

    emit(state.copyWith(isLoadingBalance: true, clearBalanceError: true));
    final result = await paymentRepository.getUserBalance(event.userId);
    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingBalance: false,
        balanceError: failure.message,
      )),
      (balance) => emit(state.copyWith(
        isLoadingBalance: false,
        balance: balance,
      )),
    );
  }

  Future<void> _onProcessPayment(
    ProcessPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(isProcessingPayment: true, clearLastPaymentResult: true));
    final result = await paymentRepository.processPayment(
      userId: event.userId,
      paymentMethod: event.paymentMethod,
      description: event.description,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isProcessingPayment: false,
        balanceError: failure.message,
      )),
      (paymentResult) async {
        emit(state.copyWith(
          isProcessingPayment: false,
          lastPaymentResult: paymentResult,
        ));
        
        if (paymentResult.success) {
          add(LoadBalance(event.userId, forceRefresh: true));
        }
      },
    );
  }

  void _onClearPaymentResult(
    ClearPaymentResult event,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(clearLastPaymentResult: true));
  }
}
