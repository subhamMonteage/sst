import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sspl/sevices/models/attendance/dateAttendanceModel.dart';
import 'package:sspl/sevices/repo/repo.dart';

import '../../infrastructure/local_storage/local_storage.dart';
import '../../infrastructure/local_storage/pref_consts.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../sevices/models/attendance/view_attendance_model.dart';

class AttendanceScreenController extends GetxController {
  var currentDate2 = DateTime.now().obs;
  var targetDateTime = DateTime.now().obs;
  var markedDateMap1 = EventList<Event>(
    events: {
      DateTime(2023, 11, 12): [
        Event(
          date: DateTime(0000, 00, 00),
          title: "Please! Try again",
          icon: eventIcon,
        ),
      ],
    },
  ).obs;
  final isLoading = false.obs;
  final view = false.obs;
  var attdanceApi = ViewAttendance();
  Rx<DateTime> selectedFromDate = DateTime.now().obs;
  var monthAttdenceApi = ViewMonthAttendance();
  var dateWiseAttdenceApi = ViewDateWiseAttendance();
  final viewScheduledMonthDataList = TodayAttendaceModel().obs;
  final savedattendanceCalender = TodayAttendaceModel().obs;

  void setMonthDataList(TodayAttendaceModel value) =>
      viewScheduledMonthDataList.value = value; //
  RxString formattedDateToday = "".obs;
  var dateAttendanceapi = DateAttendance();
  final viewScheduledDataList = TodayAttendaceModel().obs;
  final DateAttendanceList = DateAttendanceModel().obs;

  void setError(String _value) => error.value = _value;

  void setDataList(TodayAttendaceModel _value) =>
      viewScheduledDataList.value = _value; //
  void setDateList(DateAttendanceModel _value) =>
      DateAttendanceList.value = _value; //
  // void setMonthDataList(TodayAttendaceModel _value) =>
  //     viewScheduledMonthDataList.value = _value; //
  final rxRequestStatus = Status.Loading.obs;
  final rxRequestStatus1 = Status.Loading.obs;
  RxString error = "".obs;
  RxString currentMonth = DateFormat.yMMM().format(DateTime.now()).obs;
  static final Widget eventIcon = Container(
    decoration: BoxDecoration(
      color: Colors.green.withOpacity(0.5),
      borderRadius: BorderRadius.all(Radius.circular(1000.r)),
    ),
  );
  static final Widget eventIcon1 = Container(
    decoration: BoxDecoration(
      color: Colors.red.withOpacity(0.5),
      borderRadius: BorderRadius.all(Radius.circular(1000.r)),
    ),
  );
  static final Widget eventIcon2 = Container(
    decoration: BoxDecoration(
      color: Colors.deepPurple.withOpacity(0.5),
      borderRadius: BorderRadius.all(Radius.circular(1000.r)),
    ),
  );

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;

