import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';

class ViewAllEnquiryController extends GetxController {
  var empid = 0.obs;
  var enquiryId = "".obs;
  var customerName = "".obs;
  RxString EnquiryUpdateStatus = ''.obs;
  var cityName = "".obs;
  var contactPerson = "".obs;
  var contactNo = "".obs;
  var emailId = "".obs;
  var eStatus = "".obs;
  var enquiryDetails = "".obs;
  var action = "".obs;
  var createBy = "".obs;
  var updateBy = "".obs;
  var createDate = "".obs;
  var isActive = "".obs;
  var createdDate = "".obs;
  var date = "".obs;
  var modifiedDat = "".obs;
  var createdby = "".obs;
  var updatedby = "".obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    enquiryId.value = Get.arguments[0];
    customerName.value = Get.arguments[1];
    cityName.value = Get.arguments[2];
    contactPerson.value = Get.arguments[3];
    contactNo.value = Get.arguments[4];
    emailId.value = Get.arguments[5];
    eStatus.value = Get.arguments[6];
    enquiryDetails.value = Get.arguments[7];
    action.value = Get.arguments[8];
    createBy.value = Get.arguments[9];
    updateBy.value = Get.arguments[10];
    createDate.value = Get.arguments[11];
    isActive.value = Get.arguments[12];
    createdDate.value = Get.arguments[13];
    date.value = Get.arguments[14];
    modifiedDat.value = Get.arguments[15];
    createdby.value = Get.arguments[16];
    updatedby.value = Get.arguments[17];
    empid.value = await PrefManager().readValue(key: PrefConst.addEmployeeId);
    super.onInit();
  }
}
