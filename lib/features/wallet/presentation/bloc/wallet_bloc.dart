import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_wallet.dart';
import '../../domain/usecases/get_transaction_history.dart';
import '../../domain/repositories/wallet_repository.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWallet getWallet;
  final GetTransactionHistory getTransactionHistory;
  final WalletRepository walletRepository;

  WalletBloc({
    required this.getWallet,
    required this.getTransactionHistory,
    required this.walletRepository,
  }) : super(const WalletState()) {
    on<LoadWallet>(_onLoadWallet);
    on<DeductBalance>(_onDeductBalance);
    on<LoadTransactionHistory>(_onLoadTransactionHistory);
  }

  Future<void> _onLoadWallet(
    LoadWallet event,
    Emitter<WalletState> emit,
  ) async {
    // Skip if already loading or data is fresh
    if (state.isBalanceLoading) return;
    if (state.wallet != null && !event.forceRefresh) return;
    
    emit(state.copyWith(isBalanceLoading: true, clearBalanceError: true));
    final result = await getWallet(event.userId);
    result.fold(
      (failure) => emit(state.copyWith(
        isBalanceLoading: false,
        balanceError: failure.message,
      )),
      (wallet) => emit(state.copyWith(
        isBalanceLoading: false,
        wallet: wallet,
      )),
    );
  }

  Future<void> _onDeductBalance(
    DeductBalance event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(isBalanceLoading: true, clearBalanceError: true));
    final result = await walletRepository.deductBalance(
      userId: event.userId,
      amountRM: event.amountRM,
      amountTokens: event.amountTokens,
      description: event.description,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isBalanceLoading: false,
        balanceError: failure.message,
      )),
      (wallet) => emit(state.copyWith(
        isBalanceLoading: false,
        wallet: wallet,
      )),
    );
  }

  Future<void> _onLoadTransactionHistory(
    LoadTransactionHistory event,
    Emitter<WalletState> emit,
  ) async {
    // Skip if already loading
    if (state.isTransactionsLoading) return;
    
    // Only skip if we have fresh data AND not forcing refresh
    if (state.transactions != null && 
        state.transactions!.isNotEmpty && 
        !event.forceRefresh) return;
    
    print('=== BLOC: Loading transactions for user: ${event.userId} ===');
    emit(state.copyWith(isTransactionsLoading: true, clearTransactionsError: true));
    final result = await getTransactionHistory(event.userId);
    result.fold(
      (failure) {
        print('=== BLOC: Transaction loading FAILED: ${failure.message} ===');
        emit(state.copyWith(
          isTransactionsLoading: false,
          transactionsError: failure.message,
        ));
      },
      (transactions) {
        print('=== BLOC: Transaction loading SUCCESS ===');
        print('Transactions count: ${transactions.length}');
        print('Transactions: $transactions');
        emit(state.copyWith(
          isTransactionsLoading: false,
          transactions: transactions,
        ));
      },
    );
  }
}
