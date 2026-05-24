import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../cart/cart_state.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  factory DbHelper() => _instance;

  DbHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cart_database.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart_items(
        id INTEGER PRIMARY KEY,
        quantity INTEGER,
        title TEXT,
        price REAL,
        description TEXT,
        category TEXT,
        image TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE favorites(
          id INTEGER PRIMARY KEY
        )
      ''');
    }
  }

  // --- Cart Operations ---
  Future<void> insertOrUpdateCartItem(CartItem item) async {
    final db = await database;
    await db.insert(
      'cart_items',
      {
        'id': item.product.id,
        'quantity': item.quantity,
        'title': item.product.title,
        'price': item.product.price,
        'description': item.product.description,
        'category': item.product.category,
        'image': item.product.image,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCartItem(int productId) async {
    final db = await database;
    await db.delete(
      'cart_items',
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  Future<Map<int, CartItem>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart_items');
    
    Map<int, CartItem> items = {};
    for (var map in maps) {
      final product = Product(
        id: map['id'],
        title: map['title'],
        price: map['price'],
        description: map['description'],
        category: map['category'],
        image: map['image'],
      );
      items[product.id] = CartItem(product: product, quantity: map['quantity']);
    }
    return items;
  }

  // --- Favorite Operations ---
  Future<void> toggleFavorite(int productId, bool isLiked) async {
    final db = await database;
    if (isLiked) {
      await db.insert('favorites', {'id': productId}, conflictAlgorithm: ConflictAlgorithm.ignore);
    } else {
      await db.delete('favorites', where: 'id = ?', whereArgs: [productId]);
    }
  }

  Future<Set<int>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return maps.map((map) => map['id'] as int).toSet();
  }
}
