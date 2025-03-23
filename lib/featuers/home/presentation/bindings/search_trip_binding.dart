import 'package:arrowspeed/featuers/home/data/datasources/search_firebase_source.dart';
import 'package:arrowspeed/featuers/home/data/repo_imp/search_repo_imp.dart';
import 'package:arrowspeed/featuers/home/presentation/controllers/search_controller.dart';
import 'package:get/get.dart';

class SearchTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SearchFirebaseSource());
    Get.put(SearchRepoImp(Get.find<SearchFirebaseSource>()));
    Get.put(SearchTripController(Get.find<SearchRepoImp>()));
  }
}
