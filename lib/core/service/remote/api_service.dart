import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../resources/data_state.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = Dio();
  const String apiKey = "8fadd9b769556f455dcba64fec566f18";
  return ApiService(dio, apiKey);
});

class ApiService {
  final Dio _dio;
  final String _apiKey;

  ApiService(this._dio, this._apiKey);

  Future<DataState<Map<String, dynamic>>> request({
    required String method,
    required String url,
    dynamic data,
    Map<String, dynamic>? query,
  }) async {
    try {
      final Map<String, dynamic> finalQueryParameters = {
        ...?query,
        'api_key': _apiKey,
      };

      final response = await _dio.request(
        url,
        data: data,
        queryParameters: finalQueryParameters,
        onSendProgress: _logProgress,
        options: _buildOptions(method),
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final int? page = responseData['page'] as int?;
        final int? totalPages = responseData['total_pages'] as int?;
        final int? totalResults = responseData['total_results'] as int?;

        return DataSuccess<Map<String, dynamic>>(
          data: responseData,
          page: page,
          totalPages: totalPages,
          totalResults: totalResults,
        );
      } else if (response.statusCode == 204) {
        return const DataSuccess<Map<String, dynamic>>(
          data: {
            'results': [],
            'page': 1,
            'total_pages': 1,
            'total_results': 0
          },
          page: 1,
          totalPages: 1,
          totalResults: 0,
        );
      } else {
        String errorMessage = "Bilinmeyen bir API hatası oluştu.";
        int? statusCode = response.statusCode;
        bool? success = false;

        if (response.data is Map<String, dynamic>) {
          final errorData = response.data as Map<String, dynamic>;
          errorMessage = errorData['status_message'] as String? ?? errorMessage;
          success = errorData['success'] as bool? ?? success;
        }

        return DataError<Map<String, dynamic>>(
          message: errorMessage,
          statusCode: statusCode,
          success: success,
        );
      }
    } on DioException catch (e) {
      return DataError<Map<String, dynamic>>(
          message: e.message ?? "Network hatası veya Dio hatası",
          statusCode: e.response?.statusCode);
    } catch (e) {
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
