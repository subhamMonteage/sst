import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../infrastructure/local_storage/local_storage.dart';
import '../../infrastructure/local_storage/pref_consts.dart';

class UpdateController extends GetxController {
  var fetchcustomer = "".obs;
  var fetchcontactperson = "".obs;
  var fetchcontactno = "".obs;
  var fetchEmailid = "".obs;
  var fetchcityname = "".obs;

  var customernamefetch = TextEditingController();
  var contactpersonNfetch = TextEditingController();
  var contactNOfetch = TextEditingController();
  var EmailiDfetch = TextEditingController();
  var cityNamEfetch = TextEditingController();
  var VisitDetailSfetch = TextEditingController();
  var empid = 0.obs;
  RxString updatestatus = ''.obs;
  TextEditingController updateEnquiryDetails = TextEditingController();
  var formKeys = GlobalKey<FormState>().obs;
  TextEditingController Customername = TextEditingController();
  TextEditingController Cityname = TextEditingController();

  @override
  void onInit() async {
    // TODO: implement onInit

    empid.value = await PrefManager().readValue(key: PrefConst.addEmployeeId);
    fetchcustomer.value = Get.arguments[0];
    fetchcityname.value = Get.arguments[1];
    fetchcontactperson.value = Get.arguments[2];
    fetchcontactno.value = Get.arguments[3];
    fetchEmailid.value = Get.arguments[4];
    customernamefetch.text = fetchcustomer.value;
    contactpersonNfetch.text = fetchcontactperson.value;
    contactNOfetch.text = fetchcontactno.value;
    EmailiDfetch.text = fetchEmailid.value;
    cityNamEfetch.text = fetchcityname.value;
    super.onInit();
  }
}
