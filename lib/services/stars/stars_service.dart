import 'dart:async';
import 'dart:core';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:students_guide/models/article_model.dart';
import 'package:students_guide/services/articles/cloud_const.dart';
import 'package:students_guide/services/stars/stars_const.dart';

class StarsService {
  static final StarsService _shared = StarsService._sharedInstance();

  factory StarsService() => _shared;

  StarsService._sharedInstance();

  static Database? _db;

  late Iterable<ArticleModel> _stars = [];

  init() async {
    String path = join(await getDatabasesPath(), DB_NAME);
    _db = await openDatabase(
      path,
      onCreate: (database, version) async {
        await database.execute("""
            CREATE TABLE $TABLE(
            $documentIdField TEXT PRIMARY KEY,  
            $titleField TEXT NOT NULL,
            $categoryField TEXT NOT NULL,
            $introField TEXT NOT NULL,
            $infoField TEXT NOT NULL,
            $dateField TEXT NOT NULL,
            $imageUrlField TEXT,
            $addressField TEXT,
            $emailField TEXT,
            $telField TEXT,
            $websiteField TEXT)
          """);
      },
      version: 1,
    );
  }

  addStar(ArticleModel articleModel) async {
    await init();
    return await _db?.insert(TABLE, articleModel.toMap());
  }

  Future<Iterable<ArticleModel>> getStars() async {
    await init();
    final db = _db;
    final results = (await db!.query(TABLE));
    return _stars =
        results.isNotEmpty ? results.map((e) => ArticleModel.fromMap(e)) : [];
  }

  updateStars(Stream<Iterable<ArticleModel>> articleModel) {
    return articleModel.map((articles) => articles.map(
          (e) => _db?.update(TABLE, e.toMap(),
              where: '$documentIdField = ?', whereArgs: [e.documentId]),
        ));
  }

  deleteStar(String id) async {
    await init();
    return await _db
        ?.delete(TABLE, where: '$documentIdField = ?', whereArgs: [id]);
  }

  Stream<bool> checkStar(String id) {
    final controller = StreamController<bool>();
    _db
        ?.query(TABLE,
            columns: [documentIdField],
            where: '$documentIdField = ?',
            whereArgs: [id])
        .then((value) {
      if (value.isNotEmpty) {
        controller.add(true);
      } else {
        controller.add(false);
      }
    });
    return controller.stream;
  }

  Future close() async {
    if (_db != null) {
      await _db!.close();
    }
  }
}
