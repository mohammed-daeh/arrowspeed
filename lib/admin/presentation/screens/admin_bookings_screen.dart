import 'package:flutter/material.dart';

class AdminBookingsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> bookings = [
    {'id': 1, 'user': 'أحمد', 'trip': 'رحلة 1', 'status': 'مؤكدة'},
    {'id': 2, 'user': 'سارة', 'trip': 'رحلة 2', 'status': 'معلقة'},
  ];

   AdminBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'إدارة الحجوزات',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Colors.green),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'بحث عن حجز',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(Icons.confirmation_number,
                        size: 40, color: Colors.orange),
                    title: Text(booking['trip']),
                    subtitle: Text(booking['user']),
                    trailing: Chip(
                      label: Text(booking['status']),
                      backgroundColor: booking['status'] == 'مؤكدة'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
