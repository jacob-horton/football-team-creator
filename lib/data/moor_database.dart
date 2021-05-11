import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'moor_database.g.dart';

class Players extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get number => integer()();
  IntColumn get score => integer()();
  TextColumn get colour => text()(); // red, orange, green, blue, purple, pink
}

@UseMoor(tables: [Players])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Player>> getAllPLayers() => select(players).get();
  Stream<List<Player>> watchAllPLayers() => select(players).watch();
  Future insertPlayer(Insertable<Player> player) => into(players).insert(player);
  Future updatePlayer(Insertable<Player> player) => update(players).replace(player);
  Future deletePlayer(Insertable<Player> player) => delete(players).delete(player);
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}