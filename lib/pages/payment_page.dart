import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/queue_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/cart_item_card.dart';
import 'customer_main_page.dart';

class PaymentPage extends StatefulWidget {
  final bool isTab;
  PaymentPage({this.isTab = false});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessing = false;

  Future<void> _processOrder() async {
    setState(() => _isProcessing = true);

    final cart = Provider.of<CartProvider>(context, listen: false);
    final queue = Provider.of<QueueProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    if (auth.currentUser == null) {
      // Harusnya gak kejadian di alur normal
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: User not logged in")));
      return;
    }

    await queue.addOrder(auth.currentUser!['id'], cart.items, cart.totalPrice);

    // Kosongin keranjang
    cart.clearCart();

    setState(() => _isProcessing = false);

    // Bersihin stack navigasi terus balik ke halaman utama
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => CustomerMainPage()),
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Konfirmasi Pesanan"),
        automaticallyImplyLeading: !widget.isTab,
      ),
      body: cart.itemCount == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Belum ada pesanan",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Silakan ke menu untuk memesan es krim!",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: cart.items.length,
                    itemBuilder: (context, i) {
                      final key = cart.items.keys.elementAt(i);
                      final item = cart.items[key]!;
                      return CartItemCard(
                        item: {
                          'id': item['id'],
                          'name': item['name'],
                          'price': item['price'],
                          'quantity': item['quantity'],
                          'image_asset': item['image_asset'],
                        },
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(blurRadius: 5, color: Colors.black12),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Bayar", style: TextStyle(fontSize: 18)),
                          Text(
                            "Rp ${cart.totalPrice}",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: _isProcessing
                            ? Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: cart.items.isEmpty
                                    ? null
                                    : () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text("Konfirmasi Pesanan"),
                                            content: Text(
                                              "Apakah pesanan Anda sudah benar?\nTotal: Rp ${cart.totalPrice}",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx),
                                                child: Text("Cek Lagi"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(ctx);
                                                  _processOrder();
                                                },
                                                child: Text(
                                                  "Ya, Pesan",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                child: Text(
                                  "Bayar & Pesan",
                                  style: TextStyle(fontSize: 18),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
