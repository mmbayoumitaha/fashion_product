import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import '../models/product.dart';
import 'db_constants.dart';
import 'db_helper.dart';

class Crud {
  Crud._();

  static final Crud instance = Crud._();


  ValueNotifier<List<Product>> favoritesNotifier = ValueNotifier([]);
  ValueNotifier<List<Product>> cartNotifier = ValueNotifier([]);
  ValueNotifier<int> cartCountNotifier = ValueNotifier(0);


  Future<int> addToFavorites(Product product) async {
    Database db = await DbHelper.instance.getDbInstance();
    int row = await db.insert(
      DbConstants.favoritesTable,
      product.toFavoriteMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    selectAllFavorites();
    return row;
  }


  Future<int> removeFromFavorites(int productId) async {
    Database db = await DbHelper.instance.getDbInstance();
    int row = await db.delete(
      DbConstants.favoritesTable,
      where: '${DbConstants.colProductId}=?',
      whereArgs: [productId],
    );
    selectAllFavorites();
    return row;
  }

  bool isFavorite(int productId) {
    return favoritesNotifier.value.any((p) => p.id == productId);
  }

  // Toggle favorite status
  Future<void> toggleFavorite(Product product) async {
    if (isFavorite(product.id)) {
      await removeFromFavorites(product.id);
    } else {
      await addToFavorites(product);
    }
  }

  void selectAllFavorites() async {
    Database db = await DbHelper.instance.getDbInstance();
    List<Map<String, dynamic>> results = await db.query(
      DbConstants.favoritesTable,
    );
    favoritesNotifier.value = results.map((e) => Product.fromMap(e)).toList();
  }


  Future<int> addToCart(Product product) async {
    Database db = await DbHelper.instance.getDbInstance();


    List<Map<String, dynamic>> existing = await db.query(
      DbConstants.cartTable,
      where: '${DbConstants.colProductId}=?',
      whereArgs: [product.id],
    );

    int row;
    if (existing.isNotEmpty) {
      int currentQty = existing.first[DbConstants.colQuantity] as int;
      row = await db.update(
        DbConstants.cartTable,
        {DbConstants.colQuantity: currentQty + 1},
        where: '${DbConstants.colProductId}=?',
        whereArgs: [product.id],
      );
    } else {
      row = await db.insert(
        DbConstants.cartTable,
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    selectAllCartItems();
    _updateCartCount();
    return row;
  }

  Future<int> removeFromCart(int productId) async {
    Database db = await DbHelper.instance.getDbInstance();
    int row = await db.delete(
      DbConstants.cartTable,
      where: '${DbConstants.colProductId}=?',
      whereArgs: [productId],
    );
    selectAllCartItems();
    _updateCartCount();
    return row;
  }

  Future<int> updateCartQuantity(int productId, int quantity) async {
    Database db = await DbHelper.instance.getDbInstance();
    int row;
    if (quantity <= 0) {
      row = await removeFromCart(productId);
    } else {
      row = await db.update(
        DbConstants.cartTable,
        {DbConstants.colQuantity: quantity},
        where: '${DbConstants.colProductId}=?',
        whereArgs: [productId],
      );
      selectAllCartItems();
      _updateCartCount();
    }
    return row;
  }

  void selectAllCartItems() async {
    Database db = await DbHelper.instance.getDbInstance();
    List<Map<String, dynamic>> results = await db.query(DbConstants.cartTable);
    cartNotifier.value = results.map((e) => Product.fromMap(e)).toList();
  }

  void _updateCartCount() async {
    Database db = await DbHelper.instance.getDbInstance();
    var result = await db.rawQuery(
      'SELECT SUM(${DbConstants.colQuantity}) as total FROM ${DbConstants.cartTable}',
    );
    cartCountNotifier.value = (result.first['total'] as int?) ?? 0;
  }

  Future<int> clearCart() async {
    Database db = await DbHelper.instance.getDbInstance();
    int row = await db.delete(DbConstants.cartTable);
    selectAllCartItems();
    _updateCartCount();
    return row;
  }

  void initialize() {
    selectAllFavorites();
    selectAllCartItems();
    _updateCartCount();
  }
}
