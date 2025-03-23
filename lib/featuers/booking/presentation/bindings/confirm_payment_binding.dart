import 'package:arrowspeed/featuers/booking/data/datasources/firebase_reservation_source.dart';
import 'package:arrowspeed/featuers/booking/data/repo_imp/reservation_repo_im.dart';
import 'package:arrowspeed/featuers/booking/presentation/controllers/reservation_controller.dart';
import 'package:get/get.dart';

class ConfirmPaymentBinding  extends Bindings {
  @override
  void dependencies() {
    Get.put(FirebaseReservationSource());
    Get.put(ReservationRepoIm(Get.find<FirebaseReservationSource>()));
    Get.put(ReservationController(Get.find<ReservationRepoIm>()));
  }
}
