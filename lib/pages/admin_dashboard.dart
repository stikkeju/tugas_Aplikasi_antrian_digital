import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/queue_provider.dart';
import '../widgets/order_card.dart';
import 'login_page.dart';
import '../providers/auth_provider.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<QueueProvider>(context, listen: false).fetchQueue(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Pesanan"),
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
      ),
      body: Consumer<QueueProvider>(
        builder: (context, queueProvider, child) {
          if (queueProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (queueProvider.queue.isEmpty) {
            return Center(child: Text("Belum ada antrian"));
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: queueProvider.queue.length,
            itemBuilder: (context, i) {
              final queue = queueProvider.queue[i];

              return OrderCard(
                order: queue,
                index: i,
                isAdmin: true,
                actions: Column(
                  children: [
                    Row(
                      children: [
                        // Tombol buat batalin pesanan
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _confirmAction(
                              context,
                              "Batalkan Pesanan?",
                              "Yakin ingin membatalkan pesanan ini?",
                              () => queueProvider.updateStatus(
                                queue['id'],
                                'batal',
                              ),
                              isDestructive: true,
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: BorderSide(color: Colors.red),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text("Batalkan"),
                          ),
                        ),
                        SizedBox(width: 8),
                        // Tombol aksi status
                        if (queue['status'] == 'menunggu')
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _confirmAction(
                                context,
                                "Mulai Proses?",
                                "Pesanan akan ditandai sebagai 'Sedang Diproses'.",
                                () => queueProvider.updateStatus(
                                  queue['id'],
                                  'proses',
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text("Proses"),
                            ),
                          )
                        else if (queue['status'] == 'proses')
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _confirmAction(
                                context,
                                "Selesaikan Pesanan?",
                                "Pesanan akan ditandai sebagai 'Selesai'.",
                                () => queueProvider.updateStatus(
                                  queue['id'],
                                  'selesai',
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text("Selesai"),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmAction(
    BuildContext context,
    String title,
    String content,
    Function onConfirm, {
    bool isDestructive = false,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Batal")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: Text(
              "Ya",
              style: TextStyle(color: isDestructive ? Colors.red : Colors.blue),
            ),
          ),
        ],
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