  void setRxRequestStatus1(Status _value) => rxRequestStatus1.value = _value;
  RxString todayDate = "".obs;
  var employeeID = 0.obs;
  var markedDateMap = EventList<Event>(
    events: {
      DateTime(2024, 05, 06): [
        Event(
          date: DateTime(0000, 00, 00),
          title: "Please! Try again",
          icon: eventIcon,
        ),
      ],
    },
  ).obs;

/*  var markedDateMap1 = EventList<Event>(
    events: {
      DateTime(2024, 05, 01): [
        Event(
          date: DateTime(0000, 00, 00),
          title: "Please! Try again",
          icon: eventIcon,
        ),
      ],
    },
  ).obs;*/
  Rx<DateTime> selectedToDate = DateTime.now().obs;
  RxString formattedFromDate = ''.obs;
  RxString formattedToDate = ''.obs;

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
      formattedFromDate.value =
          DateFormat('yyyy-MM-dd').format(selectedFromDate.value);
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedToDate.value,
      currentDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.day,
    );

    if (picked != null && picked != selectedToDate.value) {
      selectedToDate.value = picked;
      formattedToDate.value =
          DateFormat('yyyy-MM-dd').format(selectedToDate.value);
    }
  }

  void onInit() async {
    super.onInit();
    print("in init");
    employeeID.value =
        await PrefManager().readValue(key: PrefConst.addEmployeeId);
    // await dataListApi();
    await monthdataListApi();
    await DatewisedataListApi();
  }

  ///today attendance
  Future<void> dataListApi() async {
    await attdanceApi.viewAttendanceRepo(employeeID.value).then((value) {
      setRxRequestStatus(Status.Complete);
      setDataList(value);
      print("Attendance page controller working${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  ///today attendance
  Future<void> updateDataListApi() async {
    setRxRequestStatus(Status.Loading);

    await attdanceApi.viewAttendanceRepo(employeeID.value).then((value) {
      setRxRequestStatus(Status.Complete);
      setDataList(value);
      print("Class Data ${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  ///date vaali attendance
  Future<void> datewieseattendance(date) async {
    setRxRequestStatus(Status.Loading);
    await dateAttendanceapi
        .dateAttendanceRepo(employeeID.value, date)
        .then((value) {
      setRxRequestStatus(Status.Complete);
      setDateList(value);
      print("Date Data ${value.message}");
      // updateMarkedDates();
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  /* void updateMarkedDates() {
    markedDateMap1.value.clear();
    var attendanceList = DateAttendanceList.value.data;
    if (attendanceList != null) {
      for (var attendance in attendanceList) {
        DateTime date = DateFormat("yyyy-MM-dd").parse(attendance.date.toString());
        if (attendance.attandance == "P") {
          markedDateMap1.value.add(
            date,
            Event(
              date: date,
              title: 'Present',
              icon: _presentIcon,
            ),
          );
        } else if (attendance.attandance == "A") {
          markedDateMap1.value.add(
            date,
            Event(
              date: date,
              title: 'Absent',
              icon: _absentIcon,
            ),
          );
        }
      }
    }
  }
*/

  static Widget _presentIcon = Container(
    decoration: BoxDecoration(
      color: Colors.green,
      shape: BoxShape.circle,
    ),
  );

  static Widget _absentIcon = Container(
    decoration: BoxDecoration(
      color: Colors.red,
      shape: BoxShape.circle,
    ),
  );

  Future<void> monthdataListApi() async {
    await monthAttdenceApi
        .viewMonthAttendanceRepo(employeeID.value, currentMonth.value)
        .then((value) {
      setRxRequestStatus(Status.Complete);
      setMonthDataList(value);
      formattedDateToday.value = '';
      PrefManager().setAttendence(attendenceData: value);

      print("Attendance page controller working${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  Future<void> DatewisedataListApi() async {
    await dateWiseAttdenceApi
        .viewAllAttendanceRepo(employeeID.value)
        .then((value) async {
      setRxRequestStatus1(Status.Complete);
      TodayAttendaceModel model = TodayAttendaceModel.fromJson(value);
      var savedattendanceCalender = TodayAttendaceModel.fromJson(value);
      Map<DateTime, List<Event>> events = {};
      for (final d in savedattendanceCalender.data!) {
        if (kDebugMode) {
          // print("printing clock in in flutter ${d.clockIN}");
          // print("printing clock out in flutter ${d.clockOUT}");
        }
        String clockIN = d.clockIN ?? "2023-12-25T00:00:00";
        DateTime date = parseDateTime(clockIN);
        String formattedDate = formatDate(date);
        DateTime parsedDate = DateTime.parse(formattedDate);
        // Parse clock in and clock out times
        String clockInTime = d.clockIN != null
            ? DateFormat("hh:mm:ss a")
                .format(DateTime.parse(d.clockIN!).toLocal())
            : "N/A";
        String clockOutTime = d.clockOUT != null
            ? DateFormat("hh:mm:ss a")
                .format(DateTime.parse(d.clockOUT!).toLocal())
            : "N/A";

        events[parsedDate] = [
          Event(
            date: parsedDate,
            title: d.clockIN != null ? "P" : "A",
            icon: d.clockIN != null ? eventIcon : eventIcon1,
            description: "Clock In: $clockInTime\nClock Out: $clockOutTime",
          ),
        ];
      }
      if (kDebugMode) {
        print("Events Map: $events");
      }
      markedDateMap1.value = EventList<Event>(events: events);
      if (kDebugMode) {
        print("MarkedDateMap: ${markedDateMap1.value}");
      }
      String startDate = formattedFromDate.value;
      String endDate = formattedToDate.value;

      viewScheduledMonthDataList.value =
          model.filterDataBetweenDates(startDate, endDate);
      print("data aaya h bhai${viewScheduledMonthDataList.value}");
    }).onError((error, stackTrace) {
      setError(error.toString());

      /// i have to change the status to complete in this code
      setRxRequestStatus(Status.Complete);
    });
  }

  Future<void> selectMonthDate(BuildContext context) async {
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

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(date);
  }

  DateTime parseDateTime(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateTime(
        date.year, date.month, date.day); // Time set to 00:00:00.000 by default
  }

  Future<void> getAttendenceCalender() async {
    var data = await PrefManager().getattendenceCalender();
    if (kDebugMode) {
      print("abcd notes data  ${data}");
    }
    savedattendanceCalender.value =
        TodayAttendaceModel.fromJson(jsonDecode(data));
    Map<DateTime, List<Event>> events = {};
    for (final d in savedattendanceCalender.value.data!) {
      if (kDebugMode) {
        // print("printing clock in in flutter ${d.clockIN}");
        // print("printing clock out in flutter ${d.clockOUT}");
      }
      String clockIN = d.clockIN ?? "2023-12-25T00:00:00";
      DateTime date = parseDateTime(clockIN);
      String formattedDate = formatDate(date);
      DateTime parsedDate = DateTime.parse(formattedDate);
      // Parse clock in and clock out times
      String clockInTime = d.clockIN != null
          ? DateFormat("hh:mm:ss a")
              .format(DateTime.parse(d.clockIN!).toLocal())
          : "N/A";
      String clockOutTime = d.clockOUT != null
          ? DateFormat("hh:mm:ss a")
              .format(DateTime.parse(d.clockOUT!).toLocal())
          : "N/A";

      events[parsedDate] = [
        Event(
          date: parsedDate,
          title: d.clockIN != null ? "P" : "A",
          icon: d.clockIN != null ? eventIcon : eventIcon1,
          description: "Clock In: $clockInTime\nClock Out: $clockOutTime",
        ),
      ];
    }
    if (kDebugMode) {
      print("Events Map: $events");
    }
    markedDateMap1.value = EventList<Event>(events: events);
  }
}
