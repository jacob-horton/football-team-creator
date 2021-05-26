import 'dart:io';

import 'package:football/bloc/team_colours/team_colours_bloc.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'moor_database.g.dart';

class Players extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get number => integer()();
  IntColumn get score => integer()();

  IntColumn get preferredPosition => integer().named('prefered_position')(); // 0 - defence, 1 - mid, 2 - attack
  TextColumn get name => text()();
}

class PlayerPositions extends Table {
  IntColumn get playerId => integer().customConstraint('REFERENCES players(id)')();
  IntColumn get team => integer()();

  RealColumn get x => real()();
  RealColumn get y => real()();

  @override
  Set<Column> get primaryKey => {playerId};
}

class SaveSlots extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get team1Colour => text()();
  TextColumn get team2Colour => text()();
}

class SaveSlotPlayers extends Table {
  IntColumn get playerId => integer().customConstraint('REFERENCES players(id)')();
  IntColumn get saveSlotId => integer().customConstraint('REFERENCES save_slots(id)')();
  IntColumn get team => integer()();

  RealColumn get x => real()();
  RealColumn get y => real()();

  @override
  Set<Column> get primaryKey => {playerId, saveSlotId};
}

class PlayerWithPosition {
  final Player player;
  final PlayerPosition position;

  PlayerWithPosition({required this.player, required this.position});
}

