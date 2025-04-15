import 'package:get/get.dart';
import 'package:sspl/controllers/checkIn/checkincontroller.dart';
import 'package:sspl/view/dashboard/check_in_screen.dart';

import '../../controllers/complaint/complaint_controller.dart';
import '../../controllers/dashboard/dashboard.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => CheckInController());
    // Get.lazyPut(() => ComplaintController());
  }
}
