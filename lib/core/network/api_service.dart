import 'dart:developer';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import './api_endpoint.dart';
import './api_response_model.dart';
import '../../utils/app_strings.dart';

class ApiService {
  ApiService._();

  static late Dio _dio;
  static late PersistCookieJar _cookieJar;

  static Future<void> init() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    _cookieJar = PersistCookieJar(
      storage: FileStorage("$appDocPath/.cookies/"),
    );

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoint.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        receiveDataWhenStatusError: true,
      ),
    );

    _dio.interceptors.add(CookieManager(_cookieJar));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (!options.headers.containsKey('Content-Type')) {
            options.headers['Content-Type'] = 'application/json';
          }

          log('--> ${options.method} ${options.uri}');
          log('Headers: ${options.headers}');
          log('Body: ${options.data}');

          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('<-- ${response.statusCode} ${response.requestOptions.uri}');
          log('Response Data: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
            log('Global Auth Error: ${e.response?.statusCode}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  static Future<ApiResponseModel> get(String endpoint,
      {Map<String, dynamic>? queryParameters, Options? options}) {
    return _request(endpoint,
        method: 'GET', queryParameters: queryParameters, options: options);
  }

  static Future<ApiResponseModel> post(String endpoint,
      {dynamic data, Options? options}) {
    return _request(endpoint, method: 'POST', data: data, options: options);
  }

  static Future<ApiResponseModel> put(String endpoint,
      {dynamic data, Options? options}) {
    return _request(endpoint, method: 'PUT', data: data, options: options);
  }

  static Future<ApiResponseModel> patch(String endpoint,
      {dynamic data, Options? options}) {
    return _request(endpoint, method: 'PATCH', data: data, options: options);
  }

  static Future<ApiResponseModel> delete(String endpoint,
      {dynamic data, Options? options}) {
    return _request(endpoint, method: 'DELETE', data: data, options: options);
  }

  static Future<ApiResponseModel> multipart(String endpoint,
      {required FormData formData, Options? options}) {
    return _request(endpoint, method: 'POST', data: formData, options: options);
  }

  static Future<ApiResponseModel> multipartImage(String endpoint, File file,
      {String key = "image", Map<String, dynamic>? extraData}) async {
    final String? mimeType = lookupMimeType(file.path);
    final FormData formData = FormData.fromMap({
      key: await MultipartFile.fromFile(
        file.path,
        contentType: mimeType != null ? DioMediaType.parse(mimeType) : null,
      ),
      if (extraData != null) ...extraData,
    });
    return _request(endpoint, method: 'POST', data: formData);
  }

  static Future<ApiResponseModel> multipartImages(
      String endpoint, List<File> files,
      {String key = "images", Map<String, dynamic>? extraData}) async {
    final List<MultipartFile> multipartFiles = [];
    for (var file in files) {
      final String? mimeType = lookupMimeType(file.path);
      multipartFiles.add(await MultipartFile.fromFile(
        file.path,
        contentType: mimeType != null ? DioMediaType.parse(mimeType) : null,
      ));
    }

    final FormData formData = FormData.fromMap({
      key: multipartFiles,
      if (extraData != null) ...extraData,
    });
    return _request(endpoint, method: 'POST', data: formData);
  }

  static Future<ApiResponseModel> multipartUpdate(
      String endpoint, Map<String, dynamic> data,
      {String method = "PATCH"}) {
    return _request(endpoint, method: method, data: FormData.fromMap(data));
  }

  static Future<ApiResponseModel> _request(
    String endpoint, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.request(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: method),
      );
      return ApiResponseModel(response.statusCode, response.data);
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return ApiResponseModel(400, null);
    }
  }

  static ApiResponseModel _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return ApiResponseModel(408, {"message": AppString.requestTimeOut});
    }

    if (e.type == DioExceptionType.connectionError) {
      return ApiResponseModel(503, {"message": AppString.noInternetConnection});
    }

    if (e.type == DioExceptionType.badResponse) {
      return ApiResponseModel(e.response?.statusCode, e.response?.data);
    }

    return ApiResponseModel(400, null);
  }
}
