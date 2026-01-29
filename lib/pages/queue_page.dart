import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/queue_provider.dart';
import '../widgets/order_card.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';

class QueuePage extends StatefulWidget {
  final String? highlightNumber;
  final bool isTab;

  QueuePage({this.highlightNumber, this.isTab = false});

  @override
  _QueuePageState createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {
  // Timer auto-refresh bisa ditambah di sini, tapi sekarang andalin notif Provider dari DB lokal

  @override
  void initState() {
    super.initState();
    // Ambil data awal
    Future.microtask(
      () => Provider.of<QueueProvider>(context, listen: false).fetchQueue(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pake addPostFrameCallback biar konteks aman dan gak error pas build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QueueProvider>(context, listen: false).fetchQueue();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Antrian"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () =>
                Provider.of<QueueProvider>(context, listen: false).fetchQueue(),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Consumer<QueueProvider>(
        builder: (context, queueProvider, child) {
          if (queueProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final queueList = queueProvider.queue;
          // Urutan antrian sesuai Provider (terbaru/terlama), bisa disesuaikan di sini kalau mau dibalik

          if (queueList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Mumpung antrian kosong,\nayo pesan es krim favorit kamu sekarang!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            );
          }

          final displayList = queueList;

          return ListView.builder(
            itemCount: displayList.length,
            padding: EdgeInsets.all(10),
            itemBuilder: (context, i) {
              final item = displayList[i];

              return OrderCard(order: item, index: i, isAdmin: false);
            },
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Konfirmasi Logout"),
        content: Text("Apakah Anda yakin ingin keluar?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Batal")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
