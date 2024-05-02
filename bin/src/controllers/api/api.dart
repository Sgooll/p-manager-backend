import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../data/database/database.dart';
import '../auth/auth_controller.dart';
import '../password/password_controller.dart';

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
