import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/user_model.dart';

class RemoteAuthDataSource {
  final ApiClient apiClient;
  final TokenStorage tokenStorage;

  RemoteAuthDataSource({
    required this.apiClient,
    required this.tokenStorage,
  });

  Future<UserModel> googleSignIn(Map<String, dynamic> userData) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.googleSignIn,
        data: userData,
      );

      if (response.data['success'] == true) {
        final token = response.data['data']['access_token'] as String;
        await tokenStorage.saveToken(token);
        return UserModel.fromJson(response.data['data']['user']);
      } else {
        throw Exception(response.data['message'] ?? 'Google sign-in failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.currentUser);

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch user');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }

  Future<void> logout() async {
    try {
      await apiClient.dio.post(ApiConstants.logout);
      await tokenStorage.clearToken();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await tokenStorage.getToken();
    return token != null && token.isNotEmpty;
  }
}
