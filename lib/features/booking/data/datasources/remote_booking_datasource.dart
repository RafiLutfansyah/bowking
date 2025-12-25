import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/service.dart';
import '../models/booking_model.dart';
import '../models/service_model.dart';

class RemoteBookingDataSource {
  final ApiClient apiClient;
  
  RemoteBookingDataSource(this.apiClient);
  
  Future<List<ServiceModel>> getAvailableServices() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.services);
      
      if (response.data['success'] == true) {
        final List<dynamic> servicesJson = response.data['data'];
        return servicesJson.map((json) => ServiceModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch services');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }
  
  Future<ServiceModel?> getServiceById(String id) async {
    try {
      final response = await apiClient.dio.get(ApiConstants.getService(id));
      
      if (response.data['success'] == true) {
        return ServiceModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }
  
  Future<BookingModel> createBooking({
    required String userId,
    required Service service,
    required DateTime dateTime,
    required double amountPaidRM,
    required double amountPaidTokens,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.bookings,
        data: {
          'service_id': service.id,
          'date_time': dateTime.toIso8601String(),
          'amount_paid_rm': amountPaidRM,
          'amount_paid_tokens': amountPaidTokens,
        },
      );
      
      if (response.data['success'] == true) {
        return BookingModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to create booking');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }
  
  Future<List<BookingModel>> getUserBookings(String userId) async {
    try {
      final response = await apiClient.dio.get(ApiConstants.bookings);
      
      if (response.data['success'] == true) {
        final List<dynamic> bookingsJson = response.data['data'];
        return bookingsJson.map((json) => BookingModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch bookings');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }
  
  Future<BookingModel> updateBookingStatus(String bookingId, BookingStatus status) async {
    try {
      final response = await apiClient.dio.patch(
        ApiConstants.updateBooking(bookingId),
        data: {'status': status.name},
      );
      
      if (response.data['success'] == true) {
        return BookingModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update booking');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }
}
