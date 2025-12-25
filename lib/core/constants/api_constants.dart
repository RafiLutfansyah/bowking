class ApiConstants {
  ApiConstants._();
  
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://192.168.1.5:8000',
  );
  
  // Auth endpoints
  static const String authGoogle = '/api/auth/google';
  static const String googleSignIn = '/api/auth/google';
  static const String authLogout = '/api/auth/logout';
  static const String logout = '/api/auth/logout';
  static const String authMe = '/api/auth/me';
  static const String currentUser = '/api/auth/me';
  static const String authRefresh = '/api/auth/refresh';
  
  // Service endpoints
  static const String services = '/api/services';
  static String getService(String id) => '/api/services/$id';
  
  // Booking endpoints
  static const String bookings = '/api/bookings';
  static String updateBooking(String id) => '/api/bookings/$id';
  
  // Wallet endpoints
  static const String wallet = '/api/wallet';
  static const String walletTopup = '/api/wallet/topup';
  static const String walletTransactions = '/api/wallet/transactions';
  
  // Offer endpoints
  static const String offers = '/api/offers';
  static const String offersClaimed = '/api/offers/claimed';
  static String claimOffer(int id) => '/api/offers/$id/claim';
}
