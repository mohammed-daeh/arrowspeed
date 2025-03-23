import 'package:arrowspeed/featuers/auth/data/datasources/firebase_auth_servise.dart';
import 'package:arrowspeed/featuers/auth/data/datasources/firebase_firestore_servise.dart';
import 'package:arrowspeed/featuers/auth/data/repo_imp/user_reop_im.dart';
import 'package:arrowspeed/featuers/auth/presentation/controllers/log_in_controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthDataSource());
    Get.put(FirebaseFirestoreService());

    Get.put(UserRepoImpl(Get.find<FirebaseFirestoreService>()));

    Get.put(LoginController(Get.find<UserRepoImpl>()));
  }
}
