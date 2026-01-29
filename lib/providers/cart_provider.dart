import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final Map<int, Map<String, dynamic>> _items = {};

  Map<int, Map<String, dynamic>> get items => _items;

  int get itemCount => _items.length;

  int get totalPrice {
    int total = 0;
    _items.forEach((key, item) {
      total += (item['price'] as int) * (item['quantity'] as int);
    });
    return total;
  }

  void addItem(Map<String, dynamic> product) {
    if (_items.containsKey(product['id'])) {
      _items.update(
        product['id'],
        (existing) => {...existing, 'quantity': existing['quantity'] + 1},
      );
    } else {
      _items.putIfAbsent(
        product['id'],
        () => {
          'id': product['id'],
          'name': product['name'],
          'price': product['price'],
          'image_asset': product['image_asset'],
          'quantity': 1,
        },
      );
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!['quantity'] > 1) {
      _items.update(
        productId,
        (existing) => {...existing, 'quantity': existing['quantity'] - 1},
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