@UseMoor(tables: [Players, PlayerPositions, SaveSlots, SaveSlotPlayers], daos: [PlayerDao, CurrentPlayerDao, SaveSlotDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (_) async => await customStatement('PRAGMA foreign_keys = ON'),
        onUpgrade: (migrator, from, to) async {
          if (from == 1) await migrator.alterTable(TableMigration(players));
          if (from < 3) {
            await migrator.addColumn(saveSlots, saveSlots.team1Colour);
            await migrator.addColumn(saveSlots, saveSlots.team2Colour);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final script = File(Platform.script.toFilePath());
    final databasePath = File('${script.parent.path}/db.sqlite');
    return VmDatabase(databasePath);
  });
}

@UseDao(tables: [Players])
class PlayerDao extends DatabaseAccessor<AppDatabase> with _$PlayerDaoMixin {
  final AppDatabase db;

  PlayerDao(this.db) : super(db);

  Future<List<Player>> getAllPlayers() => select(players).get();
  Stream<List<Player>> watchAllPlayers({bool sorted = true, String nameFilter = ''}) {
    var selected = select(players)..where((p) => p.name.like('%' + nameFilter + '%'));

    if (sorted) selected = selected..orderBy([(t) => OrderingTerm(expression: t.name.lower())]);
    return selected.watch();
  }

  Future<int> insertPlayer(Insertable<Player> player) => into(players).insert(player);
  Future updatePlayer(Insertable<Player> player) => update(players).replace(player);
  Future deletePlayer(Insertable<Player> player) => delete(players).delete(player); // TODO: delete from saveslots
  Future deletePlayerFromID(int id) => (delete(players)..where((p) => p.id.equals(id))).go();

  Future<Player> getPlayer(int id) => (select(players)..where((p) => p.id.equals(id))).getSingle();
}

@UseDao(tables: [PlayerPositions, Players])
class CurrentPlayerDao extends DatabaseAccessor<AppDatabase> with _$CurrentPlayerDaoMixin {
  final AppDatabase db;

  CurrentPlayerDao(this.db) : super(db);

  Stream<List<PlayerWithPosition>> watchPlayersOnTeam(int team) {
    return (select(playerPositions)..where((t) => t.team.equals(team)))
        .join(
          [
            leftOuterJoin(
              players,
              players.id.equalsExp(playerPositions.playerId),
            ),
          ],
        )
        .map(
          (row) => PlayerWithPosition(
            player: row.readTable(players),
            position: row.readTable(playerPositions),
          ),
        )
        .watch();
  }

  Stream<List<PlayerWithPosition>> watchAllPlayers() {
    return select(playerPositions)
        .join(
          [
            leftOuterJoin(
              players,
              players.id.equalsExp(playerPositions.playerId),
            ),
          ],
        )
        .map(
          (row) => PlayerWithPosition(
            player: row.readTable(players),
            position: row.readTable(playerPositions),
          ),
        )
        .watch();
  }

  Future<List<PlayerWithPosition>> getAllPlayers() {
    return select(playerPositions)
        .join(
          [
            leftOuterJoin(
              players,
              players.id.equalsExp(playerPositions.playerId),
            ),
          ],
        )
        .map(
          (row) => PlayerWithPosition(
            player: row.readTable(players),
            position: row.readTable(playerPositions),
          ),
        )
        .get();
  }

  Future<List<PlayerWithPosition>> getPlayersOnTeam(int team) {
    return (select(playerPositions)..where((t) => t.team.equals(team)))
        .join(
          [
            leftOuterJoin(
              players,
              players.id.equalsExp(playerPositions.playerId),
            ),
          ],
        )
        .map(
          (row) => PlayerWithPosition(
            player: row.readTable(players),
            position: row.readTable(playerPositions),
          ),
        )
        .get();
  }

  void insertPlayers(List<Insertable<PlayerPosition>> players) async => batch((b) => b.insertAll(playerPositions, players));
  void updatePlayers(List<Insertable<PlayerPosition>> players) async => batch((b) => b.replaceAll(playerPositions, players));

  Future insertPlayer(Insertable<PlayerPosition> playerPosition) => into(playerPositions).insert(playerPosition);
  Future updatePlayer(Insertable<PlayerPosition> playerPosition) => update(playerPositions).replace(playerPosition);

  Future deletePlayer(Insertable<PlayerPosition> playerPosition) => delete(playerPositions).delete(playerPosition);
  Future deletePlayerFromID(int id) => (delete(playerPositions)..where((p) => p.playerId.equals(id))).go();

  Future removeAllPlayers() => delete(playerPositions).go();
}

@UseDao(tables: [PlayerPositions, SaveSlots, SaveSlotPlayers, Players])
class SaveSlotDao extends DatabaseAccessor<AppDatabase> with _$SaveSlotDaoMixin {
  final AppDatabase db;

  SaveSlotDao(this.db) : super(db);

  Future saveSlot(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> teamColours = prefs.getStringList(TeamColoursBloc.key) ?? TeamColoursBloc.defaultValues;

    int slotId = await into(saveSlots).insert(
      SaveSlotsCompanion(
        name: Value(name),
        team1Colour: Value(teamColours[0]),
        team2Colour: Value(teamColours[1]),
      ),
    );

    final currentPlayers = await db.currentPlayerDao.getAllPlayers();
    batch(
      (b) => b.insertAll(
        saveSlotPlayers,
        currentPlayers
            .map(
              (player) => SaveSlotPlayersCompanion(
                saveSlotId: Value(slotId),
                playerId: Value(player.player.id),
                team: Value(player.position.team),
                x: Value(player.position.x),
                y: Value(player.position.y),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<Slot> loadSlot(String name) async {
    final selectStatement = select(saveSlots)..where((slot) => slot.name.equals(name));
    final playersWithPositions = await selectStatement.join(
      [
        leftOuterJoin(
          saveSlotPlayers,
          saveSlotPlayers.saveSlotId.equalsExp(saveSlots.id),
        ),
        leftOuterJoin(
          players,
          players.id.equalsExp(saveSlotPlayers.playerId),
        ),
      ],
    ).map(
      (row) {
        return PlayerWithPosition(
          player: row.readTable(players),
          position: _convertSaveSlotPlayerToPosition(row.readTable(saveSlotPlayers)),
        );
      },
    ).get();

    final slot = (await selectStatement.getSingle());
    return Slot(players: playersWithPositions, team1Colour: slot.team1Colour, team2Colour: slot.team2Colour);
  }

  PlayerPosition _convertSaveSlotPlayerToPosition(SaveSlotPlayer player) {
    return PlayerPosition(playerId: player.playerId, team: player.team, x: player.x, y: player.y);
  }

  Stream<List<SaveSlot>> watchAllSlots() => select(saveSlots).watch();

  void deleteSlotFromId(int slotId) async {
    (delete(saveSlotPlayers)..where((player) => player.saveSlotId.equals(slotId))).go();
    (delete(saveSlots)..where((slot) => slot.id.equals(slotId))).go();
  }
}

class Slot {
  final List<PlayerWithPosition> players;
  final String team1Colour;
  final String team2Colour;

  Slot({required this.players, required this.team1Colour, required this.team2Colour});
}
