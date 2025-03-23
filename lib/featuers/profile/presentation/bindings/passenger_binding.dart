import 'package:arrowspeed/featuers/profile/data/datasources/passenger_firebase_source.dart';
import 'package:arrowspeed/featuers/profile/data/repo_imp/passenger_rep_imp.dart';

import 'package:arrowspeed/featuers/profile/presentation/controllers/passenger_controller.dart';
import 'package:get/get.dart';

class PassengerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PassengerFirebaseSource());

    Get.put(PassengerRepositoryImpl(Get.find<PassengerFirebaseSource>()));


    Get.put(PassengerController(Get.find<PassengerRepositoryImpl>()));
  }
}
