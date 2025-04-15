import 'package:get/get.dart';
import 'package:sspl/controllers/leave/leave_view_all_controller.dart';

import '../../controllers/leave/leave_screen_controller.dart';

class ExpenseScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LeaveScreenController());
    Get.lazyPut(() => LeaveViewAllController());
  }
}
