import 'package:arrowspeed/featuers/auth/data/datasources/firebase_firestore_servise.dart';
import 'package:arrowspeed/featuers/auth/data/repo_imp/user_reop_im.dart';
import 'package:arrowspeed/featuers/profile/presentation/controllers/edit_profile_controller.dart';
import 'package:get/get.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FirebaseFirestoreService());

    Get.put(UserRepoImpl(Get.find<FirebaseFirestoreService>()));

    Get.put(EditProfileController(Get.find<UserRepoImpl>()));
  }
}
