import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';

import '../../sevices/models/attendance/view_attendance_model.dart';
import '../../sevices/repo/repo.dart';

class CheckInController extends GetxController {
  var empId = 0.obs;
  var long = 0.0.obs;
  var lat = 0.0.obs;
  var address = ''.obs;
  Timer? _timer;
  final viewScheduledDataList = TodayAttendaceModel().obs;

  void setDataList(TodayAttendaceModel _value) =>
      viewScheduledDataList.value = _value; //
  var attdanceApi = ViewAttendance();

  @override
  void onInit() async {
    super.onInit();
    empId.value = await PrefManager().readValue(key: PrefConst.addEmployeeId);
    loadValues();
    await dataListApi();
  }

  void loadValues() async {
    empId.value = await PrefManager().readValue(key: PrefConst.addEmployeeId);
    print(empId.value);
    long.value = await PrefManager().readValue(key: PrefConst.clockInLong);
    print(long.value);
    lat.value = await PrefManager().readValue(key: PrefConst.clockInLat);
    print(lat.value);
    address.value = await PrefManager().readValue(key: PrefConst.clockInLoc);
    print(address.value);

    // Add this code inside the loadValues method, after the print statements
  }

  Future<void> dataListApi() async {
    await attdanceApi.viewAttendanceRepo(empId.value).then((value) {
      setDataList(value);
      print("Attendance page controller working${value.message}");
    }).onError((error, stackTrace) {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
