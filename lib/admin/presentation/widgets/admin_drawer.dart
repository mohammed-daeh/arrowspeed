import 'package:arrowspeed/admin/presentation/controllers/admin_home_controller.dart';
import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDrawer extends StatelessWidget {
  final AdminHomeController adminController = Get.put(AdminHomeController());

  AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue[50],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        onTap: () {
                          Get.toNamed(AppRouter.adminProfile);
                        },
                        child: Icon(Icons.edit_document)),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'مرحبًا بالإدمن',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard, color: Colors.blue),
              title: Text('لوحة التحكم', style: TextStyle(fontSize: 16)),
              onTap: () {
                adminController.setCurrentPage(0);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text('إدارة المستخدمين', style: TextStyle(fontSize: 16)),
              onTap: () {
                adminController.setCurrentPage(1);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_bus, color: Colors.blue),
              title: Text('إدارة الرحلات', style: TextStyle(fontSize: 16)),
              onTap: () {
                adminController.setCurrentPage(2);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.confirmation_number, color: Colors.blue),
              title: Text('إدارة الحجوزات', style: TextStyle(fontSize: 16)),
              onTap: () {
                adminController.setCurrentPage(3);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money, color: Colors.blue),
              title: Text('العمليات الحسابية', style: TextStyle(fontSize: 16)),
              onTap: () {
                adminController.setCurrentPage(4);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
