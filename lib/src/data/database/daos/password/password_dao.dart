import 'dart:convert';
import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:password_manager_back/src/data/database/database.dart';
import 'package:password_manager_back/src/data/database/tables.dart';

part 'password_dao.g.dart';

@DriftAccessor(
  tables: [
    Passwords,
  ],
)
class PasswordDao extends DatabaseAccessor<Database> with _$PasswordDaoMixin {
  PasswordDao(Database db) : super(db);

  // Future<User?> getPassword(int passwordId) async {
  //   return db.call(() async => await (db.select(users)
  //     ..where((tbl) => tbl.login.equals(login)))
  //       .getSingleOrNull());
  // }

  Future<int> addPassword(
      {required int userId,
      required String password,
      String? url,
      String? description,
      String? name}) async {
    return db.into(passwords).insert(PasswordsCompanion(
        password: Value(password),
        name: Value(name),
        description: Value(description),
        url: Value(url),
        userId: Value(userId)));
  }
}
