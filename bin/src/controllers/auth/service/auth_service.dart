import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shelf/shelf.dart';

import '../../../data/database/database.dart';
import '../../../utils/jwt_utils.dart';
import '../../base_controller.dart';

class AuthService extends ResponseTemplates {
  final Database database;

  AuthService(this.database);

  Future<Response> auth(Request request) async {
    try {
      final paramsStr = await request.readAsString();
      final params = jsonDecode(paramsStr);
      final login = params['login'];
      final password = params['password'];

      final user = await database.authDao.getUserWithLogin(login);

      final encodedPasswordString = encodePassword(password);

      if (user == null || user.password != encodedPasswordString) {
        return Response.forbidden(
          error(errorMessage: 'Неверный логин или пароль!'),
        );
      }

      final token = await JWTUtils.getJWT({'userId': user.userId});

      return Response.ok(
        ok({
          'userId': user.userId,
          'token': token,
        }),
      );
    } catch (e) {
      return Response.forbidden(error(errorMessage: e.toString()));
    }
  }

  Future<Response> register(Request request) async {
    try {
      final paramsStr = await request.readAsString();
      final params = jsonDecode(paramsStr);
      final login = params['login'];
      final password = params['password'];
      final confirm = params['confirm'];

      if (password != confirm) {
        return Response.forbidden(error(errorMessage: "Пароли не совпадают"));
      }

      final user = await database.authDao.getUserWithLogin(login);

      if (user != null) {
        return Response.forbidden(
            error(errorMessage: "Пользователь с таким логином уже существует"));
      }

      final encodedPasswordString = encodePassword(password);

      final newId = await database.authDao
          .addUser(login: login, password: encodedPasswordString);

      final token = await JWTUtils.getJWT({'userId': newId});

      final response = {
        'userId': newId,
        'token': token,
      };

      final encodedData = ok(response);

      print(encodedData);

      return Response.ok(encodedData);
    } catch (e) {
      return Response.forbidden(error(errorMessage: e.toString()));
    }
  }

  String encodePassword(String password) {
    final encodedPasswordDigest = sha256.convert(utf8.encode(password));

    final encodedPasswordString = base64Encode(encodedPasswordDigest.bytes);
    return encodedPasswordString;
  }
}
