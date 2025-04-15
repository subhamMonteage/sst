import 'package:sspl/controllers/followup/followup_details_screen_controller.dart';
import 'package:get/get.dart';

class FollowupDetailsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FollowupDetailsScreenController());
  }
}
