import 'dart:convert';

import 'package:sspl/infrastructure/local_storage/pref_consts.dart';
import 'package:sspl/sevices/models/auth/login_model.dart';
import 'package:get_storage/get_storage.dart';

import '../../sevices/models/attendance/view_attendance_model.dart';
import '../../sevices/models/expense/expense_model.dart';

class PrefManager {
  late GetStorage _getStorage;

  void initlizedStorage() {
    _getStorage = GetStorage();
  }

  Future<void> writeValue({required String key, required dynamic value}) async {
    await GetStorage().write(key, value);
  }

  Future<void> setUserData({required LoginModel userData}) async {
    await GetStorage().write(
      PrefConst.userDetails,
      jsonEncode(userData),
    );
    getUserDetails();
  }

  Future<void> setAttendence(
      {required TodayAttendaceModel attendenceData}) async {
    await GetStorage().write(
      PrefConst.attendence,
      jsonEncode(attendenceData),
    );
    getattendence();
  }

  Future<dynamic> getattendence() async {
    final all = await GetStorage().read(
      PrefConst.attendence,
    );
    return all;
  }

  Future<dynamic> getattendenceCalender() async {
    final all = await GetStorage().read(
      PrefConst.attendencecalender,
    );
    return all;
  }

  Future<void> setAttendenceCalender(
      {required TodayAttendaceModel attendencecalenderData}) async {
    await GetStorage().write(
      PrefConst.attendencecalender,
      jsonEncode(attendencecalenderData),
    );
    getattendence();
  }

  Future<dynamic> getUserDetails() async {
    final all = await GetStorage().read(
      PrefConst.userDetails,
    );
    return all;
  }

  Future<dynamic>? readValue({required String key}) async {
    final all = await GetStorage().read(key);
    return all;
  }

  Future<void> clearPref() async {
    await GetStorage().erase();
  }

  Future<void> setViewExpense({required ExpenseModel viewExpenseData}) async {
    await GetStorage().write(
      PrefConst.expense,
      jsonEncode(viewExpenseData),
    );
    getExpense();
  }

  Future<dynamic> getExpense() async {
    final all = await GetStorage().read(
      PrefConst.expense,
    );
    return all;
  }
}
