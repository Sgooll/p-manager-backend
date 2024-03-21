import 'package:password_manager_back/src/data/database/database.dart';
import 'package:password_manager_back/src/repositories/auth/auth_repository.dart';
import 'package:password_manager_back/src/repositories/password/password_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'main_repository.g.dart';

class MainRepository {
  MainRepository(this.database);

  final Database database;

  @Route.mount('/auth')
  Router get _auth => AuthRepository(database).router;

  @Route.mount('/password')
  Router get _passwords => PasswordRepository(database).router;

  Router get router => _$MainRepositoryRouter(this);

  Handler get handler => _$MainRepositoryRouter(this).call;
}
