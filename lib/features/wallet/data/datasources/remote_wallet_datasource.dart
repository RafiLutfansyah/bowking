import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';

class RemoteWalletDataSource {
  final ApiClient apiClient;
  
  RemoteWalletDataSource(this.apiClient);
  
  Future<WalletModel> getWallet(String userId) async {
    try {
      final response = await apiClient.dio.get(ApiConstants.wallet);
      
      if (response.data['success'] == true) {
        return WalletModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch wallet');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }
  
  Future<WalletModel> addBalance({
    required String userId,
    required double amountRM,
    required double amountTokens,
    required String description,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.walletTopup,
        data: {
          'amount_rm': amountRM,
          'amount_tokens': amountTokens,
        },
      );
      
      if (response.data['success'] == true) {
        return WalletModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to top-up wallet');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }
  
  Future<List<WalletTransactionModel>> getTransactionHistory(String userId) async {
    try {
      final response = await apiClient.dio.get(ApiConstants.walletTransactions);
      
      if (response.data['success'] == true) {
        final List<dynamic> transactionsJson = response.data['data'];
        return transactionsJson
            .map((json) => WalletTransactionModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch transactions');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }
  
  // Note: deductBalance is handled by booking API, not separate endpoint
  Future<WalletModel> deductBalance({
    required String userId,
    required double amountRM,
    required double amountTokens,
    required String description,
  }) async {
    // This is handled server-side when creating booking
    // Just fetch updated wallet
    return await getWallet(userId);
  }
}
