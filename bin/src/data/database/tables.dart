import 'package:drift/drift.dart';

class Passwords extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get userId => integer()();

  TextColumn get password => text()();

  TextColumn get name => text().nullable()();

  TextColumn get url => text().nullable()();

  TextColumn get description => text().nullable()();
}

class Users extends Table {
  TextColumn get login => text()();

  TextColumn get password => text()();

  IntColumn get userId => integer().autoIncrement()();
}
