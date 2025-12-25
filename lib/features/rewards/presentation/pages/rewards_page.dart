import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_card.dart';
import '../bloc/rewards_bloc.dart';
import '../bloc/rewards_event.dart';
import '../bloc/rewards_state.dart';
import '../widgets/countdown_timer.dart';
import '../../domain/entities/offer.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> with SingleTickerProviderStateMixin {
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
    context.read<RewardsBloc>().add(LoadAvailableOffers());

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        // Refresh data when switching tabs
        if (_tabController.index == 0) {
          context.read<RewardsBloc>().add(LoadAvailableOffers());
        } else {
          context.read<RewardsBloc>().add(const LoadClaimedOffers());
        }
      }
    });
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
        title: const Text('Rewards'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Available'),
            Tab(text: 'My Vouchers'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search offers or vouchers...',
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
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAvailableTab(),
                _buildMyVouchersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableTab() {
    return BlocConsumer<RewardsBloc, RewardsState>(
      listenWhen: (previous, current) => 
          current is OfferClaimed || current is OfferClaimFailed,
      listener: (context, state) {
        if (state is OfferClaimed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Offer claimed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<RewardsBloc>().add(LoadAvailableOffers());
          context.read<RewardsBloc>().add(const LoadClaimedOffers());
        } else if (state is OfferClaimFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_cleanErrorMessage(state.message)),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
      buildWhen: (previous, current) => 
          current is RewardsLoading || current is AvailableOffersLoaded || current is OfferClaimFailed || current is RewardsError,
      builder: (context, state) {
        if (state is RewardsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AvailableOffersLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<RewardsBloc>().add(LoadAvailableOffers());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildOffersList(
              state.offers,
              claimingOfferId: state.claimingOfferId,
              showClaimButton: true,
            ),
          );
        } else if (state is OfferClaimFailed) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<RewardsBloc>().add(LoadAvailableOffers());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildOffersList(
              state.offers,
              showClaimButton: true,
            ),
          );
        } else if (state is RewardsError) {
          return Center(child: Text(_cleanErrorMessage(state.message)));
        }
        return const Center(child: Text('No offers available'));
      },
    );
  }

  Widget _buildMyVouchersTab() {
    return BlocConsumer<RewardsBloc, RewardsState>(
      listenWhen: (previous, current) =>
          current is VoucherUsed || current is VoucherUseFailed,
      listener: (context, state) {
        if (state is VoucherUsed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Voucher berhasil digunakan!'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<RewardsBloc>().add(const LoadClaimedOffers());
        } else if (state is VoucherUseFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_cleanErrorMessage(state.message)),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
      buildWhen: (previous, current) =>
          current is RewardsLoading ||
          current is ClaimedOffersLoaded ||
          current is VoucherUseFailed ||
          current is RewardsError,
      builder: (context, state) {
        if (state is RewardsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ClaimedOffersLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<RewardsBloc>().add(const LoadClaimedOffers());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildOffersList(
              state.claimedOffers,
              claimingOfferId: state.claimingOfferId,
              usingVoucherId: state.usingVoucherId,
              showClaimButton: false,
              showUseButton: true,
              showCountdown: true,
            ),
          );
        } else if (state is VoucherUseFailed) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<RewardsBloc>().add(const LoadClaimedOffers());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildOffersList(
              state.claimedOffers,
              showClaimButton: false,
              showUseButton: true,
              showCountdown: true,
            ),
          );
        } else if (state is RewardsError) {
          return Center(child: Text(_cleanErrorMessage(state.message)));
        }
        return const Center(child: Text('No vouchers yet'));
      },
    );
  }

  Widget _buildOffersList(
    List<Offer> offers, {
    String? claimingOfferId,
    String? usingVoucherId,
    bool showClaimButton = false,
    bool showUseButton = false,
    bool showCountdown = false,
  }) {
    final filteredOffers = offers.where((offer) {
      return offer.title.toLowerCase().contains(_searchQuery) ||
          offer.description.toLowerCase().contains(_searchQuery) ||
          offer.category.toLowerCase().contains(_searchQuery);
    }).toList();

    if (filteredOffers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isNotEmpty ? Icons.search_off : Icons.card_giftcard,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No offers found'
                  : (showClaimButton ? 'No offers available' : 'No vouchers yet'),
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: filteredOffers.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final offer = filteredOffers[index];
        final isClaiming = claimingOfferId == offer.id;
        final isUsing = usingVoucherId == offer.id;

        return CustomCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.secondaryBackground,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.radiusMedium),
                    topRight: Radius.circular(AppSpacing.radiusMedium),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.card_giftcard,
                    size: 64,
                    color: AppColors.roseGold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            offer.title,
                            style: AppTypography.textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.roseGoldLight,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                          ),
                          child: Text(
                            offer.category,
                            style: AppTypography.textTheme.labelSmall?.copyWith(
                              color: AppColors.roseGoldDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      offer.description,
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${offer.requiredTokens.toInt()} ${AppConstants.tokenName}',
                          style: AppTypography.textTheme.titleMedium?.copyWith(
                            color: AppColors.roseGold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            if (showClaimButton)
                              ElevatedButton(
                                onPressed: isClaiming ? null : () => _claimOffer(offer),
                                child: isClaiming
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Text('Claim'),
                              ),
                            if (showUseButton)
                              ElevatedButton(
                                onPressed: isUsing ? null : () => _showUseVoucherDialog(offer),
                                child: isUsing
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Text('Pakai'),
                              ),
                          ],
                        ),
                      ],
                    ),
                    if (showCountdown && offer.expiresAt != null)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.md),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: AppSpacing.iconSmall,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Expires in: ',
                              style: AppTypography.textTheme.bodySmall,
                            ),
                            CountdownTimer(expiresAt: offer.expiresAt!),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _cleanErrorMessage(String message) {
    return message
        .replaceFirst(RegExp(r'^Error:\s*', caseSensitive: false), '')
        .replaceFirst(RegExp(r'^Exception:\s*', caseSensitive: false), '');
  }

  void _claimOffer(Offer offer) {
    context.read<RewardsBloc>().add(ClaimOfferEvent(
          userId: AppConstants.mockUserId,
          offerId: offer.id,
        ));
  }

  void _showUseVoucherDialog(Offer offer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryBackground,
        title: Text(
          'Gunakan Voucher?',
          style: AppTypography.textTheme.displayMedium,
        ),
        content: Text(
          'Apakah Anda yakin ingin menggunakan voucher ini? Voucher akan hilang setelah digunakan.',
          style: AppTypography.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: AppTypography.textTheme.labelLarge?.copyWith(
                color: AppColors.slate,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<RewardsBloc>().add(UseVoucherEvent(offerId: offer.id));
            },
            child: const Text('Ya, Gunakan'),
          ),
        ],
      ),
    );
  }
}
