import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class MenuItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const MenuItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: item['image_asset'] != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        item['image_asset'],
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(Icons.icecream, color: Colors.pink, size: 40),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  if (item['description'] != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        item['description'],
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Text(
                    "Rp ${item['price']}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Consumer<CartProvider>(
              builder: (context, cart, child) {
                int qty = cart.items[item['id']]?['quantity'] ?? 0;
                return Row(
                  children: [
                    if (qty > 0)
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => cart.removeItem(item['id']),
                      ),
                    if (qty > 0)
                      Text(
                        "$qty",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    IconButton(
                      icon: Icon(Icons.add_circle, color: Colors.green),
                      onPressed: () => cart.addItem(item),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
