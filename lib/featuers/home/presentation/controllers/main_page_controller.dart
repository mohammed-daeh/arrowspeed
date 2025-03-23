import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  final List<String> iconPathsActive = [
    'assets/icons/home.svg',
    'assets/icons/bus.svg',
    'assets/icons/reservation.svg',
    'assets/icons/user.svg',
  ];

  final List<String> iconPathsInactive = [
    'assets/icons/home.svg',
    'assets/icons/bus.svg',
    'assets/icons/reservation.svg',
    'assets/icons/user.svg',
  ];

  final List<String> labels = [
    'Home',
    'Tripes',
    'Bookings',
    'Profile',
  ];

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  void setInitialIndex(int index) {
    selectedIndex.value = index;
  }

  String getActiveIcon(int index) => iconPathsActive[index];
  String getInactiveIcon(int index) => iconPathsInactive[index];
  String getLabel(int index) => labels[index];
}
