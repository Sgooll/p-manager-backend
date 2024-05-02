import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

import '../../utils/error.dart';
import 'daos/auth/auth_dao.dart';
import 'daos/password/password_dao.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  daos: <Type>[
    AuthDao,
    PasswordDao,
  ],
  tables: <Type>[
    Passwords,
    Users,
  ],
)
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
      onUpgrade: (Migrator m, int from, int to) async {},
      beforeOpen: (OpeningDetails details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      });

  Future<T?> call<T>(Future<T?> Function() fn) async =>
      await fn().onError((Object? error, StackTrace stackTrace) {
        ErrorHandler.catchError(error.toString(), methodName: 'Database.call');
        return null;
      });

  Future<void> clearDatabase() async {
    for (final TableInfo<Table, Object?> table in allTables) {
      await delete(table).go();
    }
  }
}

LazyDatabase _openConnection() => LazyDatabase(() async {
      final File file = File(p.join('database', 'password_manager_db.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
