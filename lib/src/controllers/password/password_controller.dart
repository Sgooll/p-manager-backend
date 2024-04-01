import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:password_manager_back/password_manager_back.dart';
import 'package:password_manager_back/src/controllers/base_controller.dart';
import 'package:password_manager_back/src/utils/encrypt_service.dart';
import 'package:password_manager_back/src/utils/jwt_utils.dart';
import 'package:password_manager_back/src/utils/response.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../data/database/database.dart';

part 'password_controller.g.dart'; // generated with 'pub run build_runner build'

class PasswordController extends ResponseTemplates {
  final Database database;

  PasswordController(this.database);

  @Route.post('/add')
  Future<Response> add(Request request) async {
    final data = await request.readAsString();
    try {
      final map = jsonDecode(data);
      final token = map['token'];
      final password = map['password'];
      if (password is! String) {
        return Response.forbidden(error(errorMessage: 'password обязателен'));
      }
      final name = map['name'];
      final url = map['url'];
      final description = map['description'];

      final payload = await JWTUtils.verifyJWT(token);

      if (payload == null) {
        return Response.forbidden(
            error(errorMessage: 'Авторизация не пройдена'));
      }

      final encryptedPassword = await EncryptService.encodeRSA(password);

      final passwordId = await database.passwordDao.addPassword(
          userId: payload['userId'],
          password: encryptedPassword,
          url: url,
          description: description,
          name: name);

      return Response.ok(ok({'id': passwordId}));
    } catch (e) {
      return Response.forbidden(error(errorMessage: e.toString()));
    }
  }

  @Route.post('/get')
  Future<Response> get(Request request) async {
    final data = await request.readAsString();
    try {
      final map = jsonDecode(data);
      final token = map['token'];
      final passwordId = map['id'];
      if (passwordId is! int) {
        return Response.forbidden(error(errorMessage: 'id обязателен'));
      }

      final payload = await JWTUtils.verifyJWT(token);

      if (payload == null) {
        return Response.forbidden(
            error(errorMessage: 'Авторизация не пройдена'));
      }

      final password = await database.passwordDao.getPassword(passwordId);

      if (password == null) {
        return Response.forbidden(
            error(errorMessage: 'Пароля с таким id не найдено'));
      }

      final dectyptedPassword =
          await EncryptService.decodeRSA(password.password);

      return Response.ok(ok({
        'password': password.copyWith(password: dectyptedPassword).toJson()
      }));
    } catch (e) {
      return Response.forbidden(error(errorMessage: e.toString()));
    }
  }

  @Route.post('/send')
  Future<Response> send(Request request) async {
    final data = await request.readAsString();
    try {
      final map = jsonDecode(data);

      request.requestedUri;

      // final token = map['token'];
      final address = map['address'];
      final port = map['port'];
      final currentClient = clients.firstWhereOrNull((e) =>
          e.remoteAddress.address.toString() == address &&
          e.remotePort.toString() == port);

      if (currentClient == null) {
        return Response.forbidden(
            error(errorMessage: 'Десктопный клинет не подключен'));
      }

      currentClient.write('HELLO_)');

      return Response.ok(ok({'data': "${currentClient}"}));
    } catch (e) {
      return Response.forbidden(error(errorMessage: e.toString()));
    }
  }

  @Route.post('/join')
  Future<Response> join(Request request) async {
    final data = await request.readAsString();
    try {
      final map = jsonDecode(data);

      // final token = map['token'];
      final address = map['address'];
      final port = map['port'];

      final currentClient = clients.firstWhereOrNull((e) =>
          e.remoteAddress.address.toString() == address &&
          e.remotePort.toString() == port);

      if (currentClient == null) {
        return Response.forbidden(
            error(errorMessage: 'Десктопный клинет не подключен'));
      }


      currentClient.write("{'command': 'join'}");

      return Response.ok(ok({'data': true}));
    } catch (e) {
      return Response.forbidden(error(errorMessage: e.toString()));
    }
  }

  Router get router => _$PasswordControllerRouter(this);

  Handler get handler => _$PasswordControllerRouter(this).call;
}
