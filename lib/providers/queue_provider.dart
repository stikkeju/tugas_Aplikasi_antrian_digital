import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class QueueProvider with ChangeNotifier {
  List<Map<String, dynamic>> _queue = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get queue => _queue;
  bool get isLoading => _isLoading;

  Future<void> fetchQueue() async {
    _isLoading = true;
    notifyListeners();

    final db = await DatabaseHelper.instance.database;

    // Ambil data antrian beserta username, pakai rawQuery buat join tabel
    final List<Map<String, dynamic>> queueData = await db.rawQuery('''
      SELECT queue.*, users.username 
      FROM queue 
      INNER JOIN users ON queue.user_id = users.id 
      WHERE queue.status != 'selesai' AND queue.status != 'batal'
      ORDER BY queue.created_at ASC
    ''');

    // Kita butuh detail item buat tiap antrian, sesuai request user

    List<Map<String, dynamic>> fullQueue = [];

    for (var q in queueData) {
      final List<Map<String, dynamic>> rawItems = await db.query(
        'order_items',
        where: 'queue_id = ?',
        whereArgs: [q['id']],
      );

      // Normalisasi key item (price_at_order jadi price)
      final List<Map<String, dynamic>> items = rawItems.map((item) {
        return {...item, 'price': item['price'] ?? item['price_at_order']};
      }).toList();

      fullQueue.add({...q, 'items': items});
    }

    _queue = fullQueue;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addOrder(
    int userId,
    Map<int, Map<String, dynamic>> cartItems,
    int total,
  ) async {
    final db = await DatabaseHelper.instance.database;
    final now = DateTime.now().toString();

    // Bikin string ringkasan order (misal: "2x Es Krim, 1x Teh")
    List<String> summaryList = [];
    cartItems.forEach((key, item) {
      summaryList.add("${item['quantity']}x ${item['name']}");
    });
    String summary = summaryList.join(", ");

    // Masukin data ke tabel queue
    int queueId = await db.insert('queue', {
      'user_id': userId,
      'order_summary': summary,
      'total_price': total,
      'status': 'menunggu',
      'created_at': now,
    });

    // Masukin item-item orderan
    cartItems.forEach((key, item) async {
      await db.insert('order_items', {
        'queue_id': queueId,
        'menu_item_id': item['id'],
        'menu_name': item['name'],
        'quantity': item['quantity'],
        'price_at_order': item['price'],
      });
    });

    await fetchQueue();
  }

  Future<void> updateStatus(int id, String status) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'queue',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
    await fetchQueue();
  }
}
