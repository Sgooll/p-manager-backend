import 'package:password_manager_back/src/controllers/auth/auth_controller.dart';
import 'package:password_manager_back/src/controllers/password/password_controller.dart';
import 'package:password_manager_back/src/data/database/database.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'api.g.dart';

class Api {
  Api(this.database);

  final Database database;

  @Route.mount('/auth')
  Router get _auth => AuthController(database).router;

  @Route.mount('/password')
  Router get _passwords => PasswordController(database).router;

  Router get router => _$ApiRouter(this);

  Handler get handler => _$ApiRouter(this).call;
}
