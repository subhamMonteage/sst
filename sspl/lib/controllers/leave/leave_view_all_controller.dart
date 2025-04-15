import 'package:get/get.dart';

class LeaveViewAllController extends GetxController {
  var leaveFromDate = "".obs;
  var leaveToDate = "".obs;
  var leaveApplyfor = "".obs;
  var leaveType = "".obs;
  var alternateContactNo = "".obs;
  var resumedutyDate = "".obs;
  var namee = "".obs;
  var createBy = "".obs;

  @override
  void onInit() {
    leaveFromDate.value = Get.arguments[0];
    leaveToDate.value = Get.arguments[1];
    leaveApplyfor.value = Get.arguments[2];
    leaveType.value = Get.arguments[3];
    alternateContactNo.value = Get.arguments[4];
    resumedutyDate.value = Get.arguments[5];
    namee.value = Get.arguments[6];
    createBy.value = Get.arguments[7];
    super.onInit();
  }
}
