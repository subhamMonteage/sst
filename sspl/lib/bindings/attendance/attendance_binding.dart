import 'package:get/get.dart';
import '../../controllers/attendance/attendance_controller.dart';
import '../../controllers/attendance/month_attdance_controller.dart';

class AttendanceScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AttendanceScreenController());
    Get.lazyPut(() => MonthlyAttendanceController());
  }
}
