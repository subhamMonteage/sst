import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';
import 'package:sspl/sevices/models/complaint/complaint_view_model.dart';

import '../../sevices/api_sevices/api_services.dart';
import '../../sevices/repo/repo.dart';

class ComplaintController extends GetxController {
  // RxString Customer = "".obs;
  TextEditingController ContactNo = TextEditingController();

  // TextEditingController Customer = TextEditingController();
  TextEditingController updatremark = TextEditingController();
  TextEditingController Cupdatremark = TextEditingController();
  TextEditingController ContactPerson = TextEditingController();
  TextEditingController customer = TextEditingController();
  TextEditingController Complaint = TextEditingController();
  TextEditingController Remark = TextEditingController();
  var Empid = 0.obs;

  var complaintlist = ComplaintViewModel().obs;
  final complaintapi = ViewComplaint();

  void setComplaintData(ComplaintViewModel _value) {
    complaintlist.value = _value;
  }

  RxString error = "".obs;
  RxString Remarkupdate = "".obs;
  RxString CRemarkupdate = "".obs;

  void setError(String _value) => error.value = _value; //
  final rxRequestStatus = Status.Loading.obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    customer.dispose();
    ContactPerson.dispose();
    ContactNo.dispose();
    Complaint.dispose();
    Remark.dispose();
  }

  @override
  void onInit() async {
    Empid.value = await PrefManager().readValue(key: PrefConst.addEmployeeId);
    // TODO: implement onInit
    await ComplaintViewApi();
    super.onInit();
  }

  Future<void> ComplaintViewApi() async {
    setRxRequestStatus(Status.Loading);
    complaintapi.viewComplaintRepo(Empid.value).then((value) {
      setRxRequestStatus(Status.Complete);
      setComplaintData(value);
      print("Class Data ${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }
}
