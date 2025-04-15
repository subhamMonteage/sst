import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';
import 'package:sspl/sevices/api_sevices/api_services.dart';
import 'package:sspl/sevices/models/visit_models/today_visit_model.dart';
import 'package:sspl/sevices/repo/repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodayVisitScreenController extends GetxController {
  TextEditingController remarksController = TextEditingController();

  var viewtodayVisitApi = ViewTodayVisitRepo();

  final viewtodayVisitDataList = TodayVisitModel().obs;

  void setError(String _value) => error.value = _value;

  void setDataList(TodayVisitModel _value) =>
      viewtodayVisitDataList.value = _value; //
  final rxRequestStatus = Status.Loading.obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  var cId = "".obs;
  RxString selectedTime = "".obs;
  RxString selectedDatePost = "".obs;
  RxString selectedAction = "".obs;
  RxString selectedDate = "".obs;
  RxString error = "".obs;

  @override
  void onInit() async {
    super.onInit();
    cId.value = await PrefManager().readValue(key: PrefConst.cId);
    dataListApi();
  }

  void dataListApi() {
    viewtodayVisitApi.viewTodayVisitRepo(cId.value).then((value) {
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

    await viewtodayVisitApi.viewTodayVisitRepo(cId.value).then((value) {
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
