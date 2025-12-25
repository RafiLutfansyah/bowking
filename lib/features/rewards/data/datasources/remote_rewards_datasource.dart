import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/offer_model.dart';

class RemoteRewardsDataSource {
  final ApiClient apiClient;
  
  RemoteRewardsDataSource(this.apiClient);
  
  Future<List<OfferModel>> getAvailableOffers() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.offers);
      
      if (response.data['success'] == true) {
        final List<dynamic> offersJson = response.data['data'];
        return offersJson.map((json) => OfferModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch offers');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }
  
  Future<List<OfferModel>> getClaimedOffers(String userId) async {
    try {
      final response = await apiClient.dio.get(ApiConstants.offersClaimed);
      
      if (response.data['success'] == true) {
        final List<dynamic> offersJson = response.data['data'];
        return offersJson.map((json) => OfferModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch claimed offers');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }
  
  Future<OfferModel> claimOffer({
    required String userId,
    required String offerId,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.claimOffer(int.parse(offerId)),
      );
      
      if (response.data['success'] == true) {
        return OfferModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to claim offer');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }
  
  Future<OfferModel> useVoucher({required String offerId}) async {
    try {
      final response = await apiClient.dio.post(
        '${ApiConstants.offers}/$offerId/use',
      );
      
      if (response.data['success'] == true) {
        return OfferModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to use voucher');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }
}
