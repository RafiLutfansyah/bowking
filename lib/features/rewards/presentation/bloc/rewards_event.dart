import 'package:equatable/equatable.dart';

abstract class RewardsEvent extends Equatable {
  const RewardsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAvailableOffers extends RewardsEvent {}

class LoadClaimedOffers extends RewardsEvent {
  final String userId;

  const LoadClaimedOffers(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ClaimOfferEvent extends RewardsEvent {
  final String userId;
  final String offerId;

  const ClaimOfferEvent({
    required this.userId,
    required this.offerId,
  });

  @override
  List<Object?> get props => [userId, offerId];
}

class UseVoucherEvent extends RewardsEvent {
  final String offerId;

  const UseVoucherEvent({required this.offerId});

  @override
  List<Object?> get props => [offerId];
}
