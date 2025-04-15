import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';
import 'package:sspl/sevices/api_sevices/api_services.dart';
import 'package:sspl/sevices/models/followup_model/followup_detals.dart';
import 'package:sspl/sevices/models/visit_models/all_visit_model.dart';
import 'package:sspl/sevices/repo/repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllVisitScreenController extends GetxController {
  TextEditingController remarksController = TextEditingController();

  final rxRequestStatus = Status.Loading.obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;

  var viewallVisitApi = ViewAllVisitRepo();

  final viewallVisitDataList = AllVisitModel().obs;

  void setError(String _value) => error.value = _value;

  void setDataList(AllVisitModel _value) => viewallVisitDataList.value = _value;
  var cId = "".obs;
  RxString error = "".obs;
  RxString selectedDate = "".obs;
  RxString selectedTime = "".obs;
  RxString selectedDatePost = "".obs;
  RxString selectedAction = "".obs;
  var leadid = "".obs;

  @override
  void onInit() async {
    super.onInit();
    cId.value = await PrefManager().readValue(key: PrefConst.cId);
    dataListApi();
    print("cid===>  ${cId.value}");
  }

  void dataListApi() {
    viewallVisitApi.viewAllVisitRepo(cId.value).then((value) {
      setRxRequestStatus(Status.Complete);
      setDataList(value);
      print("view today visit page controller working${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  Future<void> updateDataListApi() async {
    setRxRequestStatus(Status.Loading);

    await viewallVisitApi.viewAllVisitRepo(cId.value).then((value) {
      setRxRequestStatus(Status.Complete);
      setDataList(value);
      print("visit today data Data ${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  final lAction = 'Select Action'.obs;
  final lActionValue = <String>[
    "Select Action",
    "Next Session",
    "Not eligible",
    "Registered",
    "In Progress",
    "Invalid",
    "Contacted",
    "Not Reachable",
    "Not Interested",
    "Duplicate",
    "Closed",
  ];
}
