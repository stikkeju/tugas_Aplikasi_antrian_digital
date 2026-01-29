import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class AuthProvider with ChangeNotifier {
  Map<String, dynamic>? _currentUser;

  Map<String, dynamic>? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser != null && _currentUser!['role'] == 'admin';

  Future<bool> login(String username, String password) async {
    final db = await DatabaseHelper.instance.database;

    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    String hashedPassword = digest.toString();

    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, hashedPassword],
    );

    if (maps.isNotEmpty) {
      _currentUser = maps.first;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<String?> register(String username, String password) async {
    final db = await DatabaseHelper.instance.database;

    // Cek dulu apakah usernya sudah ada di database
    final List<Map<String, dynamic>> check = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (check.isNotEmpty) {
      return "Username sudah digunakan";
    }

    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    String hashedPassword = digest.toString();

    await db.insert('users', {
      'username': username,
      'password': hashedPassword,
      'role': 'pelanggan',
    });

    return null; // Berhasil
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
