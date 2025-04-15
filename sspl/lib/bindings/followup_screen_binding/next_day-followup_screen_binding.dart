import 'package:sspl/controllers/followup/next_day_followup_screen_controller.dart';
import 'package:get/get.dart';

class NextDayFollowupSreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NextDayFollowupController());
  }
}
