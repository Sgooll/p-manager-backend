import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:password_manager_back/src/utils/jwt_utils.dart';
import 'package:password_manager_back/src/utils/response.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../data/database/database.dart';

part 'password_repository.g.dart'; // generated with 'pub run build_runner build'

class PasswordRepository {
  final Database database;

  PasswordRepository(this.database);

  @Route.post('/add')
  Future<Response> auth(Request request) async {
    final data = await request.readAsString();
    try {
      final map = jsonDecode(data);
      final token = map['token'];
      final password = map['password'];
      final name = map['name'];
      final url = map['url'];
      final description = map['description'];

      final payload = await JWTUtils.verifyJWT(token);

      if (payload == null) {
        return Response.forbidden(
            CustomResponse.error(errorMessage: 'Авторизация не пройдена'));
      }








      return Response.ok(CustomResponse.ok({
        'valid': true,
      }));
    } catch (e) {
      return Response.forbidden(
          CustomResponse.error(errorMessage: e.toString()));
    }
  }

  Router get router => _$PasswordRepositoryRouter(this);

  Handler get handler => _$PasswordRepositoryRouter(this).call;
}
