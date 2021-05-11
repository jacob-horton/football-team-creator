// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Player extends DataClass implements Insertable<Player> {
  final int id;
  final String name;
  final int number;
  final int score;
  final String colour;
  Player(
      {required this.id,
      required this.name,
      required this.number,
      required this.score,
      required this.colour});
  factory Player.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Player(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      number:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}number'])!,
      score: intType.mapFromDatabaseResponse(data['${effectivePrefix}score'])!,
      colour:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}colour'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['number'] = Variable<int>(number);
    map['score'] = Variable<int>(score);
    map['colour'] = Variable<String>(colour);
    return map;
  }

  PlayersCompanion toCompanion(bool nullToAbsent) {
    return PlayersCompanion(
      id: Value(id),
      name: Value(name),
      number: Value(number),
      score: Value(score),
      colour: Value(colour),
    );
  }

  factory Player.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Player(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      number: serializer.fromJson<int>(json['number']),
      score: serializer.fromJson<int>(json['score']),
      colour: serializer.fromJson<String>(json['colour']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'number': serializer.toJson<int>(number),
      'score': serializer.toJson<int>(score),
      'colour': serializer.toJson<String>(colour),
    };
  }

  Player copyWith(
          {int? id, String? name, int? number, int? score, String? colour}) =>
      Player(
        id: id ?? this.id,
        name: name ?? this.name,
        number: number ?? this.number,
        score: score ?? this.score,
        colour: colour ?? this.colour,
      );
  @override
  String toString() {
    return (StringBuffer('Player(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('number: $number, ')
          ..write('score: $score, ')
          ..write('colour: $colour')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(name.hashCode,
          $mrjc(number.hashCode, $mrjc(score.hashCode, colour.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Player &&
          other.id == this.id &&
          other.name == this.name &&
          other.number == this.number &&
          other.score == this.score &&
          other.colour == this.colour);
}

class PlayersCompanion extends UpdateCompanion<Player> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> number;
  final Value<int> score;
  final Value<String> colour;
  const PlayersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.number = const Value.absent(),
    this.score = const Value.absent(),
    this.colour = const Value.absent(),
  });
  PlayersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int number,
    required int score,
    required String colour,
  })  : name = Value(name),
        number = Value(number),
        score = Value(score),
        colour = Value(colour);
  static Insertable<Player> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? number,
    Expression<int>? score,
    Expression<String>? colour,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (number != null) 'number': number,
      if (score != null) 'score': score,
      if (colour != null) 'colour': colour,
    });
  }

  PlayersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? number,
      Value<int>? score,
      Value<String>? colour}) {
    return PlayersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      score: score ?? this.score,
      colour: colour ?? this.colour,
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
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (colour.present) {
      map['colour'] = Variable<String>(colour.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('number: $number, ')
          ..write('score: $score, ')
          ..write('colour: $colour')
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

  final VerificationMeta _colourMeta = const VerificationMeta('colour');
  @override
  late final GeneratedTextColumn colour = _constructColour();
  GeneratedTextColumn _constructColour() {
    return GeneratedTextColumn(
      'colour',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, number, score, colour];
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
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
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
    if (data.containsKey('colour')) {
      context.handle(_colourMeta,
          colour.isAcceptableOrUnknown(data['colour']!, _colourMeta));
    } else if (isInserting) {
      context.missing(_colourMeta);
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $PlayersTable players = $PlayersTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [players];
}
