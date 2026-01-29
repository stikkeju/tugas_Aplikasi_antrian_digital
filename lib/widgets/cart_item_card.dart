import 'package:flutter/material.dart';

class CartItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const CartItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: item['image_asset'] != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      item['image_asset'],
                      fit: BoxFit.cover,
                    ),
                  )
                  : Icon(Icons.icecream, color: Colors.pink),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Rp ${item['price']}",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "x${item['quantity']}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rp ${item['price'] * item['quantity']}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
