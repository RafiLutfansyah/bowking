import 'package:equatable/equatable.dart';
import '../../domain/entities/offer.dart';

abstract class RewardsState extends Equatable {
  const RewardsState();

  @override
  List<Object?> get props => [];
}

class RewardsInitial extends RewardsState {}

class RewardsLoading extends RewardsState {}

class AvailableOffersLoaded extends RewardsState {
  final List<Offer> offers;
  final String? claimingOfferId;

  const AvailableOffersLoaded(
    this.offers, {
    this.claimingOfferId,
  });

  @override
  List<Object?> get props => [offers, claimingOfferId];
}

class ClaimedOffersLoaded extends RewardsState {
  final List<Offer> claimedOffers;
  final String? claimingOfferId;
  final String? usingVoucherId;

  const ClaimedOffersLoaded(
    this.claimedOffers, {
    this.claimingOfferId,
    this.usingVoucherId,
  });

  @override
  List<Object?> get props => [claimedOffers, claimingOfferId, usingVoucherId];
}

class OfferClaimed extends RewardsState {
  final Offer offer;

  const OfferClaimed(this.offer);

  @override
  List<Object?> get props => [offer];
}

class VoucherUsed extends RewardsState {
  final Offer offer;

  const VoucherUsed(this.offer);

  @override
  List<Object?> get props => [offer];
}

class OfferClaimFailed extends RewardsState {
  final String message;
  final String offerId;
  final List<Offer> offers;

  const OfferClaimFailed({
    required this.message,
    required this.offerId,
    required this.offers,
  });

  @override
  List<Object?> get props => [message, offerId, offers];
}

class VoucherUseFailed extends RewardsState {
  final String message;
  final String offerId;
  final List<Offer> claimedOffers;

  const VoucherUseFailed({
    required this.message,
    required this.offerId,
    required this.claimedOffers,
  });

  @override
  List<Object?> get props => [message, offerId, claimedOffers];
}

class RewardsError extends RewardsState {
  final String message;
  final bool canRetry;

  const RewardsError({
    required this.message,
    this.canRetry = true,
  });

  @override
  List<Object?> get props => [message, canRetry];
}
