import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'db_constants.dart';

class DbHelper {
  DbHelper._();

  static final DbHelper instance = DbHelper._();

  Future<String> _getDbPath() async {
    String path = await getDatabasesPath();
    return join(path, DbConstants.dbName);
  }

  Future<Database> getDbInstance() async {
    String path = await _getDbPath();
    return await openDatabase(
      path,
      version: DbConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: _onDowngrade,
      onOpen: _onOpen,
      onConfigure: _onConfigure,
      readOnly: false,
      singleInstance: true,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) {
    debugPrint('on create called');
    try {
      String favoritesSql =
          '''
        CREATE TABLE ${DbConstants.favoritesTable}(
          ${DbConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${DbConstants.colProductId} INTEGER UNIQUE,
          ${DbConstants.colName} TEXT,
          ${DbConstants.colPrice} REAL,
          ${DbConstants.colImage} TEXT
        )
      ''';
      db.execute(favoritesSql);

      String cartSql =
          '''
        CREATE TABLE ${DbConstants.cartTable}(
          ${DbConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${DbConstants.colProductId} INTEGER UNIQUE,
          ${DbConstants.colName} TEXT,
          ${DbConstants.colPrice} REAL,
          ${DbConstants.colImage} TEXT,
          ${DbConstants.colQuantity} INTEGER DEFAULT 1
        )
      ''';
      db.execute(cartSql);
    } on DatabaseException catch (e) {
      debugPrint('error in creating tables ${e.toString()}');
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('on upgrade called');
  }

  FutureOr<void> _onDowngrade(Database db, int oldVersion, int newVersion) {
    debugPrint('on downgrade called');
  }

  FutureOr<void> _onOpen(Database db) {
    debugPrint('on open called');
  }

  FutureOr<void> _onConfigure(Database db) {
    debugPrint('on configure called');
  }
}
