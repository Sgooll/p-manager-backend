import 'dart:convert';

import 'package:shelf/shelf.dart';

class CustomResponse {
  static String ok(Map<String, dynamic> data) {
    print('data1 = ${data}');
    return _responseTemplate(data);
  }

  static String error({required String errorMessage}) {
    return _responseTemplate({}, errorMessage: errorMessage);
  }

  static String _responseTemplate(Map<String, dynamic> data,
      {String? errorMessage}) {
    print('data = $data');
    final isErrorResponse = errorMessage != null;

    final response = {
      'apiSuccess': !isErrorResponse,
      if (isErrorResponse) 'error': errorMessage,
      'data': data
    };

    print(jsonEncode(response));
    return jsonEncode(response);
  }
}
