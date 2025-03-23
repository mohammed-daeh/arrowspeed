import 'package:arrowspeed/admin/presentation/controllers/admin_home_controller.dart';
import 'package:arrowspeed/admin/presentation/screens/admin_bookings_screen.dart';
import 'package:arrowspeed/admin/presentation/screens/admin_finance_screen.dart';
import 'package:arrowspeed/admin/presentation/screens/admin_statistics_screen.dart';
import 'package:arrowspeed/admin/presentation/screens/admin_trips_screen.dart';
import 'package:arrowspeed/admin/presentation/screens/admin_users_screen.dart';
import 'package:arrowspeed/sheard/widgets/costum_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHomeScreen extends StatelessWidget {
  final int initialIndex;

  AdminHomeScreen({super.key, this.initialIndex = 0}) {
    final controller = Get.find<AdminHomeController>();
    controller.setInitialIndex(
        initialIndex); // ✅ استدعها في الـ constructor وليس في build
  }

  final List<Widget> _pages = [
    AdminStatisticsScreen(),
    AdminUsersScreen(),
    AdminTripsScreen(),
    AdminBookingsScreen(),
    AdminFinanceScreen(),
  ];

  final AdminHomeController _controller = Get.find<AdminHomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Obx(() => IndexedStack(
                  index: _controller.currentPage.value,
                  children: _pages,
                )),
          ),
          Positioned(
            bottom: 24,
            left: 45,
            right: 45,
            child: Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0,
              child: Obx(() => CostumBottomNavigationBar(
                    activeIcons: _controller.activeIcons,
                    inactiveIcons: _controller.inactiveIcons,
                    labels: _controller.labels,
                    selectedIndex: _controller.currentPage.value,
                    onTabSelected: _controller.setCurrentPage,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

// class AdminHomeScreen extends StatelessWidget {
//   final int initialIndex;

//   AdminHomeScreen({super.key, this.initialIndex = 0});

//   // List of pages for navigation
//   final List<Widget> _pages = [
//     AdminStatisticsScreen(),
//     AdminUsersScreen(),
//     AdminTripsScreen(),
//     AdminBookingsScreen(),
//     AdminFinanceScreen(),
//   ];

//   final AdminHomeController _controller = Get.put(AdminHomeController());

//   @override
//   Widget build(BuildContext context) {
//     _controller.setInitialIndex(initialIndex);

//     return Scaffold(
//       resizeToAvoidBottomInset: false, // <--- إضافة هذه السطر

//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Obx(() => IndexedStack(
//                   index: _controller.currentPage.value,
//                   children: _pages,
//                 )),
//           ),
//           Positioned(
//             bottom: 24,
//             left: 45,
//             right: 45,
//             child: Visibility(
//               visible: MediaQuery.of(context).viewInsets.bottom == 0,
//               child: Obx(() => CostumBottomNavigationBar(
//                     activeIcons: _controller.activeIcons,
//                     inactiveIcons: _controller.inactiveIcons,
//                     labels: _controller.labels,
//                     selectedIndex: _controller.currentPage.value,
//                     onTabSelected: _controller.setCurrentPage,
//                   )),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PageContent {
//   final PreferredSizeWidget appBar;
//   final Widget body;

//   PageContent({required this.appBar, required this.body});
// }
// Admin Home Controller

// Custom Bottom Navigation Bar
// class AdminBottomNavigationBar extends StatelessWidget {
//   final List<IconData> activeIcons;
//   final List<IconData> inactiveIcons;
//   final List<String> labels;
//   final int selectedIndex;
//   final Function(int) onTabSelected;

//   const AdminBottomNavigationBar({
//     super.key,
//     required this.activeIcons,
//     required this.inactiveIcons,
//     required this.labels,
//     required this.selectedIndex,
//     required this.onTabSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: List.generate(activeIcons.length, (index) {
//             bool isSelected = index == selectedIndex;
//             return GestureDetector(
//               onTap: () => onTabSelected(index),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     isSelected ? activeIcons[index] : inactiveIcons[index],
//                     size: 28,
//                     color: isSelected ? Colors.blue : Colors.grey,
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     labels[index],
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight:
//                           isSelected ? FontWeight.bold : FontWeight.normal,
//                       color: isSelected ? Colors.blue : Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }
// class AdminHomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(() => AdminHomeController());

//     final adminController = Get.find<AdminHomeController>();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('لوحة التحكم'),
//         actions: [
//           IconButton(icon: Icon(Icons.search), onPressed: () {}),
//           IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
//           IconButton(
//               icon: Icon(Icons.person_4_rounded),
//               onPressed: () {
//                 // Get.to(AdminProfilePage());
//               }),
//         ],
//       ),
//       drawer: AdminDrawer(),
//       body: Obx(() {
//         switch (adminController.currentPage.value) {
//           case 0:
//             return AdminStatisticsScreen();
//           case 1:
//             return AdminUsersScreen();
//           case 2:
//             return AdminTripsScreen();
//           case 3:
//             return AdminBookingsScreen();
//           case 4:
//             return AdminFinanceScreen();
//           default:
//             return Center(child: Text('صفحة غير موجودة'));
//         }
//       }),
//     );
//   }
// }

// class AdminProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('حسابي'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundColor: Colors.blue,
//               child: Icon(Icons.person, size: 60, color: Colors.white),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'اسم الإدمن',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'admin@example.com',
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {},
//               child: Text('تحديث المعلومات'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
