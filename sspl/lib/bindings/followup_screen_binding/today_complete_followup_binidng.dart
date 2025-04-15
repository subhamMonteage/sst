import 'package:sspl/controllers/followup/today_complete_followup_screen_controller.dart';
import 'package:get/get.dart';

class TodayCompleteFollowupScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TodayCompleteFollowupController());
  }
}
