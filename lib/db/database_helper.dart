import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mixue_v2.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Tabel User
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT,
        role TEXT
      )
    ''');

    // Tabel Menu Item
    await db.execute('''
      CREATE TABLE menu_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price INTEGER,
        category TEXT,
        image_asset TEXT,
        description TEXT
      )
    ''');

    // Tabel Antrian (Header Pesanan)
    await db.execute('''
      CREATE TABLE queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        order_summary TEXT,
        total_price INTEGER,
        status TEXT, -- menunggu, proses, selesai
        created_at TEXT
      )
    ''');

    // Tabel Order Items (Detail Pesanan)
    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        queue_id INTEGER,
        menu_item_id INTEGER,
        menu_name TEXT,
        quantity INTEGER,
        price_at_order INTEGER,
        FOREIGN KEY (queue_id) REFERENCES queue (id)
      )
    ''');

    // Buat akun Admin bawaan
    var bytes = utf8.encode("admin123");
    var digest = sha256.convert(bytes);
    await db.insert("users", {
      "username": "admin",
      "password": digest.toString(),
      "role": "admin",
    });

    // Masukin data awal menu
    List<Map<String, dynamic>> menu = [
      {
        "name": "Ice Cream Cone",
        "price": 8000,
        "category": "Ice Cream",
        "image_asset": "assets/cone.png",
        "description": "Es krim cone renyah dengan rasa vanilla yang lembut.",
      },
      {
        "name": "Chocolate Cookies Sundae",
        "price": 14000,
        "category": "Ice Cream",
        "image_asset": "assets/choco_sundae.png",
        "description":
            "Es krim sundae dengan taburan remah kukis cokelat lezat.",
      },
      {
        "name": "Boba Sundae",
        "price": 16000,
        "category": "Ice Cream",
        "image_asset": "assets/boba_sundae.png",
        "description": "Es krim sundae topping boba kenyal dan saus gula aren.",
      },
      {
        "name": "Brown Sugar Pearl Milk Tea",
        "price": 19000,
        "category": "Tea",
        "image_asset": "assets/pearl_milk_tea.png",
        "description": "Teh susu segar dengan gula aren dan pearl.",
      },
      {
        "name": "Fresh Squeezed Lemonade",
        "price": 10000,
        "category": "Fruit Tea",
        "image_asset": "assets/lemonade.png",
        "description": "Minuman lemon segar peras asli, pengusir dahaga.",
      },
      {
        "name": "Mango Smoothie",
        "price": 16000,
        "category": "Smoothie",
        "image_asset": "assets/mango_smoothie.png",
        "description": "Smoothie mangga asli yang manis dan menyegarkan.",
      },
    ];

    for (var item in menu) {
      await db.insert("menu_items", item);
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
