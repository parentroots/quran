import 'dart:async';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import './api_endpoint.dart';
import '../../utils/constant/app_strings.dart';
import './api_response_model.dart';

class ApiService {
  static final Dio _dio = _getMyDio();

  /// ========== [ HTTP METHODS ] ========== ///
  static Future<ApiResponseModel> post(
    String url, {
    dynamic body,
    Map<String, String>? header,
  }) =>
      _request(url, "POST", body: body, header: header);

  static Future<ApiResponseModel> get(
    String url, {
    Map<String, String>? header,
    Map<String, dynamic>? queryParameters,
  }) =>
      _request(url, "GET", header: header, queryParameters: queryParameters);

  static Future<ApiResponseModel> put(
    String url, {
    dynamic body,
    Map<String, String>? header,
  }) =>
      _request(url, "PUT", body: body, header: header);

  static Future<ApiResponseModel> patch(
    String url, {
    dynamic body,
    Map<String, String>? header,
  }) =>
      _request(url, "PATCH", body: body, header: header);

  static Future<ApiResponseModel> delete(
    String url, {
    dynamic body,
    Map<String, String>? header,
  }) =>
      _request(url, "DELETE", body: body, header: header);



  static Future<ApiResponseModel> multipartImage(
    String url, {
    Map<String, String> header = const {},
    Map<String, String> body = const {},
    String method = "POST",
    List files = const [],
  }) async {
    FormData formData = FormData();

    for (var item in files) {
      String imageName = item['name'] ?? "image";
      String? imagePath = item['image'];
      if (imagePath != null && imagePath.isNotEmpty) {
        File file = File(imagePath);
        String extension = file.path.split('.').last.toLowerCase();
        String? mimeType = lookupMimeType(imagePath);
        formData.files.add(
          MapEntry(
            imageName,
            await MultipartFile.fromFile(
              imagePath,
              filename: "$imageName.$extension",
              contentType: mimeType != null
                  ? DioMediaType.parse(mimeType)
                  : DioMediaType.parse("image/jpeg"),
            ),
          ),
        );
      }
    }

    body.forEach((key, value) {
      formData.fields.add(MapEntry(key, value));
    });

    final headers = Map<String, String>.from(header);
    headers['Content-Type'] = 'multipart/form-data';

    return _request(url, method, body: formData, header: headers);
  }

  /// ========== [ API REQUEST HANDLER ] ========== ///
  static Future<ApiResponseModel> _request(
    String url,
    String method, {
    dynamic body,
    Map<String, String>? header,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.request(
        url,
        data: body,
        queryParameters: queryParameters,
        options: Options(method: method, headers: header),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static ApiResponseModel _handleResponse(Response response) {
    if (response.statusCode == 201) {
      return ApiResponseModel(200, response.data);
    }
    return ApiResponseModel(response.statusCode, response.data);
  }

  static ApiResponseModel _handleError(dynamic error) {
    try {
      if (error is DioException) {
        return _handleDioException(error);
      }
      return ApiResponseModel(500, {});
    } catch (e) {
      return ApiResponseModel(500, {});
    }
  }


  static ApiResponseModel _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiResponseModel(408, {"message": AppString.requestTimeOut});

      case DioExceptionType.badResponse:
        return ApiResponseModel(
          error.response?.statusCode,
          error.response?.data,
        );

      case DioExceptionType.connectionError:
        return ApiResponseModel(503, {
          "message": AppString.noInternetConnection,
        });

      default:
        return ApiResponseModel(400, {});
    }
  }

  /// Static init for cookies - can be called from main.dart
  static Future<void> init() async {
    await cookieJarInit();
  }
}

/// ========== [ DIO INSTANCE WITH INTERCEPTORS ] ========== ///

CookieJar cookieJar = CookieJar();

Future<CookieJar> cookieJarInit() async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("${dir.path}/.cookies/"),
    );
    return cookieJar;
  } catch (e) {
    debugPrint("cookieJarInit Error: $e");
    return cookieJar;
  }
}

Dio _getMyDio() {
  final Dio dio = Dio();

  dio.interceptors.addAll([
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options
          ..headers['Content-Type'] ??= 'application/json'
          ..connectTimeout = const Duration(seconds: 30)
          ..sendTimeout = const Duration(seconds: 30)
          ..receiveDataWhenStatusError = true
          ..responseType = ResponseType.json
          ..receiveTimeout = const Duration(seconds: 30)
          ..baseUrl =
              options.baseUrl.startsWith('http') ? '' : ApiEndpoint.baseUrl;
        handler.next(options);
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    ),
    CookieManager(cookieJar),
    // apiLog(), // Skipping as it's not found in project
  ]);

  return dio;
}
