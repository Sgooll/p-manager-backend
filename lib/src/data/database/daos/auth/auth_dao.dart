import 'dart:convert';
import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:password_manager_back/src/data/database/database.dart';
import 'package:password_manager_back/src/data/database/tables.dart';

part 'auth_dao.g.dart';

@DriftAccessor(
  tables: [
    Users,
  ],
)
class AuthDao extends DatabaseAccessor<Database> with _$AuthDaoMixin {
  AuthDao(Database db) : super(db);

  Future<User?> getUserWithLogin(String login) async {
    return db.call(() async => await (db.select(users)
          ..where((tbl) => tbl.login.equals(login)))
        .getSingleOrNull());
  }

  Future<int> addUser({required String login, required String password}) async {
    return db.into(users).insert(UsersCompanion(
          login: Value(login),
          password: Value(password),
        ));
  }
}
