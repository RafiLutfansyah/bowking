import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/presentation/cubit/current_user_cubit.dart';
import '../../domain/entities/wallet_transaction.dart';
import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_event.dart';
import '../bloc/wallet_state.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    _loadInitialData();
  }

  void _loadInitialData() {
    final userId = context.read<CurrentUserCubit>().currentUser?.id ?? '';
    context.read<WalletBloc>().add(LoadWallet(userId));
    context.read<WalletBloc>().add(LoadTransactionHistory(userId, forceRefresh: true));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Balance'),
            Tab(text: 'Transactions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBalanceTab(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search transactions...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _buildTransactionsTab(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceTab() {
    return BlocBuilder<WalletBloc, WalletState>(
      buildWhen: (previous, current) => 
          previous.isBalanceLoading != current.isBalanceLoading ||
          previous.wallet != current.wallet ||
          previous.balanceError != current.balanceError,
      builder: (context, state) {
        if (state.isBalanceLoading && state.wallet == null) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.balanceError != null && state.wallet == null) {
          return Center(
            child: Text(
              'Error: ${state.balanceError}',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
              ),
            ),
          );
        } else if (state.wallet != null) {
          final wallet = state.wallet!;
          return RefreshIndicator(
            onRefresh: () async {
              final userId = context.read<CurrentUserCubit>().currentUser?.id ?? '';
              context.read<WalletBloc>().add(LoadWallet(userId));
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                CustomCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  backgroundColor: AppColors.secondaryBackground,
                  child: Column(
                    children: [
                      Text(
                        'Total Balance',
                        style: AppTypography.textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                AppConstants.currency,
                                style: AppTypography.textTheme.labelMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                wallet.balanceRM.toStringAsFixed(2),
                                style: AppTypography.textTheme.displayLarge?.copyWith(
                                  color: AppColors.roseGold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: 60,
                            color: AppColors.divider,
                          ),
                          Column(
                            children: [
                              Text(
                                AppConstants.tokenName,
                                style: AppTypography.textTheme.labelMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                wallet.balanceTokens.toInt().toString(),
                                style: AppTypography.textTheme.displayLarge?.copyWith(
                                  color: AppColors.slate,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: Text(
            'No wallet data',
            style: AppTypography.textTheme.bodyMedium,
          ),
        );
      },
    );
  }

  Widget _buildTransactionsTab() {
    return BlocBuilder<WalletBloc, WalletState>(
      buildWhen: (previous, current) => 
          previous.isTransactionsLoading != current.isTransactionsLoading ||
          previous.transactions != current.transactions ||
          previous.transactionsError != current.transactionsError,
      builder: (context, state) {
        if (state.isTransactionsLoading && state.transactions == null) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.transactionsError != null && state.transactions == null) {
          return Center(child: Text('Error: ${state.transactionsError}'));
        } else if (state.transactions != null) {
          return RefreshIndicator(
            onRefresh: () async {
              final userId = context.read<CurrentUserCubit>().currentUser?.id ?? '';
              context.read<WalletBloc>().add(LoadTransactionHistory(userId, forceRefresh: true));
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildTransactionsList(state.transactions!),
          );
        }
        return const Center(child: Text('No transaction data'));
      },
    );
  }

  Widget _buildTransactionsList(List transactions) {
    final filteredTransactions = transactions.where((tx) {
      return tx.description.toLowerCase().contains(_searchQuery);
    }).toList();

    if (filteredTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isNotEmpty ? Icons.search_off : Icons.receipt_long,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _searchQuery.isNotEmpty ? 'No transactions found' : 'No transactions yet',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction History',
              style: AppTypography.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            ...filteredTransactions.map((tx) {
              final isCredit = tx.type == TransactionType.credit;
              return CustomCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: isCredit ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                      ),
                      child: Icon(
                        isCredit ? Icons.add_circle : Icons.remove_circle,
                        color: isCredit ? AppColors.success : AppColors.error,
                        size: AppSpacing.iconStandard,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx.description,
                            style: AppTypography.textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            DateFormat('MMM dd, yyyy HH:mm').format(tx.timestamp),
                            style: AppTypography.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (tx.amountRM > 0)
                          Text(
                            '${isCredit ? '+' : '-'}${AppConstants.currency} ${tx.amountRM.toStringAsFixed(2)}',
                            style: AppTypography.textTheme.titleMedium?.copyWith(
                              color: isCredit ? AppColors.success : AppColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (tx.amountTokens > 0)
                          Text(
                            '${isCredit ? '+' : '-'}${tx.amountTokens.toInt()} ${AppConstants.tokenName}',
                            style: AppTypography.textTheme.bodyMedium?.copyWith(
                              color: isCredit ? AppColors.success : AppColors.error,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
