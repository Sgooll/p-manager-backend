import 'package:get_it/get_it.dart';
import 'package:password_manager_back/src/data/database/database.dart';

final injector = GetIt.instance;

void setupInjector() {
  injector.registerSingleton<Database>(Database());
}
