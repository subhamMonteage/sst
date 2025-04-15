import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sspl/controllers/checkIn/checkincontroller.dart';
import 'package:sspl/controllers/dashboard/dashboard.dart';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';
import 'package:sspl/utilities/custom_color/custom_color.dart';
import 'package:sspl/utilities/custom_text/custom_text.dart';
import 'package:http/http.dart' as https;
import 'package:sspl/utilities/custom_toast/custom_toast.dart';
import 'package:sspl/utilities/get_user_loaction.dart';
import '../../infrastructure/image_constants/image_constants.dart';
import '../../infrastructure/routes/page_constants.dart';

class CheckInScreen extends GetView<DashboardController> {
  CheckInScreen({super.key});

  final CheckInController checkInController = Get.put(CheckInController());
  final DashboardController dashboardController =
      Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    final PrefManager prefManager = PrefManager();

    //clock in post api method......
    Future<void> clockInAttendance(empId, lat, long, address) async {
      const String url =
          'http://sarvaperp.eduagentapp.com/api/SarvapErp/ClockINAttandance';

      Map<dynamic, dynamic> body = {
        "EmployeeId": empId.toString(),
        "ClockINLatitude": lat.toString(),
        "ClockINLongitude": long.toString(),
        "ClockINLocation": address
      };

      try {
        final response = await https.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(body),
        );

        if (response.statusCode == 200) {
          print(url);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Clock in successful'),
            ),
          );

          print('Clock in successful');
          print('Response body: ${response.body}');

