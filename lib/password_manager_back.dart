import 'package:password_manager_back/src/data/database/database.dart';
import 'package:password_manager_back/src/data/injector/injector.dart';
import 'package:password_manager_back/src/repositories/auth/auth_repository.dart';
import 'package:password_manager_back/src/repositories/main_repository/main_repository.dart';
import 'package:password_manager_back/src/repositories/password/password_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

void main() async {
  setupInjector();
  var connection = injector<Database>();

  MainRepository server = MainRepository(connection);

  var authServer = await shelf_io.serve(server.handler, 'localhost', 8080);

  //
  // // Enable content compression
  // server.autoCompress = true;

  print('Serving at http://${authServer.address.host}:${authServer.port}');
}
