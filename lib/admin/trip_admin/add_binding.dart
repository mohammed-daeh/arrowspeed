
import 'package:arrowspeed/featuers/trip/data/datasources/firebase_trip_source.dart';
import 'package:arrowspeed/featuers/trip/data/repo_imp/trip_repo_im.dart';
import 'package:get/get.dart';

import 'add_trip_admin_controller.dart';

class AddBinding extends Bindings {
  @override

  void dependencies() {
   Get.put(FirebaseTripSource());
    Get.put(TripRepoIm(Get.find<FirebaseTripSource>()));
    
    Get.put(AddTripAdminController(Get.find<TripRepoIm>()));
  }
}
