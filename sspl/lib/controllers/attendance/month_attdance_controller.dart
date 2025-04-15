import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../infrastructure/local_storage/local_storage.dart';
import '../../infrastructure/local_storage/pref_consts.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../sevices/models/attendance/view_attendance_model.dart';
import '../../sevices/repo/repo.dart';

class MonthlyAttendanceController extends GetxController {
  Rx<DateTime> selectedFromDate = DateTime.now().obs;
  var monthAttdenceApi = ViewMonthAttendance();
  final viewScheduledMonthDataList = TodayAttendaceModel().obs;

  void setMonthDataList(TodayAttendaceModel value) =>
      viewScheduledMonthDataList.value = value; //
  RxString formattedDateToday = "".obs;
  var employeeID = 0.obs;
  final rxRequestStatus = Status.Loading.obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;

  void setError(String _value) => error.value = _value;
  RxString error = "".obs;

  void onInit() async {
    super.onInit();
    print("in init");
    employeeID.value =
        await PrefManager().readValue(key: PrefConst.addEmployeeId);
    // monthdataListApi();
  }

  Future<void> monthdataListApi() async {
    await monthAttdenceApi
        .viewMonthAttendanceRepo(employeeID.value, formattedDateToday.value)
        .then((value) {
      setRxRequestStatus(Status.Complete);
      setMonthDataList(value);
      formattedDateToday.value = '';
      print("Attendance page controller working${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedFromDate.value,
      currentDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.day,
    );
    if (picked != null && picked != selectedFromDate.value) {
      selectedFromDate.value = picked;
      formattedDateToday.value =
          DateFormat.yMMMM().format(selectedFromDate.value);
      await monthdataListApi();
    }
  }
}
