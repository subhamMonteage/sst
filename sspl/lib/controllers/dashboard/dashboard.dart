import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sspl/controllers/auth/login_screen_controller.dart';
import 'package:sspl/controllers/complaint/complaint_controller.dart';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';
import 'package:sspl/sevices/api_sevices/api_services.dart';
import 'package:sspl/sevices/models/Scheduler/schedular_view_model.dart';
import 'package:sspl/sevices/models/auth/login_model.dart';
import 'package:sspl/sevices/models/followup_model/today_followup_model.dart';
import 'package:sspl/sevices/models/visit_models/today_visit_model.dart';
import 'package:sspl/sevices/repo/login_view_model.dart';
import 'package:sspl/sevices/repo/repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sspl/utilities/get_user_loaction.dart';

import '../../infrastructure/routes/page_constants.dart';
import '../../sevices/models/complaint/complaint_view_model.dart';
import '../../sevices/repo/add_followup_view_model.dart';
import '../../utilities/custom_toast/custom_toast.dart';

class DashboardController extends GetxController {
// var complaintcontroller = Get.find<ComplaintController>();
  TextEditingController remarksController = TextEditingController();
  TextEditingController updatedate = TextEditingController();
  TextEditingController updatremark = TextEditingController();
  TextEditingController Cupdatremark = TextEditingController();
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
  String username = "";
  String password = "";
  var userDetails = LoginModel().obs;
  var viewtodayVisitApi = ViewTodayVisitRepo();
  var updatejobapi = UpdateJobStatus();

  final viewtodayVisitDataList = TodayVisitModel().obs;

  var viewtodayFollowupApi = TodayFollowupRepo();
  var viewschedularApi = ViewSchedularApi();

  final viewSchedularList = SchedularViewModel().obs;

  void setDataSchedular(SchedularViewModel _value) {
    viewSchedularList.value = _value;
  }

  final viewtodayFollowupDataList = TodayFollowupModel().obs;

  void setDataListfollowupToday(TodayFollowupModel _value) =>
      viewtodayFollowupDataList.value = _value; //
  RxString jobStatus = ''.obs;
  RxString Remarkupdate = ''.obs;
  RxString CRemarkupdate = ''.obs;

  void setError(String _value) => error.value = _value;

  void setDataList(TodayVisitModel _value) =>
      viewtodayVisitDataList.value = _value; //
  final rxRequestStatus = Status.Loading.obs;
  final rxscheduleStatus = Status.Loading.obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;

  void setRxRequestStatusScedular(Status _value) =>
      rxscheduleStatus.value = _value;
  var cId = "".obs;
  RxString error = "".obs;
  RxString selectedDate = "".obs;
  RxBool present = true.obs;
  var empId = 0.obs;
  var long = 0.0.obs;
  var lat = 0.0.obs;
  var address = ''.obs;
  RxString ScheduleUpdateStatus = ''.obs;

  final isLoading = false.obs;
  RxString selectedTime = "".obs;
  RxString currentDateTime = ''.obs;
  var checkIn = false.obs;
  var clockout = false.obs;
  final Rxn<DateTime> checkInTime = Rxn<DateTime>();
  final RxBool isClockedOutToday = RxBool(false);

