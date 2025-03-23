import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHomeController extends GetxController {
  // final AdminRepoImp adminRepoImp;
  // AdminHomeController(this.adminRepoImp);
  var currentPage = 0.obs;

  // Icons and labels for bottom navigation bar
  final List<IconData> activeIcons = [
    Icons.dashboard,
    Icons.person,
    Icons.directions_bus,
    Icons.confirmation_number,
    Icons.attach_money,
  ];

  final List<IconData> inactiveIcons = [
    Icons.dashboard_outlined,
    Icons.person_outline,
    Icons.directions_bus_outlined,
    Icons.confirmation_number_outlined,
    Icons.attach_money_outlined,
  ];

  final List<String> labels = [
    'Statistics',
    'Users',
    'Trips',
    'Bookings',
    'Finance',
  ];

  void setCurrentPage(int page) {
    currentPage.value = page;
  }

  void setInitialIndex(int index) {
    currentPage.value = index;
  }
}
