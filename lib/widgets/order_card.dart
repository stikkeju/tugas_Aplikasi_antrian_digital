import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final int index;
  final Widget? actions; // Optional actions for Admin (Buttons)
  final bool isAdmin;

  const OrderCard({
    Key? key,
    required this.order,
    required this.index,
    this.actions,
    this.isAdmin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String status = order['status'];
    Color cardColor = Colors.white;
    Color statusColor = Colors.grey;
    String statusText = status;

    switch (status) {
      case 'menunggu':
        cardColor = Colors.orange.shade50;
        statusColor = Colors.orange;
        statusText = "Menunggu";
        break;
      case 'proses':
        cardColor = Colors.blue.shade50;
        statusColor = Colors.blue;
        statusText = "Sedang Diproses";
        break;
      case 'selesai':
        cardColor = Colors.green.shade50;
        statusColor = Colors.green;
        statusText = "Selesai";
        break;
      case 'batal':
        cardColor = Colors.red.shade50;
        statusColor = Colors.red;
        statusText = "Dibatalkan";
        break;
      default:
        cardColor = Colors.grey.shade100;
    }

    // Parse items if they are passed as a list (Provider should have processed this)
    List<dynamic>? items = order['items'];

    return Card(
      color: cardColor,
      margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Queue Number + Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Kode: ${order['id']}", // Original ID
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Antrian #${index + 1}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      if (order['username'] != null)
                        Text(
                          "Pesanan oleh: ${order['username']}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500, // Not italic
                            color: Colors.grey[800],
                          ),
                        ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    statusText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: status == 'selesai' ? Colors.white : statusColor,
                    ),
                  ),
                  backgroundColor: status == 'selesai'
                      ? Colors.green
                      : Colors.white,
                  side: BorderSide(color: statusColor),
                ),
              ],
            ),
            Divider(),

            // Items List
            Text("Pesanan:", style: TextStyle(fontWeight: FontWeight.w600)),
            if (items != null)
              ...items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        children: [
                          Text(
                            "- ${item['menu_name']}",
                            style: TextStyle(
                              fontSize: isAdmin
                                  ? 14
                                  : 12, // Slightly larger for admin as requested
                              fontWeight: isAdmin
                                  ? FontWeight.w500
                                  : FontWeight.bold, // Adjusted per request
                            ),
                          ),
                          Spacer(),
                          Text(
                            "${item['quantity']}x",
                            style: TextStyle(
                              fontSize: isAdmin ? 14 : 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Helper to safely multiply
                          if (isAdmin) ...[
                            SizedBox(width: 8),
                            Text(
                              "Rp ${(item['price'] ?? 0) * (item['quantity'] ?? 0)}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                  .toList(),

            SizedBox(height: 10),

            // Footer: Total Price OR Actions
            if (actions != null) ...[
              Divider(),
              Align(alignment: Alignment.centerRight, child: actions),
            ] else
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Total: Rp ${order['total_price']}",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
