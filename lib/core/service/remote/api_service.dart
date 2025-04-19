import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../resources/data_state.dart';

final apiServiceNotifier = ChangeNotifierProvider<ApiService>((ref) {
  return ApiService(Dio());
});

class ApiService extends ChangeNotifier {
  final Dio _dio;

  ApiService(this._dio);

//-------yeni service----------
  String? _bearerToken = "";

  Future<DataState<dynamic>> request({
    required String method,
    required String url,
    dynamic data,
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.request(
        url,
        data: data,
        queryParameters: query,
        onSendProgress: _logProgress,
        options: _buildOptions(method),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DataSuccess(data: response.data);
      }
      if (response.statusCode == 422) {
        final errors = response.data["errors"] as Map<String, dynamic>;
        final errorMessage =
            response.data["message"] ?? 'Bilinmeyen bir hata oluştu';

        //!Eğer tüm hata mesajlarını aynı anda göstermek istiyorsanız bu kısmı kullanabilirsiniz.
        /*  if (errors.isNotEmpty) {
          final detailedErrors = errors.entries
              .map((entry) =>
                  '${entry.key}: ${List<String>.from(entry.value).join(", ")}')
              .join("\n");
          return DataError(message: detailedErrors);
        } */

        //!Eğer ilk hata mesajını göstermek istiyorsanız bu kısmı kullanabilirsiniz.
        if (errors.isNotEmpty) {
          final firstErrorKey = errors.keys.first;
          final firstErrorMessage =
              List<String>.from(errors[firstErrorKey]).join(", ");
          return DataError(message: firstErrorMessage);
        }
        return DataError(message: errorMessage);
      } else if (response.statusCode == 401) {
        final errorMessage =
            response.data["message"] ?? 'Bilinmeyen bir hata oluştu';
        return DataError(message: errorMessage);
      } else if (response.statusCode == 404) {
        return DataError(
            message: response.data["message"] ?? "Bir hata oluştu");
      } else if (response.statusCode == 500) {
        return DataError(message: response.data["message"]);
      } else {
        return DataError(
            message: response.data["message"] ?? "Bir hata oluştu");
      }
    } on DioException catch (e) {
      return DataError(message: e.message);
    }
  }

  void _logProgress(int sent, int total) {
    if (kDebugMode) {}
  }

  Options _buildOptions(String method) {
    return Options(
      sendTimeout: const Duration(milliseconds: 55000),
      method: method,
      contentType: "application/json",
      maxRedirects: 5,
      headers: {
        "Content-Type": "application/json",
        'accept': 'application/json',
        "Authorization": "Bearer $_bearerToken",
      },
      receiveTimeout: const Duration(milliseconds: 55000),
      responseType: ResponseType.json,
      followRedirects: false,
      // will not throw errors
      validateStatus: (status) => true,
    );
  }

  void updateBearerToken(String? token) {
    _bearerToken = token;
    notifyListeners();
  }
}