  Future<void> initializeClockOutStatus() async {
    final PrefManager prefManager = PrefManager();

    // Load the check-out date from local storage
    var clockOutDateStr =
        await prefManager.readValue(key: PrefConst.clockOutDate);
    if (clockOutDateStr != null) {
      DateTime clockOutDate = DateTime.parse(clockOutDateStr);
      // Check if the stored date is today
      isClockedOutToday.value = DateFormat('yyyy-MM-dd').format(clockOutDate) ==
          DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  Future<void> initializeClockInStatus() async {
    final PrefManager prefManager = PrefManager();

    // Load the check-in date from local storage
    var clockInDateStr =
        await prefManager.readValue(key: PrefConst.clockInDate);
    if (clockInDateStr != null) {
      DateTime clockInDate = DateTime.parse(clockInDateStr);
      // Check if the stored date is today
      checkIn.value = DateFormat('yyyy-MM-dd').format(clockInDate) ==
          DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  Future<void> retrievecheckInTime() async {
    final PrefManager prefManager = PrefManager();
    print("fdfd");
    // // Load the check-in date from local storage
    // var clockInDateStr = await prefManager.readValue(key: PrefConst.checkInTime);
    // // if (clockInDateStr != null) {
    // //   DateTime clockInDate = DateTime.parse(clockInDateStr);
    // final dateTime = DateTime.parse(clockInDateStr);
    // final formattedTime = DateFormat('HH:mm:ss').format(dateTime);
    // final parsedDateTime = DateFormat('yyyy-MM-dd').parse(formattedDate);
    // // Assign the parsed DateTime value to checkInTime.value
    // print("datataa${parsedDateTime}");
    // checkInTime.value = dateTime;
    print("asjsdederuici======>${checkInTime.value}");
  }

  Rx<DateTime> selectedFromDate = DateTime.now().obs;
  Rx<DateTime> selectedToDate = DateTime.now().obs;
  RxString formattedFromDate = ''.obs;

  get homeworkFile => null;

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
  var schedularViewModel = SchedularViewModel().obs;

  @override
  void onInit() async {
    super.onInit();
    var isActive = await PrefManager().readValue(key: PrefConst.isActive);
    if (isActive == "De-Active") {
      exit(0);
    }
    username = await PrefManager().readValue(key: PrefConst.username);
    password = await PrefManager().readValue(key: PrefConst.userpass);

    initializeClockOutStatus();
    initializeClockInStatus();
    UserLocation().getLatLng();
    permissionServiceCall();
    loadValues();
    var data = await PrefManager().getUserDetails();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateDateTime());
    Timer.periodic(Duration(seconds: 1), (Timer t) => loginApi());
    userDetails.value = LoginModel.fromJson(jsonDecode(data));
    cId.value = await PrefManager().readValue(key: PrefConst.cId);
    await ComplaintViewApi();
    // dataListApi();
    await dataListApiTodatfollowup();
    //Schedular APi
    await viewschedular();
    await datefilterschedular();

    // retrievecheckInTime();
  }

  Map get data => {
        "EmailID": username,
        "Password": password,
      };

  final myRepo = LoginRepo();
  late RxString isactive = "".obs;

  Future<void> loginApi() async {
    myRepo.loginApi(data).then((value) async {
      var data = LoginModel.fromJson(value);

      if (data.data == null) {
      } else if (data.data != null) {
        isactive.value = data.data!.action!;
        PrefManager()
            .writeValue(key: PrefConst.isActive, value: isactive.value);
        if (isactive.value == "De-Active") {
          exit(0);
        }
      } else if (data.statuscode == 400) {}
    }).onError((error, stackTrace) {
      print("error data ===>${error}");
      ShortMessage.toast(title: "Something went wrong");
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  void _updateDateTime() {
    currentDateTime.value = DateFormat('hh:mm:ss a').format(DateTime.now());
  }

  permissionServiceCall() async {
    await permissionServices().then(
      (value) {
        if (value != null) {
          if (value[Permission.locationAlways]!.isGranted) {
            ShortMessage.toast(title: "Location is granted");
          }
          if (value == null) {
            openAppSettings();
          }
        }
      },
    );
  }

  /*Permission services*/
  Future<Map<Permission, PermissionStatus>> permissionServices() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationAlways,
    ].request();

    if (statuses[Permission.locationAlways]!.isDenied) {
      await openAppSettings().then(
        (value) async {
          if (value) {
            if (await Permission.locationAlways.status.isDenied == true &&
                await Permission.locationAlways.status.isGranted == false) {
              // openAppSettings();
              bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
              if (!serviceEnabled) {
                ShortMessage.toast(title: "Location Not enabled");
                await showAdaptiveDialog<bool>(
                  context: Get.context!,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog.adaptive(
                      content: const Text(
                          'Your Location is not enabled, Please enable it and restart the app again'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            await Geolocator.openLocationSettings();
                            // exit(0);
                          },
                          child: const Text('Ok'),
                        ),
                      ],
                    );
                  },
                );
                return Future.error('Location services are disabled.');
              }
              Future.delayed(const Duration(seconds: 2))
                  .then((value) => permissionServiceCall());
              /* opens app settings until permission is granted */
            }
          }
        },
      );
    }
/*    else {
      if (statuses[Permission.location]!.isDenied) {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          ShortMessage.toast(title: "Location Not enabled");
          await showAdaptiveDialog<bool>(
            context: Get.context!,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog.adaptive(
                content: const Text(
                    'Your Location is not enabled, Please enable it and restart the app again'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await Geolocator.openLocationSettings();
                      // exit(0);
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            },
          );
          return Future.error('Location services are disabled.');
        }
        permissionServiceCall();
      }
    }
*/
    /*{Permission.camera: PermissionStatus.granted, Permission.storage: PermissionStatus.granted}*/
    return statuses;
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

  void updateJobStatus(var data) {
    updatejobapi.updateJobStatusRepo(data).then((value) {
      setRxRequestStatus(Status.Complete);
      // setDataList(value);
      print("update job message ${value.message}");
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

  ///data
  Future<void> viewschedular() async {
    await viewschedularApi.viewSchedularRepo(empId.value).then((value) {
      setRxRequestStatusScedular(Status.Complete);
      setDataSchedular(value);
      print("schedular data ${value.data![0].description}");
    }).onError((error, stackTrace) {
      print("error in ${error.toString()}");
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  Future<void> datefilterschedular() async {
    await viewschedularApi.datefilterSchedularRepo(empId.value).then((value) {
      setRxRequestStatusScedular(Status.Complete);
      SchedularViewModel model = SchedularViewModel.fromJson(value);
      schedularViewModel.value = SchedularViewModel.fromJson(value);
      Map<DateTime, List<Event>> events = {};
      for (final d in schedularViewModel.value.data!) {
        // if (kDebugMode) {
        // print("printing clock in in flutter ${d.schedulerDate}");
        // }
        events[DateTime.parse(d.schedulerDate ?? "2023-12-25T00:00:00")] = [
          Event(
            date: DateTime.parse(d.schedulerDate ?? "2023-12-25T00:00:00"),
            title: d.schedulerDate != null
                ? "Schedule for ${DateFormat('yyyy-MM-dd').format(DateTime.parse(d.schedulerDate.toString()))}"
                : " ",
            icon: d.schedulerDate != null ? eventIcon : eventIcon1,
          ),
        ];
      }
      if (kDebugMode) {
        print("Events Map: $events");
      }
      markedDateMap1.value = EventList<Event>(events: events);
      if (kDebugMode) {
        print("Marked date Map: ${markedDateMap1.value.events}");
      }
      String startDate = formattedFromDate.value;
      String endDate = formattedToDate.value;
      viewSchedularList.value =
          model.filterDataBetweenDates(startDate, endDate);
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  Future<void> updateviewschedular() async {
    setRxRequestStatusScedular(Status.Loading);
    await viewschedularApi.viewSchedularRepo(empId.value).then((value) {
      setRxRequestStatusScedular(Status.Complete);
      setDataSchedular(value);
      print("schedular data ${value.data![0].description}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  Future<void> dataListApiTodatfollowup() async {
    setRxRequestStatusScedular(Status.Loading);
    await viewtodayFollowupApi.todayFollowupRepo(empId.value).then((value) {
      setRxRequestStatusScedular(Status.Complete);
      setDataListfollowupToday(value);
      print("visit today data Data ${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      print("ERROR IN ASSIGNED JOB ${error.toString()}");
      setRxRequestStatus(Status.Error);
    });
  }

  Future<void> updateDataListApiTodatfollowup() async {
    setRxRequestStatusScedular(Status.Loading);
    await viewtodayFollowupApi.todayFollowupRepo(empId.value).then((value) {
      setRxRequestStatusScedular(Status.Complete);
      setDataListfollowupToday(value);
      print("visit today data Data ${value.message}");
    }).onError((error, stackTrace) {
      print("error h bhai :${error.toString()}");
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  void setComplaintData(ComplaintViewModel _value) {
    complaintlist.value = _value;
  }

  var complaintlist = ComplaintViewModel().obs;
  final complaintapi = ViewComplaint();

  Future<void> ComplaintViewApi() async {
    setRxRequestStatus(Status.Loading);
    complaintapi.viewComplaintRepo(empId.value).then((value) {
      setRxRequestStatus(Status.Complete);
      setComplaintData(value);
      print("Class Data ${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  Future<void> datefilterapi() async {
    setRxRequestStatus(Status.Loading);

    await viewtodayFollowupApi.dateFollowupRepo(empId.value).then((value) {
      setRxRequestStatus(Status.Complete);
      TodayFollowupModel model = TodayFollowupModel.fromJson(value);
      String startDate = formattedFromDate.value;
      String endDate = formattedToDate.value;

      viewtodayFollowupDataList.value =
          model.filterDataBetweenDates(startDate, endDate);
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  Future<void> updateDataListApiScheduler() async {
    setRxRequestStatusScedular(Status.Loading);

    await viewtodayFollowupApi.todayFollowupRepo(empId.value).then((value) {
      setRxRequestStatusScedular(Status.Complete);
      setDataListfollowupToday(value);
      print("visit today data Data ${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  void loadValues() async {
    empId.value = await PrefManager().readValue(key: PrefConst.addEmployeeId);
    print(empId.value);
    long.value = await PrefManager().readValue(key: PrefConst.clockInLong);
    print(long.value);
    lat.value = await PrefManager().readValue(key: PrefConst.clockInLat);
    print(lat.value);
    address.value =
        await PrefManager().readValue(key: PrefConst.clockInLoc) as String;
    print(address.value);
  }
}
