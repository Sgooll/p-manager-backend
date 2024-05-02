import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

sealed class JWTUtils {
  static Future<String> getJWT(Map<String, dynamic> payload) async {
    final jwt = JWT(payload);

    final token =
        jwt.sign(SecretKey(await File('jwt_secret.pem').readAsString()));

    return token;
  }

  static Future<Map<String, dynamic>?> verifyJWT(String token) async {
    try {
      final jwt = JWT.verify(
          token, SecretKey(await File('jwt_secret.pem').readAsString()));
      return Map<String, dynamic>.from(jwt.payload);
    } on JWTExpiredException {
      return null;
    } on JWTException catch (ex) {
      return null;
    }
  }
}
