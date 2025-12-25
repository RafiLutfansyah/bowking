import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/cubit/current_user_cubit.dart';
import '../../../../core/presentation/cubit/current_user_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bowking'),
      ),
      body: BlocBuilder<CurrentUserCubit, CurrentUserState>(
        builder: (context, state) {
          final userName = state is CurrentUserAuthenticated
              ? (state.user.name?.split(' ').first ?? 'User')
              : 'Guest';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingHorizontal,
                vertical: AppSpacing.screenPaddingVertical,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, $userName!',
                    style: AppTypography.textTheme.displayMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Your on-premise service companion',
                    style: AppTypography.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _buildFeatureCard(
                    context,
                    icon: Icons.local_car_wash,
                    title: 'Book Services',
                    description: 'Valet, Car Wash, and more',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildFeatureCard(
                    context,
                    icon: Icons.account_balance_wallet,
                    title: 'Manage Wallet',
                    description: 'View balance and transactions',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildFeatureCard(
                    context,
                    icon: Icons.card_giftcard,
                    title: 'Explore Rewards',
                    description: 'Claim exclusive offers',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return CustomCard(
      isClickable: true,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.roseGoldLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            ),
            child: Icon(
              icon,
              color: AppColors.roseGold,
              size: AppSpacing.iconLarge,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
