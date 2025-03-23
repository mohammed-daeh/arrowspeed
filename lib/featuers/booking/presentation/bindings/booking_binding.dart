import 'package:arrowspeed/featuers/booking/data/datasources/firebase_booking_source.dart';
import 'package:arrowspeed/featuers/booking/data/repo_imp/booking_repo_im.dart';
import 'package:arrowspeed/featuers/booking/presentation/controllers/booking_controller.dart';
import 'package:get/get.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FirebaseBookingSource());
    Get.put(BookingRepoIm(Get.find<FirebaseBookingSource>()));
    Get.put(BookingController(Get.find<BookingRepoIm>()));
  }
}
