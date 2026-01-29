import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/database_helper.dart';
import '../providers/cart_provider.dart';
import '../widgets/menu_item_card.dart';
import 'payment_page.dart';

class MenuPage extends StatefulWidget {
  final bool isTab;
  MenuPage({this.isTab = false});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Future<List<Map<String, dynamic>>> _getMenu() async {
    final db = await DatabaseHelper.instance.database;
    return await db.query('menu_items');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Mixue"),
        automaticallyImplyLeading: false, // Umpetin tombol back kalau di tab
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getMenu(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Menu kosong"));
          }

          final menu = snapshot.data!;

          return ListView.builder(
            itemCount: menu.length,
            padding: EdgeInsets.only(bottom: 80),
            itemBuilder: (context, i) {
              final item = menu[i];
              return MenuItemCard(item: item);
            },
          );
        },
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.itemCount == 0 || widget.isTab)
            return SizedBox.shrink(); // Umpetin kalau kosong atau di mode tab
          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PaymentPage()),
              );
            },
            label: Text("Lihat Keranjang"),
            icon: Icon(Icons.shopping_cart),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          );
        },
      ),
    );
  }
}
