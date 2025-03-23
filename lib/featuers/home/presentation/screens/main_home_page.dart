// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:arrowspeed/featuers/home/presentation/controllers/main_page_controller.dart';
import 'package:arrowspeed/featuers/home/presentation/screens/home_screen.dart';
import 'package:arrowspeed/featuers/profile/presentation/screens/profile_screen.dart';
import 'package:arrowspeed/featuers/trip/presentation/screens/trips_screen.dart';
import 'package:arrowspeed/featuers/booking/presentation/screens/bookings_screen.dart';
import 'package:arrowspeed/sheard/widgets/costum_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainHomePage extends StatelessWidget {
  final int initialIndex;

  MainHomePage({super.key, this.initialIndex = 0});

  final List<Widget> _pages = [
    HomeScreen(),
    TripsScreen(),
    BookingsScreen(),
    ProfileScreen(),
  ];

  final BottomNavController _controller = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    _controller.setInitialIndex(initialIndex);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Obx(() => _pages[_controller.selectedIndex.value]),
          ),
          Positioned(
            bottom: 24,
            left: 45,
            right: 45,
            child: Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0,
              child: Obx(() => CostumBottomNavigationBar(
                    activeIcons: _controller.iconPathsActive,
                    inactiveIcons: _controller.iconPathsInactive,
                    labels: _controller.labels,
                    selectedIndex: _controller.selectedIndex.value,
                    onTabSelected: _controller.changeTabIndex,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
