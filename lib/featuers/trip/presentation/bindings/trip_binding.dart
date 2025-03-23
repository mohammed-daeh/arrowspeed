import 'package:arrowspeed/featuers/trip/data/datasources/firebase_trip_source.dart';
import 'package:arrowspeed/featuers/trip/data/repo_imp/trip_repo_im.dart';
import 'package:arrowspeed/featuers/trip/presentation/controllers/trip_controller.dart';
import 'package:get/get.dart';

class TripBinding extends Bindings {
  @override

  void dependencies() {
     
    Get.put(FirebaseTripSource());
    Get.put(TripRepoIm(Get.find<FirebaseTripSource>()));
    Get.put(TripsController(Get.find<TripRepoIm>()));
  }
}
