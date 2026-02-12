import '../../utils/app_strings.dart';

class ApiResponseModel {
  final int? _statusCode;
  final Map<String, dynamic>? _responseData;

  ApiResponseModel(this._statusCode, this._responseData);

  bool get isSuccess => _statusCode == 200;

  int get statusCode => _statusCode ?? 500;

  String get message {
    if (_statusCode == 502) {
      return AppString.startServer;
    }
    return _responseData?["message"]?.toString() ?? AppString.someThingWrong;
  }

  Map<String, dynamic> get data => _responseData ?? {};
}
