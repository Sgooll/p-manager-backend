
import 'package:password_manager_back/src/controllers/auth/service/auth_service.dart';
import 'package:password_manager_back/src/controllers/base_controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../data/database/database.dart';

part 'auth_controller.g.dart';

class AuthController extends ResponseTemplates {
  final Database database;

  AuthController(this.database);

  @Route.post('/login')
  Future<Response> auth(Request request) async {
    final service = AuthService(database);
    final response = service.auth(request);

    return response;
  }

  @Route.post('/register')
  Future<Response> register(Request request) async {
    final service = AuthService(database);

    final response = service.register(request);

    return response;
  }

  Router get router => _$AuthControllerRouter(this);

  Handler get handler => _$AuthControllerRouter(this).call;
}
