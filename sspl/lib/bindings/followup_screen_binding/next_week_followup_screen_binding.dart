import 'package:sspl/controllers/EnquiryScreenController/EnquiryScreenController.dart';
import 'package:sspl/controllers/followup/next_week_followup_screen_controller.dart';
import 'package:get/get.dart';

class NextWeekFollowupScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NextWeekFollowupScreenController());
    Get.lazyPut(() => EnquiryController());
  }
}
