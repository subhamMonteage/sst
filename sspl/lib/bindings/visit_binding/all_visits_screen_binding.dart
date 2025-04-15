import 'package:sspl/controllers/add_visit_screen_controller/all_visit_screen_controller.dart';
import 'package:get/get.dart';

class AllVisitScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllVisitScreenController());
  }
}
