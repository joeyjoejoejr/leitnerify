import 'dart:async';
import 'package:leiterify/components/calendar.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/models.dart';

class DbProvider {
  DbProvider._();
  static final DbProvider db = DbProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    await Sqflite.devSetDebugModeOn(true);
    var databasePath = join(await getDatabasesPath(), 'lietnerify.db');
    deleteDatabase(databasePath);
    return await openDatabase(
      databasePath,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE cards ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "level INTEGER NOT NULL DEFAULT 1,"
            "front_side_id INTEGER NOT NULL,"
            "back_side_id INTEGER NOT NULL,"
            "created_at INTEGER NOT NULL"
            ")");
        await db.execute("CREATE TABLE sides ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "text TEXT,"
            "text_color INTEGER,"
            "image BLOB,"
            "elements TEXT,"
            "background_fill INTEGER"
            ")");
      },
    );
  }

  Future<int> createCard(Card newCard, Side front, Side back) async {
    final db = await database;
    final frontId = await db.insert("sides", await front.toMap());
    final backId = await db.insert("sides", await back.toMap());

    newCard.frontSideId = frontId;
    newCard.backSideId = backId;
    newCard.createdAt = DateTime.now();
    return db.insert("cards", newCard.toMap());
  }

  Future<int> queryCardsCreatedToday() async {
    final db = await database;
    final today = DateTime.now();
    final start =
        DateTime(today.year, today.month, today.day).millisecondsSinceEpoch;
    final end = DateTime(today.year, today.month, today.day, 23, 59, 59)
        .millisecondsSinceEpoch;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM cards WHERE created_at BETWEEN ? AND ?',
        [start, end]));
  }

  Future<int> queryCardCountByLevel(int level) async {
    final db = await database;
    return Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM cards WHERE level = ?', [level]));
  }

  Future<Card> queryNextCardByDay(int day) async {
    final db = await database;
    final levels = leitnerDays[day];

    for (int level in levels) {
      if (await queryCardCountByLevel(level) > 0) {
        List<Map<String, dynamic>> cards = await db.rawQuery(
          'SELECT * FROM cards WHERE level = ? ORDER BY RANDOM() LIMIT 1',
          [level],
        );
        final card = Card.fromMap(cards.first);

        List<Map<String, dynamic>> frontSides = await db.rawQuery(
          'SELECT * FROM sides WHERE id = ?',
          [card.frontSideId],
        );
        final frontSide = Side.fromMap(frontSides.first);
        card.frontSide = frontSide;

        List<Map<String, dynamic>> backSides = await db.rawQuery(
          'SELECT * FROM sides WHERE id = ?',
          [card.backSideId],
        );
        final backSide = Side.fromMap(backSides.first);
        card.backSide = backSide;

        return card;
      }
    }

    return null;
  }
}
