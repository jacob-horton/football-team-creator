// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Player extends DataClass implements Insertable<Player> {
  final int id;
  final int number;
  final int score;
  final int preferredPosition;
  final String name;
  Player(
      {required this.id,
      required this.number,
      required this.score,
      required this.preferredPosition,
      required this.name});
  factory Player.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Player(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      number:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}number'])!,
      score: intType.mapFromDatabaseResponse(data['${effectivePrefix}score'])!,
      preferredPosition: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}prefered_position'])!,
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['number'] = Variable<int>(number);
    map['score'] = Variable<int>(score);
    map['prefered_position'] = Variable<int>(preferredPosition);
    map['name'] = Variable<String>(name);
    return map;
  }

  PlayersCompanion toCompanion(bool nullToAbsent) {
    return PlayersCompanion(
      id: Value(id),
      number: Value(number),
      score: Value(score),
      preferredPosition: Value(preferredPosition),
      name: Value(name),
    );
  }

  factory Player.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Player(
      id: serializer.fromJson<int>(json['id']),
      number: serializer.fromJson<int>(json['number']),
      score: serializer.fromJson<int>(json['score']),
      preferredPosition: serializer.fromJson<int>(json['preferredPosition']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'number': serializer.toJson<int>(number),
      'score': serializer.toJson<int>(score),
      'preferredPosition': serializer.toJson<int>(preferredPosition),
      'name': serializer.toJson<String>(name),
    };
  }

  Player copyWith(
          {int? id,
          int? number,
          int? score,
          int? preferredPosition,
          String? name}) =>
      Player(
        id: id ?? this.id,
        number: number ?? this.number,
        score: score ?? this.score,
        preferredPosition: preferredPosition ?? this.preferredPosition,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Player(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('score: $score, ')
          ..write('preferredPosition: $preferredPosition, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          number.hashCode,
          $mrjc(score.hashCode,
              $mrjc(preferredPosition.hashCode, name.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Player &&
          other.id == this.id &&
          other.number == this.number &&
          other.score == this.score &&
          other.preferredPosition == this.preferredPosition &&
          other.name == this.name);
}

class PlayersCompanion extends UpdateCompanion<Player> {
  final Value<int> id;
  final Value<int> number;
  final Value<int> score;
  final Value<int> preferredPosition;
  final Value<String> name;
  const PlayersCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.score = const Value.absent(),
    this.preferredPosition = const Value.absent(),
    this.name = const Value.absent(),
  });
  PlayersCompanion.insert({
    this.id = const Value.absent(),
    required int number,
    required int score,
    required int preferredPosition,
    required String name,
  })  : number = Value(number),
        score = Value(score),
        preferredPosition = Value(preferredPosition),
        name = Value(name);
  static Insertable<Player> custom({
    Expression<int>? id,
    Expression<int>? number,
    Expression<int>? score,
    Expression<int>? preferredPosition,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (score != null) 'score': score,
      if (preferredPosition != null) 'prefered_position': preferredPosition,
      if (name != null) 'name': name,
    });
  }

  PlayersCompanion copyWith(
      {Value<int>? id,
      Value<int>? number,
      Value<int>? score,
      Value<int>? preferredPosition,
      Value<String>? name}) {
    return PlayersCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      score: score ?? this.score,
      preferredPosition: preferredPosition ?? this.preferredPosition,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (preferredPosition.present) {
      map['prefered_position'] = Variable<int>(preferredPosition.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('score: $score, ')
          ..write('preferredPosition: $preferredPosition, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $PlayersTable extends Players with TableInfo<$PlayersTable, Player> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PlayersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedIntColumn id = _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedIntColumn number = _constructNumber();
  GeneratedIntColumn _constructNumber() {
    return GeneratedIntColumn(
      'number',
      $tableName,
      false,
    );
  }

  final VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedIntColumn score = _constructScore();
  GeneratedIntColumn _constructScore() {
    return GeneratedIntColumn(
      'score',
      $tableName,
      false,
    );
  }

  final VerificationMeta _preferredPositionMeta =
      const VerificationMeta('preferredPosition');
  @override
  late final GeneratedIntColumn preferredPosition =
      _constructPreferredPosition();
  GeneratedIntColumn _constructPreferredPosition() {
    return GeneratedIntColumn(
      'prefered_position',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedTextColumn name = _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, number, score, preferredPosition, name];
  @override
  $PlayersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'players';
  @override
  final String actualTableName = 'players';
  @override
  VerificationContext validateIntegrity(Insertable<Player> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('prefered_position')) {
      context.handle(
          _preferredPositionMeta,
          preferredPosition.isAcceptableOrUnknown(
              data['prefered_position']!, _preferredPositionMeta));
    } else if (isInserting) {
      context.missing(_preferredPositionMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Player map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Player.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PlayersTable createAlias(String alias) {
    return $PlayersTable(_db, alias);
  }
}

class PlayerPosition extends DataClass implements Insertable<PlayerPosition> {
  final int playerId;
  final int team;
  final double x;
  final double y;
  PlayerPosition(
      {required this.playerId,
      required this.team,
      required this.x,
      required this.y});
  factory PlayerPosition.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    return PlayerPosition(
      playerId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}player_id'])!,
      team: intType.mapFromDatabaseResponse(data['${effectivePrefix}team'])!,
      x: doubleType.mapFromDatabaseResponse(data['${effectivePrefix}x'])!,
      y: doubleType.mapFromDatabaseResponse(data['${effectivePrefix}y'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['player_id'] = Variable<int>(playerId);
    map['team'] = Variable<int>(team);
    map['x'] = Variable<double>(x);
    map['y'] = Variable<double>(y);
    return map;
  }

  PlayerPositionsCompanion toCompanion(bool nullToAbsent) {
    return PlayerPositionsCompanion(
      playerId: Value(playerId),
      team: Value(team),
      x: Value(x),
      y: Value(y),
    );
  }

  factory PlayerPosition.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PlayerPosition(
      playerId: serializer.fromJson<int>(json['playerId']),
      team: serializer.fromJson<int>(json['team']),
      x: serializer.fromJson<double>(json['x']),
      y: serializer.fromJson<double>(json['y']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'playerId': serializer.toJson<int>(playerId),
      'team': serializer.toJson<int>(team),
      'x': serializer.toJson<double>(x),
      'y': serializer.toJson<double>(y),
    };
  }

  PlayerPosition copyWith({int? playerId, int? team, double? x, double? y}) =>
      PlayerPosition(
        playerId: playerId ?? this.playerId,
        team: team ?? this.team,
        x: x ?? this.x,
        y: y ?? this.y,
      );
  @override
  String toString() {
    return (StringBuffer('PlayerPosition(')
          ..write('playerId: $playerId, ')
          ..write('team: $team, ')
          ..write('x: $x, ')
          ..write('y: $y')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      playerId.hashCode, $mrjc(team.hashCode, $mrjc(x.hashCode, y.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is PlayerPosition &&
          other.playerId == this.playerId &&
          other.team == this.team &&
          other.x == this.x &&
          other.y == this.y);
}

class PlayerPositionsCompanion extends UpdateCompanion<PlayerPosition> {
  final Value<int> playerId;
  final Value<int> team;
  final Value<double> x;
  final Value<double> y;
  const PlayerPositionsCompanion({
    this.playerId = const Value.absent(),
    this.team = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
  });
  PlayerPositionsCompanion.insert({
    this.playerId = const Value.absent(),
    required int team,
    required double x,
    required double y,
  })  : team = Value(team),
        x = Value(x),
        y = Value(y);
  static Insertable<PlayerPosition> custom({
    Expression<int>? playerId,
    Expression<int>? team,
    Expression<double>? x,
    Expression<double>? y,
  }) {
    return RawValuesInsertable({
      if (playerId != null) 'player_id': playerId,
      if (team != null) 'team': team,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
    });
  }

  PlayerPositionsCompanion copyWith(
      {Value<int>? playerId,
      Value<int>? team,
      Value<double>? x,
      Value<double>? y}) {
    return PlayerPositionsCompanion(
      playerId: playerId ?? this.playerId,
      team: team ?? this.team,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    if (team.present) {
      map['team'] = Variable<int>(team.value);
    }
    if (x.present) {
      map['x'] = Variable<double>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<double>(y.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerPositionsCompanion(')
          ..write('playerId: $playerId, ')
          ..write('team: $team, ')
          ..write('x: $x, ')
          ..write('y: $y')
          ..write(')'))
        .toString();
  }
}

class $PlayerPositionsTable extends PlayerPositions
    with TableInfo<$PlayerPositionsTable, PlayerPosition> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PlayerPositionsTable(this._db, [this._alias]);
  final VerificationMeta _playerIdMeta = const VerificationMeta('playerId');
  @override
  late final GeneratedIntColumn playerId = _constructPlayerId();
  GeneratedIntColumn _constructPlayerId() {
    return GeneratedIntColumn('player_id', $tableName, false,
        $customConstraints: 'REFERENCES players(id)');
  }

  final VerificationMeta _teamMeta = const VerificationMeta('team');
  @override
  late final GeneratedIntColumn team = _constructTeam();
  GeneratedIntColumn _constructTeam() {
    return GeneratedIntColumn(
      'team',
      $tableName,
      false,
    );
  }

  final VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedRealColumn x = _constructX();
  GeneratedRealColumn _constructX() {
    return GeneratedRealColumn(
      'x',
      $tableName,
      false,
    );
  }

  final VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedRealColumn y = _constructY();
  GeneratedRealColumn _constructY() {
    return GeneratedRealColumn(
      'y',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [playerId, team, x, y];
  @override
  $PlayerPositionsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'player_positions';
  @override
  final String actualTableName = 'player_positions';
  @override
  VerificationContext validateIntegrity(Insertable<PlayerPosition> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('player_id')) {
      context.handle(_playerIdMeta,
          playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta));
    }
    if (data.containsKey('team')) {
      context.handle(
          _teamMeta, team.isAcceptableOrUnknown(data['team']!, _teamMeta));
    } else if (isInserting) {
      context.missing(_teamMeta);
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    } else if (isInserting) {
      context.missing(_xMeta);
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    } else if (isInserting) {
      context.missing(_yMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {playerId};
  @override
  PlayerPosition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return PlayerPosition.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PlayerPositionsTable createAlias(String alias) {
    return $PlayerPositionsTable(_db, alias);
  }
}

class SaveSlot extends DataClass implements Insertable<SaveSlot> {
  final int id;
  final String name;
  final String team1Colour;
  final String team2Colour;
  SaveSlot(
      {required this.id,
      required this.name,
      required this.team1Colour,
      required this.team2Colour});
  factory SaveSlot.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return SaveSlot(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      team1Colour: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}team1_colour'])!,
      team2Colour: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}team2_colour'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['team1_colour'] = Variable<String>(team1Colour);
    map['team2_colour'] = Variable<String>(team2Colour);
    return map;
  }

  SaveSlotsCompanion toCompanion(bool nullToAbsent) {
    return SaveSlotsCompanion(
      id: Value(id),
      name: Value(name),
      team1Colour: Value(team1Colour),
      team2Colour: Value(team2Colour),
    );
  }

  factory SaveSlot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return SaveSlot(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      team1Colour: serializer.fromJson<String>(json['team1Colour']),
      team2Colour: serializer.fromJson<String>(json['team2Colour']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'team1Colour': serializer.toJson<String>(team1Colour),
      'team2Colour': serializer.toJson<String>(team2Colour),
    };
  }

  SaveSlot copyWith(
          {int? id, String? name, String? team1Colour, String? team2Colour}) =>
      SaveSlot(
        id: id ?? this.id,
        name: name ?? this.name,
        team1Colour: team1Colour ?? this.team1Colour,
        team2Colour: team2Colour ?? this.team2Colour,
      );
  @override
  String toString() {
    return (StringBuffer('SaveSlot(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('team1Colour: $team1Colour, ')
          ..write('team2Colour: $team2Colour')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(name.hashCode, $mrjc(team1Colour.hashCode, team2Colour.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is SaveSlot &&
          other.id == this.id &&
          other.name == this.name &&
          other.team1Colour == this.team1Colour &&
          other.team2Colour == this.team2Colour);
}

class SaveSlotsCompanion extends UpdateCompanion<SaveSlot> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> team1Colour;
  final Value<String> team2Colour;
  const SaveSlotsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.team1Colour = const Value.absent(),
    this.team2Colour = const Value.absent(),
  });
  SaveSlotsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String team1Colour,
    required String team2Colour,
  })  : name = Value(name),
        team1Colour = Value(team1Colour),
        team2Colour = Value(team2Colour);
  static Insertable<SaveSlot> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? team1Colour,
    Expression<String>? team2Colour,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (team1Colour != null) 'team1_colour': team1Colour,
      if (team2Colour != null) 'team2_colour': team2Colour,
    });
  }

  SaveSlotsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? team1Colour,
      Value<String>? team2Colour}) {
    return SaveSlotsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      team1Colour: team1Colour ?? this.team1Colour,
      team2Colour: team2Colour ?? this.team2Colour,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (team1Colour.present) {
      map['team1_colour'] = Variable<String>(team1Colour.value);
    }
    if (team2Colour.present) {
      map['team2_colour'] = Variable<String>(team2Colour.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaveSlotsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('team1Colour: $team1Colour, ')
          ..write('team2Colour: $team2Colour')
          ..write(')'))
        .toString();
  }
}

class $SaveSlotsTable extends SaveSlots
    with TableInfo<$SaveSlotsTable, SaveSlot> {
  final GeneratedDatabase _db;
  final String? _alias;
  $SaveSlotsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedIntColumn id = _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedTextColumn name = _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _team1ColourMeta =
      const VerificationMeta('team1Colour');
  @override
  late final GeneratedTextColumn team1Colour = _constructTeam1Colour();
  GeneratedTextColumn _constructTeam1Colour() {
    return GeneratedTextColumn(
      'team1_colour',
      $tableName,
      false,
    );
  }

  final VerificationMeta _team2ColourMeta =
      const VerificationMeta('team2Colour');
  @override
  late final GeneratedTextColumn team2Colour = _constructTeam2Colour();
  GeneratedTextColumn _constructTeam2Colour() {
    return GeneratedTextColumn(
      'team2_colour',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, team1Colour, team2Colour];
  @override
  $SaveSlotsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'save_slots';
  @override
  final String actualTableName = 'save_slots';
  @override
  VerificationContext validateIntegrity(Insertable<SaveSlot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('team1_colour')) {
      context.handle(
          _team1ColourMeta,
          team1Colour.isAcceptableOrUnknown(
              data['team1_colour']!, _team1ColourMeta));
    } else if (isInserting) {
      context.missing(_team1ColourMeta);
    }
    if (data.containsKey('team2_colour')) {
      context.handle(
          _team2ColourMeta,
          team2Colour.isAcceptableOrUnknown(
              data['team2_colour']!, _team2ColourMeta));
    } else if (isInserting) {
      context.missing(_team2ColourMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaveSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return SaveSlot.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SaveSlotsTable createAlias(String alias) {
    return $SaveSlotsTable(_db, alias);
  }
}

class SaveSlotPlayer extends DataClass implements Insertable<SaveSlotPlayer> {
  final int playerId;
  final int saveSlotId;
  final int team;
  final double x;
  final double y;
  SaveSlotPlayer(
      {required this.playerId,
      required this.saveSlotId,
      required this.team,
      required this.x,
      required this.y});
  factory SaveSlotPlayer.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    return SaveSlotPlayer(
      playerId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}player_id'])!,
      saveSlotId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}save_slot_id'])!,
      team: intType.mapFromDatabaseResponse(data['${effectivePrefix}team'])!,
      x: doubleType.mapFromDatabaseResponse(data['${effectivePrefix}x'])!,
      y: doubleType.mapFromDatabaseResponse(data['${effectivePrefix}y'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['player_id'] = Variable<int>(playerId);
    map['save_slot_id'] = Variable<int>(saveSlotId);
    map['team'] = Variable<int>(team);
    map['x'] = Variable<double>(x);
    map['y'] = Variable<double>(y);
    return map;
  }

  SaveSlotPlayersCompanion toCompanion(bool nullToAbsent) {
    return SaveSlotPlayersCompanion(
      playerId: Value(playerId),
      saveSlotId: Value(saveSlotId),
      team: Value(team),
      x: Value(x),
      y: Value(y),
    );
  }

  factory SaveSlotPlayer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return SaveSlotPlayer(
      playerId: serializer.fromJson<int>(json['playerId']),
      saveSlotId: serializer.fromJson<int>(json['saveSlotId']),
      team: serializer.fromJson<int>(json['team']),
      x: serializer.fromJson<double>(json['x']),
      y: serializer.fromJson<double>(json['y']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'playerId': serializer.toJson<int>(playerId),
      'saveSlotId': serializer.toJson<int>(saveSlotId),
      'team': serializer.toJson<int>(team),
      'x': serializer.toJson<double>(x),
      'y': serializer.toJson<double>(y),
    };
  }

  SaveSlotPlayer copyWith(
          {int? playerId, int? saveSlotId, int? team, double? x, double? y}) =>
      SaveSlotPlayer(
        playerId: playerId ?? this.playerId,
        saveSlotId: saveSlotId ?? this.saveSlotId,
        team: team ?? this.team,
        x: x ?? this.x,
        y: y ?? this.y,
      );
  @override
  String toString() {
    return (StringBuffer('SaveSlotPlayer(')
          ..write('playerId: $playerId, ')
          ..write('saveSlotId: $saveSlotId, ')
          ..write('team: $team, ')
          ..write('x: $x, ')
          ..write('y: $y')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      playerId.hashCode,
      $mrjc(saveSlotId.hashCode,
          $mrjc(team.hashCode, $mrjc(x.hashCode, y.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is SaveSlotPlayer &&
          other.playerId == this.playerId &&
          other.saveSlotId == this.saveSlotId &&
          other.team == this.team &&
          other.x == this.x &&
          other.y == this.y);
}

class SaveSlotPlayersCompanion extends UpdateCompanion<SaveSlotPlayer> {
  final Value<int> playerId;
  final Value<int> saveSlotId;
  final Value<int> team;
  final Value<double> x;
  final Value<double> y;
  const SaveSlotPlayersCompanion({
    this.playerId = const Value.absent(),
    this.saveSlotId = const Value.absent(),
    this.team = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
  });
  SaveSlotPlayersCompanion.insert({
    required int playerId,
    required int saveSlotId,
    required int team,
    required double x,
    required double y,
  })  : playerId = Value(playerId),
        saveSlotId = Value(saveSlotId),
        team = Value(team),
        x = Value(x),
        y = Value(y);
  static Insertable<SaveSlotPlayer> custom({
    Expression<int>? playerId,
    Expression<int>? saveSlotId,
    Expression<int>? team,
    Expression<double>? x,
    Expression<double>? y,
  }) {
    return RawValuesInsertable({
      if (playerId != null) 'player_id': playerId,
      if (saveSlotId != null) 'save_slot_id': saveSlotId,
      if (team != null) 'team': team,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
    });
  }

  SaveSlotPlayersCompanion copyWith(
      {Value<int>? playerId,
      Value<int>? saveSlotId,
      Value<int>? team,
      Value<double>? x,
      Value<double>? y}) {
    return SaveSlotPlayersCompanion(
      playerId: playerId ?? this.playerId,
      saveSlotId: saveSlotId ?? this.saveSlotId,
      team: team ?? this.team,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    if (saveSlotId.present) {
      map['save_slot_id'] = Variable<int>(saveSlotId.value);
    }
    if (team.present) {
      map['team'] = Variable<int>(team.value);
    }
    if (x.present) {
      map['x'] = Variable<double>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<double>(y.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaveSlotPlayersCompanion(')
          ..write('playerId: $playerId, ')
          ..write('saveSlotId: $saveSlotId, ')
          ..write('team: $team, ')
          ..write('x: $x, ')
          ..write('y: $y')
          ..write(')'))
        .toString();
  }
}

class $SaveSlotPlayersTable extends SaveSlotPlayers
    with TableInfo<$SaveSlotPlayersTable, SaveSlotPlayer> {
  final GeneratedDatabase _db;
  final String? _alias;
  $SaveSlotPlayersTable(this._db, [this._alias]);
  final VerificationMeta _playerIdMeta = const VerificationMeta('playerId');
  @override
  late final GeneratedIntColumn playerId = _constructPlayerId();
  GeneratedIntColumn _constructPlayerId() {
    return GeneratedIntColumn('player_id', $tableName, false,
        $customConstraints: 'REFERENCES players(id)');
  }

  final VerificationMeta _saveSlotIdMeta = const VerificationMeta('saveSlotId');
  @override
  late final GeneratedIntColumn saveSlotId = _constructSaveSlotId();
  GeneratedIntColumn _constructSaveSlotId() {
    return GeneratedIntColumn('save_slot_id', $tableName, false,
        $customConstraints: 'REFERENCES save_slots(id)');
  }

  final VerificationMeta _teamMeta = const VerificationMeta('team');
  @override
  late final GeneratedIntColumn team = _constructTeam();
  GeneratedIntColumn _constructTeam() {
    return GeneratedIntColumn(
      'team',
      $tableName,
      false,
    );
  }

  final VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedRealColumn x = _constructX();
  GeneratedRealColumn _constructX() {
    return GeneratedRealColumn(
      'x',
      $tableName,
      false,
    );
  }

  final VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedRealColumn y = _constructY();
  GeneratedRealColumn _constructY() {
    return GeneratedRealColumn(
      'y',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [playerId, saveSlotId, team, x, y];
  @override
  $SaveSlotPlayersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'save_slot_players';
  @override
  final String actualTableName = 'save_slot_players';
  @override
  VerificationContext validateIntegrity(Insertable<SaveSlotPlayer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('player_id')) {
      context.handle(_playerIdMeta,
          playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta));
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('save_slot_id')) {
      context.handle(
          _saveSlotIdMeta,
          saveSlotId.isAcceptableOrUnknown(
              data['save_slot_id']!, _saveSlotIdMeta));
    } else if (isInserting) {
      context.missing(_saveSlotIdMeta);
    }
    if (data.containsKey('team')) {
      context.handle(
          _teamMeta, team.isAcceptableOrUnknown(data['team']!, _teamMeta));
    } else if (isInserting) {
      context.missing(_teamMeta);
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    } else if (isInserting) {
      context.missing(_xMeta);
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    } else if (isInserting) {
      context.missing(_yMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {playerId, saveSlotId};
  @override
  SaveSlotPlayer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return SaveSlotPlayer.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SaveSlotPlayersTable createAlias(String alias) {
    return $SaveSlotPlayersTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $PlayersTable players = $PlayersTable(this);
  late final $PlayerPositionsTable playerPositions =
      $PlayerPositionsTable(this);
  late final $SaveSlotsTable saveSlots = $SaveSlotsTable(this);
  late final $SaveSlotPlayersTable saveSlotPlayers =
      $SaveSlotPlayersTable(this);
  late final PlayerDao playerDao = PlayerDao(this as AppDatabase);
  late final CurrentPlayerDao currentPlayerDao =
      CurrentPlayerDao(this as AppDatabase);
  late final SaveSlotDao saveSlotDao = SaveSlotDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [players, playerPositions, saveSlots, saveSlotPlayers];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$PlayerDaoMixin on DatabaseAccessor<AppDatabase> {
  $PlayersTable get players => attachedDatabase.players;
}
mixin _$CurrentPlayerDaoMixin on DatabaseAccessor<AppDatabase> {
  $PlayerPositionsTable get playerPositions => attachedDatabase.playerPositions;
  $PlayersTable get players => attachedDatabase.players;
}
mixin _$SaveSlotDaoMixin on DatabaseAccessor<AppDatabase> {
  $PlayerPositionsTable get playerPositions => attachedDatabase.playerPositions;
  $SaveSlotsTable get saveSlots => attachedDatabase.saveSlots;
  $SaveSlotPlayersTable get saveSlotPlayers => attachedDatabase.saveSlotPlayers;
  $PlayersTable get players => attachedDatabase.players;
}
