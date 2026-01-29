import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'queue_page.dart';
import 'menu_page.dart';
import 'payment_page.dart';
import '../providers/cart_provider.dart';

class CustomerMainPage extends StatefulWidget {
  @override
  _CustomerMainPageState createState() => _CustomerMainPageState();
}

class _CustomerMainPageState extends State<CustomerMainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    QueuePage(isTab: true),
    MenuPage(isTab: true),
    PaymentPage(isTab: true), // Payment Page acts as the "Cart" tab
  ];

  @override
  Widget build(BuildContext context) {
    // Cek apa perlu badge notifikasi keranjang, navigasi simpel dulu

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Antrian"),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, cart, child) {
                return Stack(
                  children: [
                    Icon(Icons.shopping_cart),
                    if (cart.itemCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '${cart.itemCount}',
                            style: TextStyle(color: Colors.white, fontSize: 8),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: "Pesanan",
          ),
        ],
      ),
    );
  }
}
