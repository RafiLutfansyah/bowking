import 'package:get_it/get_it.dart';

// Core
import 'core/network/api_client.dart';
import 'core/network/network_info.dart';
import 'core/storage/token_storage.dart';
import 'core/presentation/cubit/current_user_cubit.dart';
import 'core/domain/payment/payment_repository.dart';
import 'core/presentation/payment/payment_bloc.dart';

// Auth Feature
import 'features/auth/data/datasources/google_signin_datasource.dart';
import 'features/auth/data/datasources/remote_auth_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_google_id_token.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Booking Feature
import 'features/booking/data/datasources/remote_booking_datasource.dart';
import 'features/booking/data/repositories/booking_repository_impl.dart';
import 'features/booking/domain/repositories/booking_repository.dart';
import 'features/booking/domain/usecases/get_available_services.dart';
import 'features/booking/domain/usecases/create_booking.dart';
import 'features/booking/presentation/bloc/booking_bloc.dart';

// Wallet Feature
import 'features/wallet/data/datasources/remote_wallet_datasource.dart';
import 'features/wallet/data/repositories/wallet_repository_impl.dart';
import 'features/wallet/data/adapters/wallet_payment_adapter.dart';
import 'features/wallet/domain/repositories/wallet_repository.dart';
import 'features/wallet/domain/usecases/get_wallet.dart';
import 'features/wallet/domain/usecases/get_transaction_history.dart';
import 'features/wallet/presentation/bloc/wallet_bloc.dart';

// Rewards Feature
import 'features/rewards/data/datasources/remote_rewards_datasource.dart';
import 'features/rewards/data/repositories/rewards_repository_impl.dart';
import 'features/rewards/domain/repositories/rewards_repository.dart';
import 'features/rewards/domain/usecases/get_available_offers.dart';
import 'features/rewards/domain/usecases/get_claimed_offers.dart';
import 'features/rewards/domain/usecases/claim_offer.dart';
import 'features/rewards/presentation/bloc/rewards_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      authRepository: sl(),
      getGoogleIdToken: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetGoogleIdToken(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      googleSignInDataSource: sl(),
      networkInfo: sl(),
      tokenStorage: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<RemoteAuthDataSource>(
    () => RemoteAuthDataSource(
      apiClient: sl(),
      tokenStorage: sl(),
    ),
  );
  sl.registerLazySingleton<GoogleSignInDataSource>(
    () => GoogleSignInDataSource(
      serverClientId: const String.fromEnvironment(
        'GOOGLE_SERVER_CLIENT_ID',
        defaultValue: '1077587336107-fsol97tk5ubm9bgda1hou270dda8ql9t.apps.googleusercontent.com',
      ),
    ),
  );

  //! Features - Booking
  // Bloc
  sl.registerFactory(
    () => BookingBloc(
      getAvailableServices: sl(),
      createBooking: sl(),
      bookingRepository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAvailableServices(sl()));
  sl.registerLazySingleton(() => CreateBooking(sl()));

  // Repository
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<RemoteBookingDataSource>(
    () => RemoteBookingDataSource(sl()),
  );

  //! Features - Wallet
  // Bloc
  sl.registerFactory(
    () => WalletBloc(
      getWallet: sl(),
      getTransactionHistory: sl(),
      walletRepository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetWallet(sl()));
  sl.registerLazySingleton(() => GetTransactionHistory(sl()));

  // Repository
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<RemoteWalletDataSource>(
    () => RemoteWalletDataSource(sl()),
  );

  //! Features - Rewards
  // Bloc
  sl.registerFactory(
    () => RewardsBloc(
      getAvailableOffers: sl(),
      claimOffer: sl(),
      rewardsRepository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAvailableOffers(sl()));
  sl.registerLazySingleton(() => GetClaimedOffers(sl()));
  sl.registerLazySingleton(() => ClaimOffer(sl()));

  // Repository
  sl.registerLazySingleton<RewardsRepository>(
    () => RewardsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<RemoteRewardsDataSource>(
    () => RemoteRewardsDataSource(sl()),
  );

  //! Core
  sl.registerLazySingleton(() => CurrentUserCubit());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton(() => TokenStorage());
  sl.registerLazySingleton(() => ApiClient(sl()));
  
  // Payment (Core) - using wallet as implementation
  sl.registerLazySingleton<PaymentRepository>(
    () => WalletPaymentAdapter(walletRepository: sl()),
  );
  
  sl.registerFactory(
    () => PaymentBloc(paymentRepository: sl()),
  );
}
