import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../resources/data_state.dart';
// import 'package:flutter_tmdb_app/core/models/movie_model.dart'; // Repository parse edecek

// Provider'ı Provider olarak değiştir
final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = Dio();
  // TODO: API Key'i güvenli bir yerden al (örn: environment variables, config file)
  const String apiKey = "8fadd9b769556f455dcba64fec566f18";
  return ApiService(dio, apiKey);
});

class ApiService {
  final Dio _dio;
  final String _apiKey; // API anahtarını saklamak için

  ApiService(this._dio, this._apiKey); // Constructor'a apiKey ekle

  // Dönüş tipi tekrar DataState<Map<String, dynamic>> olacak
  Future<DataState<Map<String, dynamic>>> request({
    required String method,
    required String url,
    // fromJson parametresi kaldırıldı
    dynamic data, // POST, PUT için body
    Map<String, dynamic>? query, // GET için query parametreleri
  }) async {
    try {
      // API anahtarını mevcut query parametrelerine ekle
      final Map<String, dynamic> finalQueryParameters = {
        ...?query, // Mevcut query parametreleri
        'api_key': _apiKey, // API anahtarını ekle
      };

      final response = await _dio.request(
        url,
        data: data,
        queryParameters: finalQueryParameters,
        onSendProgress: _logProgress,
        options: _buildOptions(method),
      );

      // Başarılı Yanıt
      if (response.statusCode == 200) {
        final responseData =
            response.data as Map<String, dynamic>; // Yanıtı Map olarak al
        final int? page = responseData['page'] as int?;
        final int? totalPages = responseData['total_pages'] as int?;
        final int? totalResults = responseData['total_results'] as int?;

        // Doğrudan Map verisini DataSuccess içinde döndür
        return DataSuccess<Map<String, dynamic>>(
          data: responseData,
          page: page,
          totalPages: totalPages,
          totalResults: totalResults,
        );
      } else if (response.statusCode == 204) {
        // 204 No Content durumu için boş results listesi içeren Map ile DataSuccess döndür
        return const DataSuccess<Map<String, dynamic>>(
          data: {
            'results': [],
            'page': 1, // veya header'dan okunabilir
            'total_pages': 1,
            'total_results': 0
          },
          page: 1,
          totalPages: 1,
          totalResults: 0,
        );
      } else {
        // Hata Yanıtı
        String errorMessage = "Bilinmeyen bir API hatası oluştu.";
        int? statusCode = response.statusCode;
        bool? success = false;

        if (response.data is Map<String, dynamic>) {
          final errorData = response.data as Map<String, dynamic>;
          errorMessage = errorData['status_message'] as String? ?? errorMessage;
          success = errorData['success'] as bool? ?? success;
        }

        // Generic tipi Map<String, dynamic> olarak düzeltildi
        return DataError<Map<String, dynamic>>(
          message: errorMessage,
          statusCode: statusCode,
          success: success,
        );
      }
    } on DioException catch (e) {
      // Dio hataları
      // Generic tipi Map<String, dynamic> olarak düzeltildi
      return DataError<Map<String, dynamic>>(
          message: e.message ?? "Network hatası veya Dio hatası",
          statusCode: e.response?.statusCode);
    } catch (e) {
      // Diğer beklenmedik hatalar
      // Generic tipi Map<String, dynamic> olarak düzeltildi
      return DataError<Map<String, dynamic>>(
          message: "Veri işlenirken hata oluştu: ${e.toString()}");
    }
  }

  void _logProgress(int sent, int total) {
    if (kDebugMode) {
      // print('Sent: $sent, Total: $total');
    }
  }

  Options _buildOptions(String method) {
    return Options(
      method: method,
      headers: {
        'accept': 'application/json',
      },
      sendTimeout: const Duration(milliseconds: 55000),
      receiveTimeout: const Duration(milliseconds: 55000),
      responseType: ResponseType.json,
      validateStatus: (status) => status != null,
    );
  }
}