          controller.checkInTime.value = DateTime.now();
          PrefManager().writeValue(
              key: PrefConst.checkInTime,
              value: controller.checkInTime.value?.toIso8601String());
          // Store the check-in time
        } else {
          print('Failed to clock in. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Error occurred while clocking in: $e');
      }
    }

    //clockOut attendance api call.....
    Future<void> clockOutAttendance(empId, lat, long, address) async {
      const String url =
          'http://sarvaperp.eduagentapp.com/api/SarvapErp/ClockOutAttandance';

      Map<dynamic, dynamic> body = {
        "EmployeeId": empId.toString(),
        "ClockOUTLatitude": lat.toString(),
        "ClockOUTLongitude": long.toString(),
        "ClockOUTLocation": address
      };

      try {
        final response = await https.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(body),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Clock Out successful'),
            ),
          );

          if (kDebugMode) {
            print('Clock out successful');
          }
          print('Response body: ${response.body}');

          // Save the current date as the check-out date
          await prefManager.writeValue(
              key: PrefConst.clockOutDate,
              value: DateTime.now().toIso8601String());
          controller.isClockedOutToday.value = true;
        } else {
          print('Failed to clock out. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Error occurred while clocking out: $e');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomColor.blueColor,
        leading: InkWell(
            onTap: () {
              Get.toNamed(AppRoutesName.dashboard_screen);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: Get.height / 2,
            decoration: const BoxDecoration(
              color: CustomColor.blueColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(100),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                CircleAvatar(
                  maxRadius: 60,
                  child: Image.asset(
                    ImageConstants.logo,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomText(
                  data:
                      "${controller.userDetails.value.data?.firstName == null ? "" : controller.userDetails.value.data!.firstName} ${controller.userDetails.value.data?.lastName == null ? "" : controller.userDetails.value.data!.lastName}",
                  fontSize: 30,
                  color: Colors.white,
                ),
                const Spacer(),
                CustomText(
                  data: DateFormat("dd MMMM yyyy").format(DateTime.now()),
                  color: Colors.white,
                  fontSize: 25,
                ),
                Obx(() => CustomText(
                      data: controller.currentDateTime.value,
                      color: Colors.white,
                      fontSize: 33,
                    )),
                const Spacer(),
              ],
            ),
          ),
          Container(
            color: CustomColor.blueColor,
            child: Container(
              height: Get.height / 2,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(100.r))),
              child: Obx(() => Column(
                    children: [
                      SizedBox(
                        height: 40.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              CustomText(
                                data: "In Time",
                                fontSize: 19,
                                color: CustomColor.blueColor,
                              ),
                              CustomText(
                                data: checkInController.viewScheduledDataList
                                                .value.data !=
                                            null &&
                                        checkInController.viewScheduledDataList
                                            .value.data!.isNotEmpty
                                    ? DateFormat("hh:mm:ss a").format(
                                        DateTime.parse(checkInController
                                                .viewScheduledDataList
                                                .value
                                                .data!
                                                .first
                                                .clockIN ??
                                            "1970-01-01T00:00:00"))
                                    : "00:00",
                                fontSize: 19,
                                color: CustomColor.blueColor,
                              ),
                            ],
                          ),
                          Container(
                            height: 40.h,
                            width: 2.w,
                            color: CustomColor.blueColor,
                          ),
                          Column(
                            children: [
                              CustomText(
                                data: "Out Time",
                                fontSize: 19,
                                color: CustomColor.blueColor,
                              ),
                              CustomText(
                                data: checkInController.viewScheduledDataList
                                                .value.data !=
                                            null &&
                                        checkInController.viewScheduledDataList
                                            .value.data!.isNotEmpty &&
                                        checkInController.viewScheduledDataList
                                                .value.data!.first.clockOUT !=
                                            null
                                    ? DateFormat("hh:mm:ss a").format(
                                        DateTime.parse(checkInController
                                            .viewScheduledDataList
                                            .value
                                            .data!
                                            .first
                                            .clockOUT!))
                                    : "00:00",
                                fontSize: 19,
                                color: CustomColor.blueColor,
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 80.h,
                      ),
                      Obx(
                        () => controller.isClockedOutToday.value ||
                                controller.clockout.value
                            ? Container() // Hide the button when clocked out today
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.h, horizontal: 30.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(19.r),
                                  color: Colors.blue[800],
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    if (controller.checkIn.value) {
                                      var connectivityResult =
                                          await (Connectivity()
                                              .checkConnectivity());

                                      if (connectivityResult ==
                                          ConnectivityResult.none) {
                                        // No internet connection
                                        // Show a message to the user or handle it accordingly
                                        ShortMessage.toast(
                                            title: "No Internet");
                                        print("No internet connection");
                                        // You can use a Snackbar or Dialog to inform the user
                                      } else {
                                        // Internet connection is available
                                        await clockOutAttendance(
                                          controller.empId.value,
                                          controller.lat.value,
                                          controller.long.value,
                                          await PrefManager().readValue(
                                                  key: PrefConst.clockOutLoc) ??
                                              "",
                                        );
                                        controller.clockout.value = true;

                                        // Delayed operation to reset states and navigate back
                                        Future.delayed(
                                            const Duration(seconds: 5), () {
                                          controller.checkIn.value = false;
                                          controller.clockout.value = false;
                                          controller.checkInTime.value = null;
                                          PrefManager().writeValue(
                                              key: PrefConst.checkInTime,
                                              value: null);
                                          Get.back(); // Navigate back
                                        });
                                      }
                                      // Perform check out
                                    } else {
                                      // Perform check in
                                      var connectivityResult =
                                          await (Connectivity()
                                              .checkConnectivity());

                                      if (connectivityResult ==
                                          ConnectivityResult.none) {
                                        // No internet connection
                                        // Show a message to the user or handle it accordingly
                                        ShortMessage.toast(
                                            title: "No Internet");
                                        print("No internet connection");
                                        // You can use a Snackbar or Dialog to inform the user
                                      } else {
                                        // Internet connection is available
                                        await clockInAttendance(
                                          controller.empId.value,
                                          controller.lat.value,
                                          controller.long.value,
                                          await PrefManager().readValue(
                                                  key: PrefConst.clockInLoc) ??
                                              "", // Ensure it's not null
                                        );
                                        await prefManager.writeValue(
                                            key: PrefConst.clockInDate,
                                            value: DateTime.now()
                                                .toIso8601String());
                                        print(
                                            "checkin h ya nhi check in screen ${await prefManager.readValue(key: PrefConst.clockInDate)}");
                                        controller.checkIn.value = true;
                                        controller.checkInTime.value = DateTime
                                            .now(); // Store check-in time
                                      }
                                      // Schedule automatic clock out at 12 AM
                                      final midnight = DateTime.now()
                                              .add(Duration(days: 1))
                                              .toLocal()
                                              .hour ==
                                          0;
                                      Timer.periodic(Duration(hours: 1),
                                          (timer) async {
                                        if (DateTime.now().hour == 0 &&
                                            !controller.clockout.value) {
                                          // Perform automatic clock out
                                          await clockOutAttendance(
                                            controller.empId.value,
                                            controller.lat.value,
                                            controller.long.value,
                                            await PrefManager().readValue(
                                                    key: PrefConst
                                                        .clockOutLoc) ??
                                                "",
                                          );
                                          controller.clockout.value = true;
                                          timer
                                              .cancel(); // Cancel the periodic timer after performing clock out
                                        }
                                      });
                                    }
                                  },
                                  child: CustomText(
                                    data: controller.checkIn.value
                                        ? "Check Out"
                                        : "Check In",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
