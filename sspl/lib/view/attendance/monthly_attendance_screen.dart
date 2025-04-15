import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sspl/controllers/attendance/month_attdance_controller.dart';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';

import '../../controllers/attendance/attendance_controller.dart';
import '../../infrastructure/image_constants/image_constants.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../utilities/custom_color/custom_color.dart';
import '../../utilities/custom_text/custom_text.dart';

class MonthlyAttendanceScreen extends GetView<MonthlyAttendanceController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: Image.asset(
          ImageConstants.logo,
          width: 130.h,
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Container(
            width: Get.width,
            // padding: EdgeInsets.symmetric(horizontal: 6.h),
            //margin: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(6.r),
              color: CustomColor.blueColor,
            ),
            alignment: Alignment.center,
            child: CustomText(
              data: "Monthly Attendance Screen",
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Obx(() {
            return InkWell(
              onTap: () => controller.selectFromDate(context),
              child: Container(
                  width: Get.width / 2.5,
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      controller.formattedDateToday.value == ""
                          ? Expanded(
                              child: CustomText(data: 'Select From Date'))
                          : Expanded(
                              child: CustomText(
                                data: controller.formattedDateToday
                                    .value, // Display the formatted date
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      const Icon(Icons.calendar_month)
                    ],
                  )),
            );
          }),
          Obx(
            () {
              switch (controller.rxRequestStatus.value) {
                case Status.Loading:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case Status.Complete:
                  return Expanded(
                    child: CustomRefreshIndicator(
                      leadingScrollIndicatorVisible: false,
                      trailingScrollIndicatorVisible: false,
                      builder: MaterialIndicatorDelegate(
                        builder: (context, controller) {
                          return Icon(
                            Icons.refresh,
                            color: Theme.of(context).colorScheme.primary,
                            size: 30,
                          );
                        },
                        scrollableBuilder: (context, child, controller) {
                          return Opacity(
                            opacity: 1.0 - controller.value.clamp(0.0, 1.0),
                            child: child,
                          );
                        },
                      ),
                      onRefresh: () => Future.delayed(
                          const Duration(milliseconds: 2), () async {
                        // await controller.updateDataListApi();
                      }),
                      child: controller.viewScheduledMonthDataList.value.data
                                  ?.length ==
                              null
                          ? CustomText(data: "Data not found")
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: controller.viewScheduledMonthDataList
                                  .value.data?.length,
                              itemBuilder: (context, index) {
                                int reverseIndex = controller
                                        .viewScheduledMonthDataList
                                        .value
                                        .data!
                                        .length -
                                    1 -
                                    index;
                                String attendanceDate = controller
                                            .viewScheduledMonthDataList
                                            .value
                                            .data?[reverseIndex]
                                            .date ==
                                        null
                                    ? ""
                                    : controller.viewScheduledMonthDataList
                                        .value.data![reverseIndex].date
                                        .toString();
                                String apiDate =
                                    "${controller.viewScheduledMonthDataList.value.data![reverseIndex].clockIN}";
                                String apiDate1 =
                                    "${controller.viewScheduledMonthDataList.value.data![reverseIndex].clockOUT}";

                                DateTime dateString = DateTime.parse(apiDate);
                                DateTime dateString1 = DateTime.parse(apiDate1);
                                DateTime dateString2 =
                                    DateTime.parse(attendanceDate);
                                String checkInTime =
                                    DateFormat("dd MMM yyyy HH:mm:ss a")
                                        .format(dateString);

                                String checkOutTime =
                                    DateFormat("dd MMM yyyy HH:mm:ss a")
                                        .format(dateString1);
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 10.h),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(2, 6),
                                        blurRadius: 8.r,
                                        color: Colors.blue.withOpacity(0.9),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.end,
                                      //   children: [
                                      //     Icon(
                                      //       Icons.calendar_month,
                                      //       size: 25.r,
                                      //     ),
                                      //     CustomText(
                                      //       data: attendanceDateTime,
                                      //       fontWeight: FontWeight.w500,
                                      //     ),
                                      //   ],
                                      // ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 35.h,
                                            width: 35.h,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50.r),
                                                color: CustomColor.blueColor),
                                            child: CustomText(
                                              data: "P",
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CustomText(
                                                      data: "Clock-In    : ",
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    SizedBox(
                                                      width: 200.w,
                                                      child: CustomText(
                                                        data: checkInTime,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CustomText(
                                                      data: "Clock-Out : ",
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    SizedBox(
                                                      width: 200.w,
                                                      child: CustomText(
                                                        data: checkOutTime,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  );

                case Status.Error:
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              // controller.updateDataListApi();
                            },
                            child: CustomText(data: "Retry"))
                      ],
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
