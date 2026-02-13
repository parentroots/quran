import '../../utils/constant/app_strings.dart';

class ApiResponseModel {
  final int? _statusCode;
  final Map? _data;

  ApiResponseModel(this._statusCode, this._data);

  bool get isSuccess => _statusCode == 200;

  int get statusCode => _statusCode ?? 500;

  String get message {
    if (_statusCode == 502) {
      return AppString.startServer;
    }
    return _data?['message']?.toString() ?? AppString.someThingWrong;
  }

  Map get data => _data ?? {};
}
