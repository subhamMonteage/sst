import 'package:sspl/controllers/followup/all_followup_screen_controller.dart';
import 'package:get/get.dart';

class AllFollowUpScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllFollowUpScreenController());
  }
}
