import 'package:flutter/material.dart';

class AdminTripsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> trips = [
    {'id': 1, 'from': 'مدينة A', 'to': 'مدينة B', 'date': '2023-10-01'},
    {'id': 2, 'from': 'مدينة C', 'to': 'مدينة D', 'date': '2023-10-05'},
  ];

   AdminTripsScreen({super.key});

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
                  'إدارة الرحلات',
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
                labelText: 'بحث عن رحلة',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return Card(
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(Icons.directions_bus,
                        size: 40, color: Colors.green),
                    title: Text('${trip['from']} إلى ${trip['to']}'),
                    subtitle: Text(trip['date']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {},
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
