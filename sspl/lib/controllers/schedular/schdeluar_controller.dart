import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../sevices/api_sevices/api_services.dart';

class SchedularController extends GetxController {
  RxString ScheduleUpdateStatus = ''.obs;
  final rxRequestStatus = Status.Complete.obs;
  RxString error = "".obs;
  Rx<DateTime> selectedFromDate = DateTime.now().obs;
  Rx<DateTime> selectedToDate = DateTime.now().obs;
  RxString formattedFromDate = ''.obs;
  RxString formattedToDate = ''.obs;
  Rx<DateTime> currentDate2 = DateTime.now().obs;
  RxString currentMonth = DateFormat.yMMM().format(DateTime.now()).obs;
  Rx<DateTime> targetDateTime = DateTime.now().obs;
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
  RxString formattedDateToday = "".obs;
  RxString todayDate = "".obs;
  var employeeID = 0.obs;
  var markedDateMap = EventList<Event>(
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
}
