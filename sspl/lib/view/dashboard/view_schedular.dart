import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:search_page/search_page.dart';
import 'package:sspl/controllers/dashboard/dashboard.dart';
import 'package:sspl/controllers/schedular/schdeluar_controller.dart';
import 'package:sspl/sevices/models/Scheduler/schedular_view_model.dart';
import 'package:http/http.dart' as http;
import '../../infrastructure/local_storage/local_storage.dart';
import '../../infrastructure/local_storage/pref_consts.dart';
import '../../infrastructure/routes/page_constants.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../sevices/models/attendance/view_attendance_model.dart';
import '../../utilities/custom_color/custom_color.dart';
import '../../utilities/custom_text/custom_text.dart';
import '../../utilities/custom_toast/custom_toast.dart';

class ViewSchedular extends GetView<SchedularController> {
  var dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    Future<void> updateSchedulerStatus(
        String schedulerId, String status) async {
      const String apiUrl =
          "http://sarvaperp.eduagentapp.com/api/SarvapErp/SchedulerUpdate";

      // Define the request body
      Map<String, dynamic> requestBody = {
        "SchedulerId": schedulerId,
        "Status": status,
      };

      try {
        // Make the POST request
        final http.Response response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 200) {
          // Request was successful
          print("Scheduler updated successfully");
        } else {
          // Request failed
          print(
              "Failed to update scheduler. Status code: ${response.statusCode}");
        }
      } catch (e) {
        // Handle any errors that occur during the request
        print("An error occurred: $e");
      }
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: CustomText(
              data: 'Schedular',
              color: Colors.white,
              fontSize: 20.sp,
            ),
            elevation: 0,
            centerTitle: true,
            backgroundColor: CustomColor.blueColor,
            actions: [
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutesName.Scheduler_screen);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      CustomText(
                        data: "",
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[800],
                      ),
                      const Icon(Icons.add)
                    ],
                  ),
                ),
              ),
            ],
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20.r,
                ))),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 55.h,
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                bottom: TabBar(
                  indicatorColor: CustomColor.blueColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                        child: CustomText(
                      data: "Schedule Detail",
                      color: Colors.black,
                    )),
                    Tab(
                      child: CustomText(
                        data: "Calendar",
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      body: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 55.h,
                            child: AppBar(
                              automaticallyImplyLeading: false,
                              backgroundColor: Colors.white,
                              bottom: TabBar(
                                indicatorColor: Color(0xFF268ac5),
                                indicatorSize: TabBarIndicatorSize.tab,
                                tabs: [
                                  Tab(
                                    child: CustomText(
                                      data: "Pending ",
                                      color: Colors.red,
                                    ),
                                  ),
                                  Tab(
                                      child: CustomText(
                                    data: "Completed ",
                                    color: Colors.green,
                                  )),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                SingleChildScrollView(
                                  child: Obx(
                                    () {
                                      switch (dashboardController
                                          .rxscheduleStatus.value) {
                                        case Status.Loading:
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        case Status.Complete:
                                          // Filter the list to include only items with jobStatus "Pending"
                                          var pendingItems = dashboardController
                                                  .viewSchedularList.value.data
                                                  ?.where((item) =>
                                                      item.status == "Pending")
                                                  .toList() ??
                                              [];

                                          return Column(
                                            children: [
                                              Container(
                                                height: 60.h,
                                                width: Get.width,
                                                padding: EdgeInsets.all(10.r),
                                                decoration: BoxDecoration(
                                                    // border: Border.all(width: 0.5.w),
                                                    color: Colors.white),
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        showSearch(
                                                          context: context,
                                                          delegate: SearchPage<
                                                                  Data>(
                                                              items:
                                                                  pendingItems ??
                                                                      [],
                                                              searchLabel:
                                                                  'Schedular',
                                                              suggestion:
                                                                  Center(
                                                                child:
                                                                    AutoSizeText(
                                                                  'Filter Schedular by any field',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        15.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                              failure: Center(
                                                                child:
                                                                    AutoSizeText(
                                                                  'Found Nothing :(',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        15.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                              filter:
                                                                  (person) => [
                                                                        person
                                                                            .description,
                                                                        person
                                                                            .date,
                                                                        DateFormat('dd MMMM yyyy').format(DateTime.parse(person
                                                                            .createDate
                                                                            .toString())),
                                                                        person
                                                                            .status,
                                                                        person
                                                                            .namee
                                                                      ],
                                                              builder:
                                                                  (person) {
                                                                return Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          15.w,
                                                                      vertical:
                                                                          5.h),
                                                                  margin: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          15.w,
                                                                      vertical:
                                                                          8.h),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.r),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          offset: const Offset(
                                                                              0,
                                                                              4),
                                                                          color: Colors
                                                                              .indigo
                                                                              .shade100,
                                                                          blurRadius:
                                                                              5.r),
                                                                      BoxShadow(
                                                                          offset: const Offset(
                                                                              0,
                                                                              -1),
                                                                          color: Colors
                                                                              .indigo
                                                                              .shade100,
                                                                          blurRadius:
                                                                              3.r),
                                                                    ],
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                CustomText(
                                                                              data: "Desc :",
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                          ),
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.centerRight,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                const Icon(Icons.date_range),
                                                                                Container(
                                                                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(10.r),
                                                                                  ),
                                                                                  child: CustomText(
                                                                                    data: person.createDate == null ? "" : DateFormat('dd MMMM yyyy').format(DateTime.parse(person.createDate.toString())),
                                                                                    fontSize: 16.sp,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Divider(),
                                                                          Container(
                                                                            //padding: EdgeInsets.symmetric( vertical: 5.h),
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: CustomText(
                                                                                data: person.description == null ? "Job remaining" : person.description.toString(),
                                                                                fontSize: 16.sp,
                                                                                //fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Divider(),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          CustomText(
                                                                            data:
                                                                                "Status:",
                                                                            fontSize:
                                                                                16.sp,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              //    Show dialog for check in options
                                                                              await showAdaptiveDialog<bool>(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return AlertDialog.adaptive(
                                                                                    content: Text(
                                                                                      'Update Status',
                                                                                      style: TextStyle(
                                                                                        fontSize: 16.sp,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                    actions: [
                                                                                      Container(
                                                                                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                                                                                          // alignment: Alignment.center,
                                                                                          decoration: BoxDecoration(
                                                                                              // color: Colors.grey.shade200,
                                                                                              // borderRadius: BorderRadius.circular(50.r),
                                                                                              ),
                                                                                          child: Align(
                                                                                              alignment: Alignment.centerLeft,
                                                                                              child: Text(
                                                                                                "Status",
                                                                                                style: TextStyle(
                                                                                                  fontSize: 16.sp,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                ),
                                                                                              ))),
                                                                                      SizedBox(
                                                                                        height: 10.h,
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                                                                                        alignment: Alignment.center,
                                                                                        decoration: BoxDecoration(
                                                                                          color: Colors.grey.shade200,
                                                                                          borderRadius: BorderRadius.circular(50.r),
                                                                                        ),
                                                                                        child: Obx(
                                                                                          () => DropdownButtonFormField<String>(
                                                                                            value: controller.ScheduleUpdateStatus.value.isEmpty ? null : controller.ScheduleUpdateStatus.value,
                                                                                            onChanged: (String? newValue) {
                                                                                              if (newValue != null) {
                                                                                                controller.ScheduleUpdateStatus.value = newValue; // Update the RxString value
                                                                                              }
                                                                                            },
                                                                                            decoration: const InputDecoration(
                                                                                              hintText: "",
                                                                                              border: InputBorder.none,
                                                                                            ),
                                                                                            hint: Text(
                                                                                              "Status",
                                                                                              style: GoogleFonts.roboto(color: Colors.grey),
                                                                                            ),
                                                                                            items: ["Completed"]
                                                                                                .map((leaveType) => DropdownMenuItem<String>(
                                                                                                      value: leaveType,
                                                                                                      child: Text(leaveType),
                                                                                                    ))
                                                                                                .toList(),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      TextButton(
                                                                                        onPressed: () async {
                                                                                          updateSchedulerStatus(
                                                                                            person.schedulerId.toString(),
                                                                                            controller.ScheduleUpdateStatus.value.toString(),
                                                                                          );
                                                                                          Get.back();
                                                                                        },
                                                                                        child: const Text('Submit'),
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                            child:
                                                                                CustomText(
                                                                              data: person.status ?? "",
                                                                              fontSize: 16.sp,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: person.status == "Pending"
                                                                                  ? Colors.red
                                                                                  : person.status == "Completed"
                                                                                      ? Colors.green
                                                                                      : Colors.black,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Divider(),
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          CustomText(
                                                                            data:
                                                                                "Create By : ",
                                                                            fontSize:
                                                                                16.sp,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          CustomText(
                                                                            data: person.namee == null
                                                                                ? ""
                                                                                : person.namee.toString(),
                                                                            fontSize:
                                                                                16.sp,
                                                                            //fontWeight: FontWeight.w500,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }),
                                                        );
                                                      },
                                                      child: Container(
                                                        // width: Get.width,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .grey.shade100,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                          // border: Border.all(
                                                          //   color: Colors.black,
                                                          // ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height: 50.h,
                                                              width: 50.w,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right: 135
                                                                          .w),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: CustomColor
                                                                    .blueColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10.r),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                    10.r,
                                                                  ),
                                                                ),
                                                              ),
                                                              child: Icon(
                                                                Icons.search,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            CustomText(
                                                              data: "Search",
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            SizedBox(
                                                              width: 135.w,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Get.bottomSheet(
                                                            Container(
                                                          height: 320.h,
                                                          width: Get.width,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .white),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                height: 50.h,
                                                                width:
                                                                    Get.width,
                                                                color: CustomColor
                                                                    .blueColor,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        left: 20
                                                                            .w,
                                                                      ),
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Get.back();
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          CupertinoIcons
                                                                              .multiply,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    CustomText(
                                                                      data:
                                                                          "Filters",
                                                                      fontSize:
                                                                          20.sp,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          60.w,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            20.w),
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          20.h,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        RichText(
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                "Date from",
                                                                            style:
                                                                                GoogleFonts.roboto(fontSize: 18.sp, color: Colors.black),
                                                                            children: [
                                                                              TextSpan(
                                                                                text: "*",
                                                                                style: GoogleFonts.roboto(fontSize: 20.sp, color: Colors.red),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Obx(() {
                                                                      return Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                20.w,
                                                                            right: 20.w,
                                                                            top: 10.h),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Column(
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 50.h,
                                                                                  width: 400.w,
                                                                                  child: InkWell(
                                                                                    onTap: () => dashboardController.selectFromDate(context),
                                                                                    child: dashboardController.formattedFromDate.value == ""
                                                                                        ? Container(
                                                                                            alignment: Alignment.centerLeft,
                                                                                            height: 50.h,
                                                                                            width: 400,
                                                                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)),
                                                                                            child: CustomText(
                                                                                              data: '   Select From Date',
                                                                                            ),
                                                                                          )
                                                                                        : Container(
                                                                                            height: 50.h,
                                                                                            width: 400,
                                                                                            alignment: Alignment.centerLeft,
                                                                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)),
                                                                                            child: CustomText(
                                                                                              data: '  ${dashboardController.formattedFromDate.value}',
                                                                                              // Display the formatted date

                                                                                              fontSize: 14,
                                                                                            ),
                                                                                          ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }),
                                                                    SizedBox(
                                                                      height:
                                                                          10.h,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        RichText(
                                                                            text: TextSpan(
                                                                                text: "Date to",
                                                                                style: GoogleFonts.roboto(fontSize: 18.sp, color: Colors.black),
                                                                                children: [
                                                                              TextSpan(
                                                                                text: "*",
                                                                                style: GoogleFonts.roboto(fontSize: 20.sp, color: Colors.red),
                                                                              )
                                                                            ])),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10.h,
                                                                    ),
                                                                    Obx(() {
                                                                      return Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          left:
                                                                              20.w,
                                                                          right:
                                                                              20.w,
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 50.h,
                                                                              width: 400.w,
                                                                              child: InkWell(
                                                                                onTap: () => dashboardController.selectToDate(context),
                                                                                child: dashboardController.formattedToDate.value == ""
                                                                                    ? Container(alignment: Alignment.centerLeft, height: 50.h, width: 400, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)), child: CustomText(data: '   Select To Date'))
                                                                                    : Container(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        height: 50.h,
                                                                                        width: 400,
                                                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)),
                                                                                        child: CustomText(
                                                                                          data: '  ${dashboardController.formattedToDate.value}',
                                                                                          // Display the formatted date

                                                                                          fontSize: 14.sp,
                                                                                        ),
                                                                                      ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 15.h,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }),
                                                                    SizedBox(
                                                                      height:
                                                                          10.h,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (dashboardController.formattedFromDate.value !=
                                                                                "" &&
                                                                            dashboardController.formattedToDate.value !=
                                                                                "") {
                                                                          dashboardController
                                                                              .datefilterschedular();
                                                                          Get.back();
                                                                        } else {
                                                                          ShortMessage.toast(
                                                                              title: "Please select date");
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            50.h,
                                                                        width: Get
                                                                            .width,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        decoration:
                                                                            BoxDecoration(color: CustomColor.blueColor),
                                                                        child:
                                                                            CustomText(
                                                                          data:
                                                                              "Apply Filter",
                                                                          fontSize:
                                                                              18.sp,
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ));
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 6.w),
                                                        height: 50.h,
                                                        width: 50.w,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.r),
                                                            border: Border.all(
                                                                width: 0.5.w)),
                                                        child: Icon(
                                                          Icons.calendar_month,
                                                          size: 40.r,
                                                          color: CustomColor
                                                              .blueColor,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.5,
                                                child: CustomRefreshIndicator(
                                                  leadingScrollIndicatorVisible:
                                                      true,
                                                  trailingScrollIndicatorVisible:
                                                      true,
                                                  builder:
                                                      MaterialIndicatorDelegate(
                                                    builder:
                                                        (context, controller) {
                                                      return Icon(
                                                        Icons.refresh,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        size: 30,
                                                      );
                                                    },
                                                    scrollableBuilder: (context,
                                                        child, controller) {
                                                      return Opacity(
                                                        opacity: 1.0 -
                                                            controller.value
                                                                .clamp(
                                                                    0.0, 1.0),
                                                        child: child,
                                                      );
                                                    },
                                                  ).call,
                                                  onRefresh: () =>
                                                      Future.delayed(
                                                          Duration(
                                                              milliseconds: 2),
                                                          () async {
                                                    await dashboardController
                                                        .updateviewschedular();
                                                  }),
                                                  child: pendingItems.isEmpty
                                                      ? CustomText(
                                                          data:
                                                              "Data not found")
                                                      : ListView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          itemCount:
                                                              pendingItems
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            int reverseIndex =
                                                                pendingItems
                                                                        .length -
                                                                    1 -
                                                                    index;
                                                            String apiDate =
                                                                "${pendingItems[index].createDate}"; // Replace this with the date from your API
                                                            DateTime
                                                                dateString =
                                                                DateTime.parse(
                                                                    apiDate);

                                                            String
                                                                formattedDate =
                                                                DateFormat(
                                                                        "dd/MM/yyyy")
                                                                    .format(
                                                                        dateString);
                                                            String
                                                                formattedTime =
                                                                DateFormat(
                                                                        "HH:mm a")
                                                                    .format(
                                                                        dateString);
                                                            return Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15.w,
                                                                      vertical:
                                                                          5.h),
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15.w,
                                                                      vertical:
                                                                          8.h),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.r),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              4),
                                                                      color: Colors
                                                                          .indigo
                                                                          .shade100,
                                                                      blurRadius:
                                                                          5.r),
                                                                  BoxShadow(
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              -1),
                                                                      color: Colors
                                                                          .indigo
                                                                          .shade100,
                                                                      blurRadius:
                                                                          3.r),
                                                                ],
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            CustomText(
                                                                          data:
                                                                              "Desc :",
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              16.sp,
                                                                        ),
                                                                      ),
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            const Icon(Icons.date_range),
                                                                            Container(
                                                                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(10.r),
                                                                              ),
                                                                              child: CustomText(
                                                                                data: pendingItems[index].createDate == null ? "" : DateFormat('dd MMMM yyyy').format(DateTime.parse(pendingItems[index].createDate.toString())),
                                                                                fontSize: 16.sp,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Divider(),
                                                                      Container(
                                                                        //padding: EdgeInsets.symmetric( vertical: 5.h),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              CustomText(
                                                                            data: pendingItems[index].description == null
                                                                                ? "Job remaining"
                                                                                : pendingItems[index].description.toString(),
                                                                            fontSize:
                                                                                16.sp,
                                                                            //fontWeight: FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Divider(),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      CustomText(
                                                                        data:
                                                                            "Status:",
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          //    Show dialog for check in options
                                                                          await showAdaptiveDialog<
                                                                              bool>(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
                                                                              return AlertDialog.adaptive(
                                                                                content: Text(
                                                                                  'Update Status',
                                                                                  style: TextStyle(
                                                                                    fontSize: 16.sp,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                                actions: [
                                                                                  Container(
                                                                                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                                                                                      // alignment: Alignment.center,
                                                                                      decoration: BoxDecoration(
                                                                                          // color: Colors.grey.shade200,
                                                                                          // borderRadius: BorderRadius.circular(50.r),
                                                                                          ),
                                                                                      child: Align(
                                                                                          alignment: Alignment.centerLeft,
                                                                                          child: Text(
                                                                                            "Status",
                                                                                            style: TextStyle(
                                                                                              fontSize: 16.sp,
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                          ))),
                                                                                  SizedBox(
                                                                                    height: 10.h,
                                                                                  ),
                                                                                  Container(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                                                                                    alignment: Alignment.center,
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.grey.shade200,
                                                                                      borderRadius: BorderRadius.circular(50.r),
                                                                                    ),
                                                                                    child: Obx(
                                                                                      () => DropdownButtonFormField<String>(
                                                                                        value: controller.ScheduleUpdateStatus.value.isEmpty ? null : controller.ScheduleUpdateStatus.value,
                                                                                        onChanged: (String? newValue) {
                                                                                          if (newValue != null) {
                                                                                            controller.ScheduleUpdateStatus.value = newValue; // Update the RxString value
                                                                                          }
                                                                                        },
                                                                                        decoration: const InputDecoration(
                                                                                          hintText: "",
                                                                                          border: InputBorder.none,
                                                                                        ),
                                                                                        hint: Text(
                                                                                          "Status",
                                                                                          style: GoogleFonts.roboto(color: Colors.grey),
                                                                                        ),
                                                                                        items: [
                                                                                          "Completed"
                                                                                        ]
                                                                                            .map((leaveType) => DropdownMenuItem<String>(
                                                                                                  value: leaveType,
                                                                                                  child: Text(leaveType),
                                                                                                ))
                                                                                            .toList(),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  TextButton(
                                                                                    onPressed: () async {
                                                                                      updateSchedulerStatus(
                                                                                        dashboardController.viewSchedularList.value.data![index].schedulerId.toString(),
                                                                                        controller.ScheduleUpdateStatus.value.toString(),
                                                                                      );
                                                                                      Get.back();
                                                                                    },
                                                                                    child: const Text('Submit'),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                        child:
                                                                            CustomText(
                                                                          data: pendingItems[index].status ??
                                                                              "",
                                                                          fontSize:
                                                                              16.sp,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color: pendingItems[index].status == "Pending"
                                                                              ? Colors.red
                                                                              : pendingItems[index].status == "Completed"
                                                                                  ? Colors.green
                                                                                  : Colors.black,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Divider(),
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      CustomText(
                                                                        data:
                                                                            "Create By : ",
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      CustomText(
                                                                        data: pendingItems[index].namee ==
                                                                                null
                                                                            ? ""
                                                                            : pendingItems[index].namee.toString(),
                                                                        fontSize:
                                                                            16.sp,
                                                                        //fontWeight: FontWeight.w500,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                ),
                                              ),
                                            ],
                                          );

                                        case Status.Error:
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      dashboardController
                                                          .updateviewschedular();
                                                    },
                                                    child: CustomText(
                                                        data: "Retry"))
                                              ],
                                            ),
                                          );
                                      }
                                    },
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Obx(
                                    () {
                                      switch (
                                          controller.rxRequestStatus.value) {
                                        case Status.Loading:
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        case Status.Complete:
                                          // Filter the list to include only items with jobStatus "Completed"
                                          var completedItems =
                                              dashboardController
                                                      .viewSchedularList
                                                      .value
                                                      .data
                                                      ?.where((item) =>
                                                          item.status ==
                                                          "Completed")
                                                      .toList() ??
                                                  [];

                                          return Column(
                                            children: [
                                              Container(
                                                height: 60.h,
                                                width: Get.width,
                                                padding: EdgeInsets.all(10.r),
                                                decoration: BoxDecoration(
                                                    // border: Border.all(width: 0.5.w),
                                                    color: Colors.white),
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        showSearch(
                                                          context: context,
                                                          delegate: SearchPage<
                                                                  Data>(
                                                              items:
                                                                  completedItems ??
                                                                      [],
                                                              searchLabel:
                                                                  'Enquiry',
                                                              suggestion:
                                                                  Center(
                                                                child:
                                                                    AutoSizeText(
                                                                  'Filter Schedular by any field',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        15.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                              failure: Center(
                                                                child:
                                                                    AutoSizeText(
                                                                  'Found Nothing :(',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        15.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                              filter:
                                                                  (person) => [
                                                                        person
                                                                            .description,
                                                                        person
                                                                            .createBy,
                                                                        person
                                                                            .date,
                                                                        DateFormat('dd MMMM yyyy').format(DateTime.parse(person
                                                                            .createDate
                                                                            .toString())),
                                                                        person
                                                                            .status,
                                                                        person
                                                                            .namee
                                                                      ],
                                                              builder:
                                                                  (person) {
                                                                return Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          15.w,
                                                                      vertical:
                                                                          5.h),
                                                                  margin: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          15.w,
                                                                      vertical:
                                                                          8.h),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.r),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          offset: const Offset(
                                                                              0,
                                                                              4),
                                                                          color: Colors
                                                                              .indigo
                                                                              .shade100,
                                                                          blurRadius:
                                                                              5.r),
                                                                      BoxShadow(
                                                                          offset: const Offset(
                                                                              0,
                                                                              -1),
                                                                          color: Colors
                                                                              .indigo
                                                                              .shade100,
                                                                          blurRadius:
                                                                              3.r),
                                                                    ],
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                CustomText(
                                                                              data: "Desc :",
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                          ),
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.centerRight,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                const Icon(Icons.date_range),
                                                                                Container(
                                                                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(10.r),
                                                                                  ),
                                                                                  child: CustomText(
                                                                                    data: person.createDate == null ? "" : DateFormat('dd MMMM yyyy').format(DateTime.parse(person.createDate.toString())),
                                                                                    fontSize: 16.sp,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Divider(),
                                                                          Container(
                                                                            //padding: EdgeInsets.symmetric( vertical: 5.h),
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: CustomText(
                                                                                data: person.description == null ? "Job remaining" : person.description.toString(),
                                                                                fontSize: 16.sp,
                                                                                //fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Divider(),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          CustomText(
                                                                            data:
                                                                                "Status:",
                                                                            fontSize:
                                                                                16.sp,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          CustomText(
                                                                            data:
                                                                                person.status ?? "",
                                                                            fontSize:
                                                                                16.sp,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: person.status == "Pending"
                                                                                ? Colors.red
                                                                                : person.status == "Completed"
                                                                                    ? Colors.green
                                                                                    : Colors.black,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Divider(),
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          CustomText(
                                                                            data:
                                                                                "Create By : ",
                                                                            fontSize:
                                                                                16.sp,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          CustomText(
                                                                            data: person.namee == null
                                                                                ? ""
                                                                                : person.namee.toString(),
                                                                            fontSize:
                                                                                16.sp,
                                                                            //fontWeight: FontWeight.w500,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }),
                                                        );
                                                      },
                                                      child: Container(
                                                        // width: Get.width,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .grey.shade100,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                          // border: Border.all(
                                                          //   color: Colors.black,
                                                          // ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height: 50.h,
                                                              width: 50.w,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right: 135
                                                                          .w),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: CustomColor
                                                                    .blueColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10.r),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                    10.r,
                                                                  ),
                                                                ),
                                                              ),
                                                              child: Icon(
                                                                Icons.search,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            CustomText(
                                                              data: "Search",
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            SizedBox(
                                                              width: 135.w,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Get.bottomSheet(
                                                            Container(
                                                          height: 320.h,
                                                          width: Get.width,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .white),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                height: 50.h,
                                                                width:
                                                                    Get.width,
                                                                color: CustomColor
                                                                    .blueColor,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        left: 20
                                                                            .w,
                                                                      ),
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Get.back();
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          CupertinoIcons
                                                                              .multiply,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    CustomText(
                                                                      data:
                                                                          "Filters",
                                                                      fontSize:
                                                                          20.sp,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          60.w,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            20.w),
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          20.h,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        RichText(
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                "Date from",
                                                                            style:
                                                                                GoogleFonts.roboto(fontSize: 18.sp, color: Colors.black),
                                                                            children: [
                                                                              TextSpan(
                                                                                text: "*",
                                                                                style: GoogleFonts.roboto(fontSize: 20.sp, color: Colors.red),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Obx(() {
                                                                      return Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                20.w,
                                                                            right: 20.w,
                                                                            top: 10.h),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Column(
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 50.h,
                                                                                  width: 400.w,
                                                                                  child: InkWell(
                                                                                    onTap: () => dashboardController.selectFromDate(context),
                                                                                    child: dashboardController.formattedFromDate.value == ""
                                                                                        ? Container(
                                                                                            alignment: Alignment.centerLeft,
                                                                                            height: 50.h,
                                                                                            width: 400,
                                                                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)),
                                                                                            child: CustomText(
                                                                                              data: '   Select From Date',
                                                                                            ),
                                                                                          )
                                                                                        : Container(
                                                                                            height: 50.h,
                                                                                            width: 400,
                                                                                            alignment: Alignment.centerLeft,
                                                                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)),
                                                                                            child: CustomText(
                                                                                              data: '  ${dashboardController.formattedFromDate.value}',
                                                                                              // Display the formatted date

                                                                                              fontSize: 14,
                                                                                            ),
                                                                                          ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }),
                                                                    SizedBox(
                                                                      height:
                                                                          10.h,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        RichText(
                                                                            text: TextSpan(
                                                                                text: "Date to",
                                                                                style: GoogleFonts.roboto(fontSize: 18.sp, color: Colors.black),
                                                                                children: [
                                                                              TextSpan(
                                                                                text: "*",
                                                                                style: GoogleFonts.roboto(fontSize: 20.sp, color: Colors.red),
                                                                              )
                                                                            ])),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10.h,
                                                                    ),
                                                                    Obx(() {
                                                                      return Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          left:
                                                                              20.w,
                                                                          right:
                                                                              20.w,
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 50.h,
                                                                              width: 400.w,
                                                                              child: InkWell(
                                                                                onTap: () => dashboardController.selectToDate(context),
                                                                                child: dashboardController.formattedToDate.value == ""
                                                                                    ? Container(alignment: Alignment.centerLeft, height: 50.h, width: 400, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)), child: CustomText(data: '   Select To Date'))
                                                                                    : Container(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        height: 50.h,
                                                                                        width: 400,
                                                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)),
                                                                                        child: CustomText(
                                                                                          data: '  ${dashboardController.formattedToDate.value}',
                                                                                          // Display the formatted date

                                                                                          fontSize: 14.sp,
                                                                                        ),
                                                                                      ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 15.h,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }),
                                                                    SizedBox(
                                                                      height:
                                                                          10.h,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (dashboardController.formattedFromDate.value !=
                                                                                "" &&
                                                                            dashboardController.formattedToDate.value !=
                                                                                "") {
                                                                          dashboardController
                                                                              .datefilterschedular();
                                                                          Get.back();
                                                                        } else {
                                                                          ShortMessage.toast(
                                                                              title: "Please select date");
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            50.h,
                                                                        width: Get
                                                                            .width,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        decoration:
                                                                            BoxDecoration(color: CustomColor.blueColor),
                                                                        child:
                                                                            CustomText(
                                                                          data:
                                                                              "Apply Filter",
                                                                          fontSize:
                                                                              18.sp,
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ));
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 6.w),
                                                        height: 50.h,
                                                        width: 50.w,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.r),
                                                            border: Border.all(
                                                                width: 0.5.w)),
                                                        child: Icon(
                                                          Icons.calendar_month,
                                                          size: 40.r,
                                                          color: CustomColor
                                                              .blueColor,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.5,
                                                child: CustomRefreshIndicator(
                                                  leadingScrollIndicatorVisible:
                                                      true,
                                                  trailingScrollIndicatorVisible:
                                                      true,
                                                  builder:
                                                      MaterialIndicatorDelegate(
                                                    builder:
                                                        (context, controller) {
                                                      return Icon(
                                                        Icons.refresh,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        size: 30,
                                                      );
                                                    },
                                                    scrollableBuilder: (context,
                                                        child, controller) {
                                                      return Opacity(
                                                        opacity: 1.0 -
                                                            controller.value
                                                                .clamp(
                                                                    0.0, 1.0),
                                                        child: child,
                                                      );
                                                    },
                                                  ).call,
                                                  onRefresh: () =>
                                                      Future.delayed(
                                                          Duration(
                                                              milliseconds: 2),
                                                          () async {
                                                    await dashboardController
                                                        .updateviewschedular();
                                                  }),
                                                  child: completedItems.isEmpty
                                                      ? CustomText(
                                                          data:
                                                              "Data not found")
                                                      : ListView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          itemCount:
                                                              completedItems
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            int reverseIndex =
                                                                dashboardController
                                                                        .viewSchedularList
                                                                        .value
                                                                        .data!
                                                                        .length -
                                                                    1 -
                                                                    index;
                                                            String apiDate =
                                                                "${completedItems[index].createDate}"; // Replace this with the date from your API
                                                            DateTime
                                                                dateString =
                                                                DateTime.parse(
                                                                    apiDate);

                                                            String
                                                                formattedDate =
                                                                DateFormat(
                                                                        "dd/MM/yyyy")
                                                                    .format(
                                                                        dateString);
                                                            String
                                                                formattedTime =
                                                                DateFormat(
                                                                        "HH:mm a")
                                                                    .format(
                                                                        dateString);
                                                            return Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15.w,
                                                                      vertical:
                                                                          5.h),
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15.w,
                                                                      vertical:
                                                                          8.h),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.r),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              4),
                                                                      color: Colors
                                                                          .indigo
                                                                          .shade100,
                                                                      blurRadius:
                                                                          5.r),
                                                                  BoxShadow(
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              -1),
                                                                      color: Colors
                                                                          .indigo
                                                                          .shade100,
                                                                      blurRadius:
                                                                          3.r),
                                                                ],
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            CustomText(
                                                                          data:
                                                                              "Desc :",
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              16.sp,
                                                                        ),
                                                                      ),
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            const Icon(Icons.date_range),
                                                                            Container(
                                                                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(10.r),
                                                                              ),
                                                                              child: CustomText(
                                                                                data: completedItems[index].createDate == null ? "" : DateFormat('dd MMMM yyyy').format(DateTime.parse(completedItems[index].createDate.toString())),
                                                                                fontSize: 16.sp,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Divider(),
                                                                      Container(
                                                                        //padding: EdgeInsets.symmetric( vertical: 5.h),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              CustomText(
                                                                            data: completedItems[index].description == null
                                                                                ? "Job remaining"
                                                                                : completedItems[index].description.toString(),
                                                                            fontSize:
                                                                                16.sp,
                                                                            //fontWeight: FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Divider(),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      CustomText(
                                                                        data:
                                                                            "Status:",
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      CustomText(
                                                                        data: completedItems[index].status ??
                                                                            "",
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: completedItems[index].status ==
                                                                                "Pending"
                                                                            ? Colors.red
                                                                            : completedItems[index].status == "Completed"
                                                                                ? Colors.green
                                                                                : Colors.black,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Divider(),
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      CustomText(
                                                                        data:
                                                                            "Create By : ",
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      CustomText(
                                                                        data: completedItems[index].namee ==
                                                                                null
                                                                            ? ""
                                                                            : completedItems[index].namee.toString(),
                                                                        fontSize:
                                                                            16.sp,
                                                                        //fontWeight: FontWeight.w500,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                ),
                                              ),
                                            ],
                                          );

                                        case Status.Error:
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      dashboardController
                                                          .updateviewschedular();
                                                    },
                                                    child: CustomText(
                                                        data: "Retry"))
                                              ],
                                            ),
                                          );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Obx(() {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: CalendarCarousel<Event>(
                            todayBorderColor: Colors.green,
                            onDayPressed: (date, events) {
                              controller.currentDate2.value = date;
                              // Filter data by the selected date
                              String selectedDate =
                                  DateFormat('yyyy-MM-dd').format(date);
                              SchedularViewModel filteredViewModel =
                                  dashboardController.schedularViewModel.value
                                      .filterDataByDate(selectedDate);
                              // Show dialog with the filtered data
                              if (filteredViewModel.data != null &&
                                  filteredViewModel.data!.isNotEmpty) {
                                Get.defaultDialog(
                                  title:
                                      "Schedule for ${DateFormat('dd:MM:yyy').format(date)}",
                                  content: Column(
                                    children:
                                        filteredViewModel.data!.map((item) {
                                      return ListTile(
                                        title: Text(item.description ??
                                            'No Description'),
                                        subtitle: Text(
                                          'Status: ${item.status}',
                                          style: TextStyle(
                                              color: item.status == "Completed"
                                                  ? Colors.green
                                                  : Colors.red),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              } else {
                                Get.defaultDialog(
                                  title: "Schedule",
                                  middleText:
                                      "No scheduled tasks for this date.",
                                );
                              }
                            },
                            // other properties remain unchanged
                            daysHaveCircularBorder: true,
                            showOnlyCurrentMonthDate: true,
                            weekendTextStyle: const TextStyle(
                              color: Colors.red,
                            ),
                            thisMonthDayBorderColor: Colors.grey,
                            weekFormat: false,
                            markedDatesMap:
                                dashboardController.markedDateMap1.value,
                            height: 450.0.h,
                            selectedDateTime:
                                dashboardController.currentDate2.value,
                            targetDateTime:
                                dashboardController.targetDateTime.value,
                            customGridViewPhysics:
                                const NeverScrollableScrollPhysics(),
                            markedDateCustomShapeBorder: CircleBorder(
                                side: BorderSide(color: Colors.amber)),
                            markedDateCustomTextStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            showHeader: true,
                            todayTextStyle: const TextStyle(
                              color: Colors.black,
                            ),
                            markedDateShowIcon: true,
                            markedDateIconMaxShown: 2,
                            markedDateIconBuilder: (event) {
                              return event.icon;
                            },
                            markedDateMoreShowTotal: true,
                            todayButtonColor: Colors.yellow,
                            selectedDayTextStyle: const TextStyle(
                              color: Colors.yellow,
                            ),
                            minSelectedDate: dashboardController
                                .currentDate2.value
                                .subtract(const Duration(days: 360)),
                            maxSelectedDate: dashboardController
                                .currentDate2.value
                                .add(const Duration(days: 360)),
                            prevDaysTextStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.pinkAccent,
                            ),
                            inactiveDaysTextStyle: const TextStyle(
                              color: Colors.tealAccent,
                              fontSize: 16,
                            ),
                            onCalendarChanged: (DateTime date) {
                              dashboardController.targetDateTime.value = date;
                              dashboardController.currentMonth.value =
                                  DateFormat.yMMM().format(
                                      dashboardController.targetDateTime.value);
                            },
                            onDayLongPressed: (DateTime date) {
                              if (kDebugMode) {
                                print('long pressed date $date');
                              }
                            },
                          ),
                        );
                      }),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10.w,
                          right: 10.w,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              1000.r,
                                            ),
                                          ),
                                          border: Border.all(
                                            color:
                                                Colors.green.withOpacity(0.5),
                                            width: 25.0.w,
                                          )),
                                    ),
                                    CustomText(
                                      data: " : Schedule",
                                      color: Colors.black,
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.w400,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
