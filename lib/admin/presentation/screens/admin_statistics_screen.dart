import 'package:arrowspeed/admin/data/datasources/user_data_source.dart';
import 'package:arrowspeed/admin/data/repo_imp/admin_repo_imp_user.dart';
import 'package:arrowspeed/admin/presentation/controllers/admin_users_controller.dart';
import 'package:arrowspeed/admin/presentation/widgets/admin_drawer.dart';
import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AdminStatisticsScreen extends StatelessWidget {
  final AdminUsersController controller =
      Get.put(AdminUsersController(AdminRepoImpUser(UserDataSource())));

  // Sample data for the bar chart
  final List<Map<String, dynamic>> chartData = [
    {'month': 'يناير', 'sales': 5},
    {'month': 'فبراير', 'sales': 25},
    {'month': 'مارس', 'sales': 100},
    {'month': 'أبريل', 'sales': 75},
  ];

   AdminStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: AdminDrawer(),
      ),
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.oxfordBlue,
        title: Text(
          'إحصائيات عامة',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _refreshPage();
            },
          ),
          IconButton(
            icon:
                Icon(Icons.notifications_active_outlined, color: Colors.white),
            onPressed: () {
            },
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/loading.json', // رسم تحميل متحرك
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 16),
                Text(
                  'جارٍ تحديث البيانات...',
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Title
                Text(
                  'نظرة عامة على الأداء',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                // Statistics Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.people,
                        label: 'المستخدمون',
                        value: controller.users.length.toString(),
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.directions_bus,
                        label: 'الرحلات',
                        value: '500',
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.confirmation_number,
                        label: 'الحجوزات',
                        value: '1,200',
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.attach_money,
                        label: 'الإيرادات',
                        value: '\$10,000',
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Bar Chart
                Text(
                  'الأداء الشهري',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: BarChart(
                    BarChartData(
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final month = chartData[value.toInt()]['month'];
                              return Text(month);
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                      ),
                      barGroups: chartData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final value = entry.value['sales'];
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: value.toDouble(),
                              color: Colors.blue,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Pie Chart
                Text(
                  'توزيع الإيرادات',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: 40,
                          color: Colors.blue,
                          title: '40%',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: 30,
                          color: Colors.green,
                          title: '30%',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: 20,
                          color: Colors.orange,
                          title: '20%',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: 10,
                          color: Colors.red,
                          title: '10%',
                          radius: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Helper method to build statistic cards
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Refresh page functionality
  void _refreshPage() async {
    controller.isLoading.value = true; // Show loading animation
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    await controller.fetchUsers(); // Fetch new data
    controller.isLoading.value = false; // Hide loading animation
  }
}
// class AdminStatisticsScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> data = [
//     {'month': 'يناير', 'sales': 5},
//     {'month': 'فبراير', 'sales': 25},
//     {'month': 'مارس', 'sales': 100},
//     {'month': 'أبريل', 'sales': 75},
//   ];

//   AdminStatisticsScreen({super.key});
//   final AdminUsersController users =
//       Get.put(AdminUsersController(AdminRepoImp(FirebaseAdminSource())));
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: AppColors.oxfordBlue,
//         title: Text(
//           Utils.localize('Statistics'),
//           style: TextStyle(
//             color: AppColors.white,
//           ),
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {},
//               icon: Icon(
//                 Icons.refresh,
//                 color: AppColors.white,
//               ))
//         ],
//         leading: Builder(
//           builder: (context) => IconButton(
//             icon: Icon(
//               Icons.menu,
//               color: AppColors.white,
//             ),
//             onPressed: () => Scaffold.of(context).openDrawer(),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'إحصائيات عامة',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Card(
//                       elevation: 4,
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           children: [
//                             Icon(Icons.people, size: 40, color: Colors.blue),
//                             SizedBox(height: 8),
//                             Text(Utils.localize('Users'),
//                                 style: TextStyle(fontSize: 18)),
//                             Obx(() {
//                               return Text(users.users.length.toString(),
//                                   style: TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold));
//                             })
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: Card(
//                       elevation: 4,
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           children: [
//                             Icon(Icons.directions_bus,
//                                 size: 40, color: Colors.green),
//                             SizedBox(height: 8),
//                             Text('الرحلات', style: TextStyle(fontSize: 18)),
//                             Text('500',
//                                 style: TextStyle(
//                                     fontSize: 24, fontWeight: FontWeight.bold)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               AspectRatio(
//                 aspectRatio: 1.5,
//                 child: BarChart(
//                   BarChartData(
//                     titlesData: FlTitlesData(
//                       show: true,
//                       bottomTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           getTitlesWidget: (value, meta) {
//                             final month = data[value.toInt()]['month'];
//                             return Text(month);
//                           },
//                         ),
//                       ),
//                       leftTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: true),
//                       ),
//                     ),
//                     barGroups: data.asMap().entries.map((entry) {
//                       final index = entry.key;
//                       final value = entry.value['sales'];
//                       return BarChartGroupData(
//                         x: index,
//                         barRods: [
//                           BarChartRodData(
//                             toY: value.toDouble(),
//                             color: Colors.blue,
//                           ),
//                         ],
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
