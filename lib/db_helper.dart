// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class DBHelper {
//   static final DBHelper _instance = DBHelper._internal();
//   Database? _database;
//
//   DBHelper._internal();
//
//   factory DBHelper() => _instance;
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     final dbPath = await getDatabasesPath();
//     return await openDatabase(
//       join(dbPath, 'app.db'),
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE users (
//             id INTEGER PRIMARY KEY,
//             fullname TEXT,
//             password TEXT,
//             type TEXT
//           )
//         ''');
//         await db.execute('''
//           CREATE TABLE product (
//             code INTEGER PRIMARY KEY,
//             product_name TEXT,
//             price REAL,
//             image_url TEXT,
//             qu INTEGER,
//             discount REAL
//           )
//         ''');
//         await db.execute('''
//           CREATE TABLE fav (
//             id INTEGER PRIMARY KEY,
//             product_code INTEGER,
//             user_id INTEGER,
//             FOREIGN KEY (user_id) REFERENCES users (id),
//             FOREIGN KEY (product_code) REFERENCES product (code)
//           )
//         ''');
//         await db.execute('''
//           CREATE TABLE cart (
//             id INTEGER PRIMARY KEY,
//             product_code INTEGER,
//             user_id INTEGER,
//             qu INTEGER,
//             FOREIGN KEY (user_id) REFERENCES users (id),
//             FOREIGN KEY (product_code) REFERENCES product (code)
//           )
//         ''');
//       },
//     );
//   }
//
//   Future<int> registerUser(String fullname, String password, String type) async {
//     final db = await database;
//     return await db.insert('users', {
//       'fullname': fullname,
//       'password': password,
//       'type': type,
//     });
//   }
//
//   Future<Map<String, dynamic>?> loginUser(String fullname, String password) async {
//     final db = await database;
//     final result = await db.query(
//       'users',
//       where: 'fullname = ? AND password = ?',
//       whereArgs: [fullname, password],
//     );
//     return result.isNotEmpty ? result.first : null;
//   }
// }

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  Database? _database;

  DBHelper._internal();

  factory DBHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database with necessary tables and ensure foreign key constraints
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'app.db'),
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onConfigure: (db) async {
        // Enable foreign key constraints
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  // Create necessary tables for users, products, favorites, and cart
  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullname TEXT NOT NULL,
        password TEXT NOT NULL,
        type TEXT CHECK(type IN ('admin', 'user')) NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS product (
        code INTEGER PRIMARY KEY AUTOINCREMENT,
        product_name TEXT NOT NULL,
        price REAL NOT NULL,
        image_url TEXT,
        qu INTEGER DEFAULT 0,
        discount REAL DEFAULT 0.0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS fav (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_code INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (product_code) REFERENCES product (code) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_code INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        qu INTEGER DEFAULT 1,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (product_code) REFERENCES product (code) ON DELETE CASCADE
      )
    ''');
  }

  // Register a new user
  Future<int> registerUser(String fullname, String password, String type) async {
    try {
      final db = await database;
      return await db.insert('users', {
        'fullname': fullname,
        'password': password,
        'type': type,
      });
    } catch (e) {
      print('Error registering user: $e');
      return -1; // Indicate failure
    }
  }

  // Login user by checking fullname and password
  Future<Map<String, dynamic>?> loginUser(String fullname, String password) async {
    try {
      final db = await database;
      final result = await db.query(
        'users',
        where: 'fullname = ? AND password = ?',
        whereArgs: [fullname, password],
        limit: 1,
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print('Error logging in user: $e');
      return null;
    }
  }

  // Add a product (upsert functionality: insert or update if exists)
  Future<int> addOrUpdateProduct({
    int? code,
    required String productName,
    required double price,
    required String imageUrl,
    required int quantity,
    required double discount,
  }) async {
    try {
      final db = await database;
      return await db.insert(
        'product',
        {
          'code': code,
          'product_name': productName,
          'price': price,
          'image_url': imageUrl,
          'qu': quantity,
          'discount': discount,
        },
        conflictAlgorithm: ConflictAlgorithm.replace, // Upsert behavior
      );
    } catch (e) {
      print('Error adding or updating product: $e');
      return -1;
    }
  }

  // Add a product to the cart
  Future<int> addToCart(int productCode, int userId, int quantity) async {
    try {
      final db = await database;
      return await db.insert('cart', {
        'product_code': productCode,
        'user_id': userId,
        'qu': quantity,
      });
    } catch (e) {
      print('Error adding to cart: $e');
      return -1;
    }
  }

  // Add a product to favorites
  Future<int> addToFavorites(int productCode, int userId) async {
    try {
      final db = await database;
      return await db.insert('fav', {
        'product_code': productCode,
        'user_id': userId,
      });
    } catch (e) {
      print('Error adding to favorites: $e');
      return -1;
    }
  }

  // Fetch all products
  Future<List<Map<String, dynamic>>> fetchAllProducts() async {
    final db = await database;
    return await db.query('product');
  }

  // Fetch all cart items for a specific user
  Future<List<Map<String, dynamic>>> fetchCartItems(int userId) async {
    final db = await database;
    return await db.rawQuery(
      '''
      SELECT product.*, cart.qu FROM product
      INNER JOIN cart ON product.code = cart.product_code
      WHERE cart.user_id = ?
      ''',
      [userId],
    );
  }

  // Fetch all favorite products for a specific user
  Future<List<Map<String, dynamic>>> fetchFavoriteItems(int userId) async {
    final db = await database;
    return await db.rawQuery(
      '''
      SELECT product.* FROM product
      INNER JOIN fav ON product.code = fav.product_code
      WHERE fav.user_id = ?
      ''',
      [userId],
    );
  }

  // Delete a product from the cart
  Future<int> removeFromCart(int productCode, int userId) async {
    final db = await database;
    return await db.delete(
      'cart',
      where: 'product_code = ? AND user_id = ?',
      whereArgs: [productCode, userId],
    );
  }

  // Delete a product from favorites
  Future<int> removeFromFavorites(int productCode, int userId) async {
    final db = await database;
    return await db.delete(
      'fav',
      where: 'product_code = ? AND user_id = ?',
      whereArgs: [productCode, userId],
    );
  }
}
