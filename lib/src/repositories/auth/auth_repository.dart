import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:drift/drift.dart';
import 'package:password_manager_back/src/utils/jwt_utils.dart';
import 'package:password_manager_back/src/utils/response.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../data/database/database.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final Database database;

  AuthRepository(this.database);

  @Route.post('/login')
  Future<Response> auth(Request request) async {
    final data = await request.readAsString();
    try {
      final map = jsonDecode(data);
      final login = map['login'];
      final password = map['password'];

      final user = await database.authDao.getUserWithLogin(login);

      if (user == null || user.password != password) {
        return Response.forbidden(
            CustomResponse.error(errorMessage: 'Неверный логин или пароль!'));
      }

      final token = await JWTUtils.getJWT({'userId': user.userId});

      return Response.ok(CustomResponse.ok({
        'userId': user.userId,
        'token': token,
      }));
    } catch (e) {
      return Response.forbidden(
          CustomResponse.error(errorMessage: e.toString()));
    }
  }

  @Route.post('/register')
  Future<Response> register(Request request) async {
    final data = await request.readAsString();
    try {
      final map = jsonDecode(data);
      final login = map['login'];
      final password = map['password'];
      final confirm = map['confirm'];

      if (password != confirm) {
        return Response.forbidden(
            CustomResponse.error(errorMessage: "Пароли не совпадают"));
      }

      final user = await database.authDao.getUserWithLogin(login);

      if (user != null) {
        return Response.forbidden(CustomResponse.error(
            errorMessage: "Пользователь с таким логином уже существует"));
      }

      final newId =
          await database.authDao.addUser(login: login, password: password);

      final token = await JWTUtils.getJWT({'userId': newId});

      final response = {
        'userId': newId,
        'token': token,
      };

      print('RESPONSE = ${response}');

      final encodedData = CustomResponse.ok(response);

      print(encodedData);

      return Response.ok(encodedData);
    } catch (e) {
      return Response.forbidden(
          CustomResponse.error(errorMessage: e.toString()));
    }
  }

  Router get router => _$AuthRepositoryRouter(this);

  Handler get handler => _$AuthRepositoryRouter(this).call;


}
