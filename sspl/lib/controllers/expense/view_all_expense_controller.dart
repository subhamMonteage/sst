import 'package:get/get.dart';
import 'package:http/http.dart';

class ViewAllExpenseController extends GetxController {
  var total = "".obs;
  var visitDate = "".obs; //
  var purpose = "".obs; //
  var customerName = "".obs; //
  var cityName = "".obs; //
  var contactPersonName = "".obs; //
  var contactNo = "".obs; //
  var emailId = "".obs; //
  var visitDetails = "".obs; // Column
  var eXPPurpose = "".obs; //
  var eXPAmount = "".obs; //
  var eXPPublicConveDetails = "".obs; //
  var eXPAmount2 = "".obs; //
  var eXPTravelKmVehicle = "".obs; //
  var eXPAmount3 = "".obs; //
  var eXPExpensedetails = "".obs; //
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    visitDate.value = Get.arguments[0];
    purpose.value = Get.arguments[1];
    customerName.value = Get.arguments[2];
    cityName.value = Get.arguments[3];
    contactPersonName.value = Get.arguments[4];
    contactNo.value = Get.arguments[5];
    emailId.value = Get.arguments[6];
    visitDetails.value = Get.arguments[7];
    eXPPurpose.value = Get.arguments[8];
    eXPAmount.value = Get.arguments[9];
    eXPPublicConveDetails.value = Get.arguments[10];
    eXPAmount2.value = Get.arguments[11];
    eXPTravelKmVehicle.value = Get.arguments[12];
    eXPAmount3.value = Get.arguments[13];
    eXPExpensedetails.value = Get.arguments[14];
    total.value = Get.arguments[15];
  }
}
