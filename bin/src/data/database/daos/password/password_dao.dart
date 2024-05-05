import 'dart:convert';
import 'dart:developer';

import 'package:drift/drift.dart';

import '../../database.dart';
import '../../tables.dart';

part 'password_dao.g.dart';

@DriftAccessor(
  tables: [
    Passwords,
  ],
)
class PasswordDao extends DatabaseAccessor<Database> with _$PasswordDaoMixin {
  PasswordDao(Database db) : super(db);

  Future<Password?> getPassword(int userId, int passwordId) async {
    return db.call(() async => await (db.select(passwords)
          ..where((tbl) => tbl.id.equals(passwordId)))
        .getSingleOrNull());
  }

  Future<List<Password>?> getAllPasswords(int userId) async {
    return db.call(() async => await (db.select(passwords)
      ..where((tbl) => tbl.userId.equals(userId)))
        .get());
  }


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
