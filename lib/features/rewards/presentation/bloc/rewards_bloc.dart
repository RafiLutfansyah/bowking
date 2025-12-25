import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/usecases/get_available_offers.dart';
import '../../domain/usecases/claim_offer.dart';
import '../../domain/repositories/rewards_repository.dart';
import '../../domain/entities/offer.dart';
import 'rewards_event.dart';
import 'rewards_state.dart';

class RewardsBloc extends Bloc<RewardsEvent, RewardsState> {
  final GetAvailableOffers getAvailableOffers;
  final ClaimOffer claimOffer;
  final RewardsRepository rewardsRepository;

  RewardsBloc({
    required this.getAvailableOffers,
    required this.claimOffer,
    required this.rewardsRepository,
  }) : super(RewardsInitial()) {
    on<LoadAvailableOffers>(_onLoadAvailableOffers);
    on<LoadClaimedOffers>(_onLoadClaimedOffers);
    on<ClaimOfferEvent>(_onClaimOffer);
    on<UseVoucherEvent>(_onUseVoucher);
  }

  Future<void> _onLoadAvailableOffers(
    LoadAvailableOffers event,
    Emitter<RewardsState> emit,
  ) async {
    emit(RewardsLoading());
    final result = await getAvailableOffers();
    result.fold(
      (failure) => emit(RewardsError(message: failure.message)),
      (offers) => emit(AvailableOffersLoaded(offers)),
    );
  }

  Future<void> _onLoadClaimedOffers(
    LoadClaimedOffers event,
    Emitter<RewardsState> emit,
  ) async {
    emit(RewardsLoading());
    final result = await rewardsRepository.getClaimedOffers(AppConstants.mockUserId);
    result.fold(
      (failure) => emit(RewardsError(message: failure.message)),
      (offers) => emit(ClaimedOffersLoaded(offers)),
    );
  }

  Future<void> _onClaimOffer(
    ClaimOfferEvent event,
    Emitter<RewardsState> emit,
  ) async {
    final currentState = state;
    List<Offer> currentOffers;
    
    if (currentState is AvailableOffersLoaded) {
      currentOffers = currentState.offers;
    } else if (currentState is OfferClaimFailed) {
      currentOffers = currentState.offers;
    } else {
      currentOffers = <Offer>[];
    }
    
    // Emit state with claimingOfferId to show loading on specific button
    emit(AvailableOffersLoaded(currentOffers, claimingOfferId: event.offerId));
    
    final result = await claimOffer(
      userId: event.userId,
      offerId: event.offerId,
    );
    result.fold(
      (failure) {
        // Keep offers visible and emit error state
        emit(OfferClaimFailed(
          message: failure.message,
          offerId: event.offerId,
          offers: currentOffers,
        ));
      },
      (offer) => emit(OfferClaimed(offer)),
    );
  }

  Future<void> _onUseVoucher(
    UseVoucherEvent event,
    Emitter<RewardsState> emit,
  ) async {
    final currentState = state;
    List<Offer> currentOffers;
    
    if (currentState is ClaimedOffersLoaded) {
      currentOffers = currentState.claimedOffers;
    } else if (currentState is VoucherUseFailed) {
      currentOffers = currentState.claimedOffers;
    } else {
      currentOffers = <Offer>[];
    }
    
    // Emit state with usingVoucherId to show loading on specific button
    emit(ClaimedOffersLoaded(currentOffers, usingVoucherId: event.offerId));
    
    final result = await rewardsRepository.useVoucher(offerId: event.offerId);
    result.fold(
      (failure) {
        // Keep vouchers visible and emit error state
        emit(VoucherUseFailed(
          message: failure.message,
          offerId: event.offerId,
          claimedOffers: currentOffers,
        ));
      },
      (usedOffer) => emit(VoucherUsed(usedOffer)),
    );
  }
}
