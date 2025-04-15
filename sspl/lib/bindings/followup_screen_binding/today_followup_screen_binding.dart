import 'package:sspl/controllers/followup/today_followup_screen_controller.dart';
import 'package:get/get.dart';

class TodayFollowUpScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TodayFollowUpScreenController());
  }
}
