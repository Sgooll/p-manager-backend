import 'dart:convert';

abstract class ResponseTemplates {
  String ok(Map<String, dynamic> data) {
    return _responseTemplate(data);
  }

  String error({required String errorMessage}) {
    return _responseTemplate({}, errorMessage: errorMessage);
  }

  String _responseTemplate(Map<String, dynamic> data, {String? errorMessage}) {
    final isErrorResponse = errorMessage != null;

    final response = {
      'apiSuccess': !isErrorResponse,
      if (isErrorResponse) 'error': errorMessage,
      'data': data
    };

    return jsonEncode(response);
  }
}
