import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:search_page/search_page.dart';

import '../../controllers/leave/leave_screen_controller.dart';
import '../../infrastructure/image_constants/image_constants.dart';
import '../../infrastructure/routes/page_constants.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../sevices/models/Leave/leave_view_model.dart';
import '../../sevices/models/Scheduler/SchedulerModel.dart';
import '../../sevices/models/attendance/view_attendance_model.dart';
import '../../utilities/custom_color/custom_color.dart';
import 'package:http/http.dart' as http;
import '../../utilities/custom_text/custom_text.dart';
import '../../utilities/custom_toast/custom_toast.dart';

class LeaveViewScreen extends GetView<LeaveScreenController> {
  @override
  Widget build(BuildContext context) {
    Future<void> addLeave(
      leavefrom,
      leaveto,
      leaveapply,
      leavetype,
      alternatecontact,
      resumeduty,
      employeid,
      empid,
    ) async {
      const String url =
          'http://sarvaperp.eduagentapp.com/api/SarvapErp/AddEmpLeave';

      // Create the request body
      Map<dynamic, dynamic> body = {
        "LeaveFromDate": leavefrom.toString(),
        "LeaveToDate": leaveto.toString(),
        "LeaveApplyfor": leaveapply.toString(),
        "LeaveType": leavetype.toString(),
        "AlternateContactNo": alternatecontact.toString(),
        "ResumedutyDate": resumeduty.toString(),
        "EmployeeId": employeid.toString(),
        "CreateBy": empid.toString(),
      };

      try {
        // Make the HTTP POST request
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(body),
        );

        // Check the status code of the response
        if (response.statusCode == 200) {
          // Log success message and response body
          print('Leave Take successfully');
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Leave Take Successfully")));
          //print('Response body: ${response.body}');
        } else {
          // Print error message if the request was not successful
          print('Failed to TakeLeave. Status code: ${response.statusCode}');
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed to Submit")));
          //print('Response body: ${response.body}');
        }
      } catch (e) {
        // Handle any exceptions that occur during the request
        print('Error occurred while adding expense: $e');
      }
    }

    //fetch employee api...

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: CustomText(
              data: 'Leave',
              color: Colors.white,
              fontSize: 20.sp,
            ),
            elevation: 0,
            centerTitle: true,
            backgroundColor: CustomColor.blueColor,
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
                      data: "View Leave",
                      color: Colors.black,
                    )),
                    Tab(
                        child: CustomText(
                      data: "Take Leave",
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
                    length: 3,
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
                                      data: "Pending Leave",
                                      color: Colors.red,
                                    ),
                                  ),
                                  Tab(
                                      child: CustomText(
                                    data: "Completed Leave",
                                    color: Colors.green,
                                  )),
                                  Tab(
                                      child: CustomText(
                                    data: "Rejected Leave",
                                    color: Colors.redAccent,
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
                                      switch (
                                          controller.rxRequestStatus.value) {
                                        case Status.Loading:
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        case Status.Complete:
                                          var pendingitem = controller
                                                  .leaveviewlist.value.data
                                                  ?.where((element) =>
                                                      element.leaveStatus ==
                                                      "Pending")
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
                                                                  LeaveViewData>(
                                                              items:
                                                                  pendingitem,
                                                              searchLabel:
                                                                  'Search',
                                                              suggestion:
                                                                  Center(
                                                                child:
                                                                    AutoSizeText(
                                                                  "Filter by  \n Leave Apply For \n Leave Type \n Leave From Date \n Leave To Date ",
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
                                                                            .leaveApplyfor,
                                                                        person
                                                                            .leaveType,
                                                                        DateFormat("dd/MM/yyyy").format(DateTime.parse(person
                                                                            .leaveFromDate
                                                                            .toString())),
                                                                        DateFormat("dd/MM/yyyy").format(DateTime.parse(person
                                                                            .leaveToDate
                                                                            .toString())),
                                                                      ],
                                                              builder:
                                                                  (person) {
                                                                return Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10.w,
                                                                      vertical:
                                                                          10.h),
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                    horizontal:
                                                                        10.w,
                                                                    vertical:
                                                                        15.h,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.r),
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        offset: Offset(
                                                                            2,
                                                                            6),
                                                                        blurRadius:
                                                                            8.r,
                                                                        color: Colors
                                                                            .blue
                                                                            .shade900,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(5.h),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            CustomText(
                                                                              data: person.leaveType.toString(),
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            CustomText(
                                                                              data: person.leaveStatus.toString(),
                                                                              fontSize: 15.sp,
                                                                              color: Colors.red,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Divider(),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(5.h),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            CustomText(
                                                                              data: "Leave from :",
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10.w,
                                                                            ),
                                                                            Icon(CupertinoIcons.calendar),
                                                                            SizedBox(width: 3.w),
                                                                            CustomText(
                                                                              data: DateFormat("dd/MM/yyyy").format(DateTime.parse(person.leaveFromDate.toString())),
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 15.w,
                                                                            ),
                                                                            Icon(CupertinoIcons.calendar),
                                                                            SizedBox(width: 3.w),
                                                                            CustomText(
                                                                              data: "to:",
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 15.w,
                                                                            ),
                                                                            CustomText(
                                                                              data: DateFormat("dd/MM/yyyy").format(DateTime.parse(person.leaveToDate.toString())),
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Divider(),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(5.h),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            CustomText(
                                                                              data: "Resume on :",
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            CustomText(
                                                                              data: DateFormat("dd/MM/yyyy").format(DateTime.parse(person.resumedutyDate.toString())),
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Divider(),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(5.h),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            CustomText(
                                                                              data: "Leave apply for  :",
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            CustomText(
                                                                              data: person.leaveApplyfor.toString(),
                                                                              fontSize: 16.sp,
                                                                              color: Colors.green,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      /* Divider(),
                                                      InkWell(
                                                          onTap:
                                                              () {
                                                            var data = controller.leaveviewlist.value.data![index];
                                                            Get.toNamed(
                                                                AppRoutesName.leave_view_all,
                                                                arguments: [
                                                                  data.leaveFromDate,
                                                                  data.leaveToDate,
                                                                  data.leaveApplyfor,
                                                                  data.leaveType,
                                                                  data.alternateContactNo,
                                                                  data.resumedutyDate,
                                                                  data.namee,
                                                                  data.createBy
                                                                ]
                                                            );
                                                          },
                                                          child:
                                                          Align(
                                                            alignment:
                                                            Alignment.centerRight,
                                                            child:
                                                            Text(
                                                              "View More",
                                                              style:
                                                              TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 16.sp,
                                                              ),
                                                            ),
                                                          )),*/
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
                                                                                    onTap: () => controller.selectFromDate(context),
                                                                                    child: controller.formattedFromDate.value == ""
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
                                                                                              data: '  ${controller.formattedFromDate.value}',
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
                                                                                onTap: () => controller.selectToDate(context),
                                                                                child: controller.formattedToDate.value == ""
                                                                                    ? Container(alignment: Alignment.centerLeft, height: 50.h, width: 400, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)), child: CustomText(data: '   Select To Date'))
                                                                                    : Container(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        height: 50.h,
                                                                                        width: 400,
                                                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)),
                                                                                        child: CustomText(
                                                                                          data: '  ${controller.formattedToDate.value}',
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
                                                                        if (controller.formattedFromDate.value !=
                                                                                "" &&
                                                                            controller.formattedToDate.value !=
                                                                                "") {
                                                                          controller
                                                                              .datefilterLeaveApi();
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
                                                                        40.r),
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
                                              SingleChildScrollView(
                                                child: SizedBox(
                                                  height: 580.h,
                                                  child: CustomRefreshIndicator(
                                                    leadingScrollIndicatorVisible:
                                                        false,
                                                    trailingScrollIndicatorVisible:
                                                        false,
                                                    builder:
                                                        MaterialIndicatorDelegate(
                                                      builder: (context,
                                                          controller) {
                                                        return Icon(
                                                          Icons.refresh,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          size: 20,
                                                        );
                                                      },
                                                      scrollableBuilder:
                                                          (context, child,
                                                              controller) {
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
                                                            const Duration(
                                                                milliseconds:
                                                                    2),
                                                            () async {
                                                      await controller
                                                          .leaveApi();
                                                    }),
                                                    child: Column(
                                                      children: [
                                                        Obx(
                                                          () {
                                                            switch (controller
                                                                .rxRequestStatus
                                                                .value) {
                                                              case Status
                                                                    .Loading:
                                                                return Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                );
                                                              case Status
                                                                    .Complete:
                                                                return Expanded(
                                                                  child:
                                                                      CustomRefreshIndicator(
                                                                    leadingScrollIndicatorVisible:
                                                                        true,
                                                                    trailingScrollIndicatorVisible:
                                                                        true,
                                                                    builder:
                                                                        MaterialIndicatorDelegate(
                                                                      builder:
                                                                          (context,
                                                                              controller) {
                                                                        return Icon(
                                                                          Icons
                                                                              .refresh,
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .primary,
                                                                          size:
                                                                              30,
                                                                        );
                                                                      },
                                                                      scrollableBuilder: (context,
                                                                          child,
                                                                          controller) {
                                                                        return Opacity(
                                                                          opacity:
                                                                              1.0 - controller.value.clamp(0.0, 1.0),
                                                                          child:
                                                                              child,
                                                                        );
                                                                      },
                                                                    ),
                                                                    onRefresh: () => Future.delayed(
                                                                        Duration(
                                                                            milliseconds:
                                                                                2),
                                                                        () async {
                                                                      await controller
                                                                          .updateDataListApi();
                                                                    }),
                                                                    child: pendingitem ==
                                                                            null
                                                                        ? CustomText(
                                                                            data:
                                                                                "Data not found")
                                                                        : ListView
                                                                            .builder(
                                                                            padding:
                                                                                EdgeInsets.zero,
                                                                            itemCount:
                                                                                pendingitem.length,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              return Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                                                                margin: EdgeInsets.symmetric(
                                                                                  horizontal: 10.w,
                                                                                  vertical: 15.h,
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(20.r),
                                                                                  color: Colors.white,
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      offset: Offset(2, 6),
                                                                                      blurRadius: 8.r,
                                                                                      color: Colors.blue.shade900,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsets.all(5.h),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          CustomText(
                                                                                            data: pendingitem[index].leaveType.toString(),
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                          CustomText(
                                                                                            data: pendingitem[index].leaveStatus.toString(),
                                                                                            fontSize: 16.sp,
                                                                                            color: Colors.red,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Divider(),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.all(5.h),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          CustomText(
                                                                                            data: "Leave from :",
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 10.w,
                                                                                          ),
                                                                                          Icon(
                                                                                            CupertinoIcons.calendar,
                                                                                            size: 15,
                                                                                          ),
                                                                                          // SizedBox(width :3.w),
                                                                                          CustomText(
                                                                                            data: DateFormat("dd/MM/yyyy").format(DateTime.parse(pendingitem[index].leaveFromDate.toString())),
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 15.w,
                                                                                          ),
                                                                                          Icon(
                                                                                            CupertinoIcons.calendar,
                                                                                            size: 15,
                                                                                          ),
                                                                                          //SizedBox(width :3.w),
                                                                                          CustomText(
                                                                                            data: "to:",
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 15.w,
                                                                                          ),
                                                                                          CustomText(
                                                                                            data: DateFormat("dd/MM/yyyy").format(DateTime.parse(pendingitem[index].leaveToDate.toString())),
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Divider(),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.all(5.h),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          CustomText(
                                                                                            data: "Resume on :",
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                          CustomText(
                                                                                            data: DateFormat("dd/MM/yyyy").format(DateTime.parse(pendingitem[index].resumedutyDate.toString())),
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Divider(),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.all(5.h),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          CustomText(
                                                                                            data: "Leave apply for :",
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                          CustomText(
                                                                                            data: pendingitem[index].leaveApplyfor.toString(),
                                                                                            fontSize: 16.sp,
                                                                                            color: Colors.green,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Divider(),
                                                                                    InkWell(
                                                                                        onTap: () {
                                                                                          var data = pendingitem[index];
                                                                                          Get.toNamed(AppRoutesName.leave_view_all, arguments: [
                                                                                            data.leaveFromDate,
                                                                                            data.leaveToDate,
                                                                                            data.leaveApplyfor,
                                                                                            data.leaveType,
                                                                                            data.alternateContactNo,
                                                                                            data.resumedutyDate,
                                                                                            data.namee,
                                                                                            data.createBy
                                                                                          ]);
                                                                                        },
                                                                                        child: Align(
                                                                                          alignment: Alignment.centerRight,
                                                                                          child: Text(
                                                                                            "View More",
                                                                                            style: TextStyle(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              fontSize: 16.sp,
                                                                                            ),
                                                                                          ),
                                                                                        )),
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
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            controller.updateDataListApi();
                                                                          },
                                                                          child:
                                                                              CustomText(data: "Retry"))
                                                                    ],
                                                                  ),
                                                                );
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
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
                                                      controller
                                                          .updateDataListApi();
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
                                          var completeditems = controller
                                                  .leaveviewlist.value.data
                                                  ?.where((element) =>
                                                      element.leaveStatus ==
                                                      "Accepted")
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
                                                                  LeaveViewData>(
                                                              items:
                                                                  completeditems,
                                                              searchLabel:
                                                                  'Search',
                                                              suggestion:
                                                                  Center(
                                                                child:
                                                                    AutoSizeText(
                                                                  "Filter by  \n Leave Apply For \n Leave Type \n Leave From Date \n Leave To Date ",
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
                                                                            .leaveApplyfor,
                                                                        person
                                                                            .leaveType,
                                                                        DateFormat("dd/MM/yyyy").format(DateTime.parse(person
                                                                            .leaveFromDate
                                                                            .toString())),
                                                                        DateFormat("dd/MM/yyyy").format(DateTime.parse(person
                                                                            .leaveToDate
                                                                            .toString())),
                                                                      ],
                                                              builder:
                                                                  (person) {
                                                                return Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10.w,
                                                                      vertical:
                                                                          10.h),
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                    horizontal:
                                                                        10.w,
                                                                    vertical:
                                                                        15.h,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.r),
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        offset: Offset(
                                                                            2,
                                                                            6),
                                                                        blurRadius:
                                                                            8.r,
                                                                        color: Colors
                                                                            .blue
                                                                            .shade900,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(5.h),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            CustomText(
                                                                              data: person.leaveType.toString(),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            CustomText(
                                                                                data: person.leaveStatus.toString(),
                                                                                fontSize: 16.sp,
                                                                                color: Colors.green),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Divider(),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(5.h),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            CustomText(
                                                                              data: "Leave from :",
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10.w,
                                                                            ),
                                                                            Icon(
                                                                              CupertinoIcons.calendar,
                                                                              size: 15,
                                                                            ),
                                                                            //SizedBox(width :3.w),
                                                                            CustomText(
                                                                              data: DateFormat("dd/MM/yyyy").format(DateTime.parse(person.leaveFromDate.toString())),
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 15.w,
                                                                            ),
                                                                            Icon(
                                                                              CupertinoIcons.calendar,
                                                                              size: 15,
                                                                            ),
                                                                            //SizedBox(width :3.w),
                                                                            CustomText(
                                                                              data: "to:",
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 15.w,
                                                                            ),
                                                                            CustomText(
                                                                              data: DateFormat("dd/MM/yyyy").format(DateTime.parse(person.leaveToDate.toString())),
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Divider(),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(5.h),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            CustomText(
                                                                              data: "Resume on :",
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            CustomText(
                                                                              data: DateFormat("dd/MM/yyyy").format(DateTime.parse(person.resumedutyDate.toString())),
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Divider(),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(5.h),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            CustomText(
                                                                              data: "Leave apply for  :",
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            CustomText(
                                                                              data: person.leaveApplyfor.toString(),
                                                                              fontSize: 16.sp,
                                                                              color: Colors.green,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      /* Divider(),
                                                      InkWell(
                                                          onTap:
                                                              () {
                                                            var data = controller.leaveviewlist.value.data![index];
                                                            Get.toNamed(
                                                                AppRoutesName.leave_view_all,
                                                                arguments: [
                                                                  data.leaveFromDate,
                                                                  data.leaveToDate,
                                                                  data.leaveApplyfor,
                                                                  data.leaveType,
                                                                  data.alternateContactNo,
                                                                  data.resumedutyDate,
                                                                  data.namee,
                                                                  data.createBy
                                                                ]
                                                            );
                                                          },
                                                          child:
                                                          Align(
                                                            alignment:
                                                            Alignment.centerRight,
                                                            child:
                                                            Text(
                                                              "View More",
                                                              style:
                                                              TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 16.sp,
                                                              ),
                                                            ),
                                                          )),*/
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
                                                                                    onTap: () => controller.selectFromDate(context),
                                                                                    child: controller.formattedFromDate.value == ""
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
                                                                                              data: '  ${controller.formattedFromDate.value}',
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
                                                                                onTap: () => controller.selectToDate(context),
                                                                                child: controller.formattedToDate.value == ""
                                                                                    ? Container(alignment: Alignment.centerLeft, height: 50.h, width: 400, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)), child: CustomText(data: '   Select To Date'))
                                                                                    : Container(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        height: 50.h,
                                                                                        width: 400,
                                                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)),
                                                                                        child: CustomText(
                                                                                          data: '  ${controller.formattedToDate.value}',
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
                                                                        if (controller.formattedFromDate.value !=
                                                                                "" &&
                                                                            controller.formattedToDate.value !=
                                                                                "") {
                                                                          controller
                                                                              .datefilterLeaveApi();
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
                                                                        40.r),
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
                                              SingleChildScrollView(
                                                child: SizedBox(
                                                  height: 580.h,
                                                  child: CustomRefreshIndicator(
                                                    leadingScrollIndicatorVisible:
                                                        false,
                                                    trailingScrollIndicatorVisible:
                                                        false,
                                                    builder:
                                                        MaterialIndicatorDelegate(
                                                      builder: (context,
                                                          controller) {
                                                        return Icon(
                                                          Icons.refresh,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          size: 20,
                                                        );
                                                      },
                                                      scrollableBuilder:
                                                          (context, child,
                                                              controller) {
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
                                                            const Duration(
                                                                milliseconds:
                                                                    2),
                                                            () async {
                                                      await controller
                                                          .leaveApi();
                                                    }),
                                                    child: Column(
                                                      children: [
                                                        Obx(
                                                          () {
                                                            switch (controller
                                                                .rxRequestStatus
                                                                .value) {
                                                              case Status
                                                                    .Loading:
                                                                return Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                );
                                                              case Status
                                                                    .Complete:
                                                                return Expanded(
                                                                  child:
                                                                      CustomRefreshIndicator(
                                                                    leadingScrollIndicatorVisible:
                                                                        true,
                                                                    trailingScrollIndicatorVisible:
                                                                        true,
                                                                    builder:
                                                                        MaterialIndicatorDelegate(
                                                                      builder:
                                                                          (context,
                                                                              controller) {
                                                                        return Icon(
                                                                          Icons
                                                                              .refresh,
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .primary,
                                                                          size:
                                                                              30,
                                                                        );
                                                                      },
                                                                      scrollableBuilder: (context,
                                                                          child,
                                                                          controller) {
                                                                        return Opacity(
                                                                          opacity:
                                                                              1.0 - controller.value.clamp(0.0, 1.0),
                                                                          child:
                                                                              child,
                                                                        );
                                                                      },
                                                                    ),
                                                                    onRefresh: () => Future.delayed(
                                                                        Duration(
                                                                            milliseconds:
                                                                                2),
                                                                        () async {
                                                                      await controller
                                                                          .updateDataListApi();
                                                                    }),
                                                                    child: completeditems.length ==
                                                                            null
                                                                        ? CustomText(
                                                                            data:
                                                                                "Data not found")
                                                                        : ListView
                                                                            .builder(
                                                                            padding:
                                                                                EdgeInsets.zero,
                                                                            itemCount:
                                                                                completeditems.length,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              return Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                                                                margin: EdgeInsets.symmetric(
                                                                                  horizontal: 10.w,
                                                                                  vertical: 15.h,
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(20.r),
                                                                                  color: Colors.white,
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      offset: Offset(2, 6),
                                                                                      blurRadius: 8.r,
                                                                                      color: Colors.blue.shade900,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsets.all(5.h),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          CustomText(
                                                                                            data: completeditems[index].leaveType.toString(),
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                          CustomText(data: completeditems[index].leaveStatus.toString(), fontSize: 16.sp, color: Colors.green),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Divider(),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.all(5.h),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          CustomText(
                                                                                            data: "Leave from :",
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 10.w,
                                                                                          ),
                                                                                          Icon(
                                                                                            CupertinoIcons.calendar,
                                                                                            size: 15,
                                                                                          ),
                                                                                          //SizedBox(width :3.w),
                                                                                          CustomText(
                                                                                            data: DateFormat("dd/MM/yyyy").format(DateTime.parse(completeditems[index].leaveFromDate.toString())),
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 15.w,
                                                                                          ),
                                                                                          CustomText(
                                                                                            data: "to:",
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 15.w,
                                                                                          ),
                                                                                          Icon(
                                                                                            CupertinoIcons.calendar,
                                                                                            size: 15,
                                                                                          ),
                                                                                          // SizedBox(width :3.w),
                                                                                          CustomText(
                                                                                            data: DateFormat("dd/MM/yyyy").format(DateTime.parse(completeditems[index].leaveToDate.toString())),
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Divider(),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.all(5.h),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          CustomText(
                                                                                            data: "Resume on :",
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                          CustomText(
                                                                                            data: DateFormat("dd/MM/yyyy").format(DateTime.parse(completeditems[index].resumedutyDate.toString())),
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Divider(),
                                                                                    InkWell(
                                                                                        onTap: () {
                                                                                          var data = completeditems[index];
                                                                                          Get.toNamed(AppRoutesName.leave_view_all, arguments: [
                                                                                            data.leaveFromDate,
                                                                                            data.leaveToDate,
                                                                                            data.leaveApplyfor,
                                                                                            data.leaveType,
                                                                                            data.alternateContactNo,
                                                                                            data.resumedutyDate,
                                                                                            data.namee,
                                                                                            data.createBy
                                                                                          ]);
                                                                                        },
                                                                                        child: Align(
                                                                                          alignment: Alignment.centerRight,
                                                                                          child: Text(
                                                                                            "View More",
                                                                                            style: TextStyle(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              fontSize: 16.sp,
                                                                                            ),
                                                                                          ),
                                                                                        )),
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
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            controller.updateDataListApi();
                                                                          },
                                                                          child:
                                                                              CustomText(data: "Retry"))
                                                                    ],
                                                                  ),
                                                                );
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
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
                                                      controller
                                                          .updateDataListApi();
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
                                          var rejecteditems = controller
                                                  .leaveviewlist.value.data
                                                  ?.where((element) =>
                                                      element.leaveStatus ==
                                                      "Rejected")
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
                                                                  LeaveViewData>(
                                                              items:
                                                                  rejecteditems,
                                                              searchLabel:
                                                                  'Search',
                                                              suggestion:
                                                                  Center(
                                                                child:
                                                                    AutoSizeText(
                                                                  "Filter by  \n Leave Apply For \n Leave Type \n Leave From Date \n Leave To Date ",
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
                                                                            .leaveApplyfor,
                                                                        person
                                                                            .leaveType,
                                                                        DateFormat("dd/MM/yyyy").format(DateTime.parse(person
                                                                            .leaveFromDate
                                                                            .toString())),
                                                                        DateFormat("dd/MM/yyyy").format(DateTime.parse(person
                                                                            .leaveToDate
                                                                            .toString())),
                                                                      ],
                                                              builder:
                                                                  (person) {
                                                                return Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10.w,
                                                                      vertical:
                                                                          10.h),
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                    horizontal:
                                                                        10.w,
                                                                    vertical:
                                                                        15.h,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.r),
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        offset: Offset(
                                                                            2,
                                                                            6),
                                                                        blurRadius:
                                                                            8.r,
                                                                        color: Colors
                                                                            .blue
                                                                            .shade900,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(5.h),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            CustomText(
                                                                              data: person.leaveType.toString(),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            CustomText(
                                                                              data: person.leaveStatus.toString(),
                                                                              fontSize: 16.sp,
                                                                              color: Colors.red,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Divider(),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(5.h),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            CustomText(
                                                                              data: "Leave from :",
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10.w,
                                                                            ),
                                                                            Icon(
                                                                              CupertinoIcons.calendar,
                                                                              size: 15,
                                                                            ),
                                                                            //SizedBox(width :3.w),
                                                                            CustomText(
                                                                              data: DateFormat("dd/MM/yyyy").format(DateTime.parse(person.leaveFromDate.toString())),
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 15.w,
                                                                            ),
                                                                            CustomText(
                                                                              data: "to:",
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 15.w,
                                                                            ),
                                                                            Icon(
                                                                              CupertinoIcons.calendar,
                                                                              size: 15,
                                                                            ),
                                                                            //SizedBox(width :3.w),
                                                                            CustomText(
                                                                              data: DateFormat("dd/MM/yyyy").format(DateTime.parse(person.leaveToDate.toString())),
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Divider(),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(5.h),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            CustomText(
                                                                              data: "Resume on :",
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            CustomText(
                                                                              data: DateFormat("dd/MM/yyyy").format(DateTime.parse(person.resumedutyDate.toString())),
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Divider(),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(5.h),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            CustomText(
                                                                              data: "Leave apply for  :",
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                            CustomText(
                                                                              data: person.leaveApplyfor.toString(),
                                                                              fontSize: 16.sp,
                                                                              color: Colors.green,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      /* Divider(),
                                                      InkWell(
                                                          onTap:
                                                              () {
                                                            var data = controller.leaveviewlist.value.data![index];
                                                            Get.toNamed(
                                                                AppRoutesName.leave_view_all,
                                                                arguments: [
                                                                  data.leaveFromDate,
                                                                  data.leaveToDate,
                                                                  data.leaveApplyfor,
                                                                  data.leaveType,
                                                                  data.alternateContactNo,
                                                                  data.resumedutyDate,
                                                                  data.namee,
                                                                  data.createBy
                                                                ]
                                                            );
                                                          },
                                                          child:
                                                          Align(
                                                            alignment:
                                                            Alignment.centerRight,
                                                            child:
                                                            Text(
                                                              "View More",
                                                              style:
                                                              TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 16.sp,
                                                              ),
                                                            ),
                                                          )),*/
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
                                                                                    onTap: () => controller.selectFromDate(context),
                                                                                    child: controller.formattedFromDate.value == ""
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
                                                                                              data: '  ${controller.formattedFromDate.value}',
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
                                                                                onTap: () => controller.selectToDate(context),
                                                                                child: controller.formattedToDate.value == ""
                                                                                    ? Container(alignment: Alignment.centerLeft, height: 50.h, width: 400, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)), child: CustomText(data: '   Select To Date'))
                                                                                    : Container(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        height: 50.h,
                                                                                        width: 400,
                                                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)),
                                                                                        child: CustomText(
                                                                                          data: '  ${controller.formattedToDate.value}',
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
                                                                        if (controller.formattedFromDate.value !=
                                                                                "" &&
                                                                            controller.formattedToDate.value !=
                                                                                "") {
                                                                          controller
                                                                              .datefilterLeaveApi();
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
                                                                        40.r),
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
                                              SingleChildScrollView(
                                                child: SizedBox(
                                                  height: 580.h,
                                                  child: CustomRefreshIndicator(
                                                    leadingScrollIndicatorVisible:
                                                        false,
                                                    trailingScrollIndicatorVisible:
                                                        false,
                                                    builder:
                                                        MaterialIndicatorDelegate(
                                                      builder: (context,
                                                          controller) {
                                                        return Icon(
                                                          Icons.refresh,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          size: 20,
                                                        );
                                                      },
                                                      scrollableBuilder:
                                                          (context, child,
                                                              controller) {
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
                                                            const Duration(
                                                                milliseconds:
                                                                    2),
                                                            () async {
                                                      await controller
                                                          .leaveApi();
                                                    }),
                                                    child: Column(
                                                      children: [
                                                        Obx(
                                                          () {
                                                            switch (controller
                                                                .rxRequestStatus
                                                                .value) {
                                                              case Status
                                                                    .Loading:
                                                                return Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                );
                                                              case Status
                                                                    .Complete:
                                                                return Expanded(
                                                                  child:
                                                                      CustomRefreshIndicator(
                                                                    leadingScrollIndicatorVisible:
                                                                        true,
                                                                    trailingScrollIndicatorVisible:
                                                                        true,
                                                                    builder:
                                                                        MaterialIndicatorDelegate(
                                                                      builder:
                                                                          (context,
                                                                              controller) {
                                                                        return Icon(
                                                                          Icons
                                                                              .refresh,
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .primary,
                                                                          size:
                                                                              30,
                                                                        );
                                                                      },
                                                                      scrollableBuilder: (context,
                                                                          child,
                                                                          controller) {
                                                                        return Opacity(
                                                                          opacity:
                                                                              1.0 - controller.value.clamp(0.0, 1.0),
                                                                          child:
                                                                              child,
                                                                        );
                                                                      },
                                                                    ),
                                                                    onRefresh: () => Future.delayed(
                                                                        Duration(
                                                                            milliseconds:
                                                                                2),
                                                                        () async {
                                                                      await controller
                                                                          .updateDataListApi();
                                                                    }),
                                                                    child: rejecteditems.length ==
                                                                            null
                                                                        ? CustomText(
                                                                            data:
                                                                                "Data not found")
                                                                        : ListView
                                                                            .builder(
                                                                            padding:
                                                                                EdgeInsets.zero,
                                                                            itemCount:
                                                                                rejecteditems.length,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              return Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                                                                margin: EdgeInsets.symmetric(
                                                                                  horizontal: 10.w,
                                                                                  vertical: 15.h,
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(20.r),
                                                                                  color: Colors.white,
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      offset: Offset(2, 6),
                                                                                      blurRadius: 8.r,
                                                                                      color: Colors.blue.shade900,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsets.all(5.h),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          CustomText(
                                                                                            data: rejecteditems[index].leaveType.toString(),
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                          CustomText(
                                                                                            data: rejecteditems[index].leaveStatus.toString(),
                                                                                            fontSize: 16.sp,
                                                                                            color: Colors.red,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Divider(),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.all(5.h),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          CustomText(
                                                                                            data: "Leave from :",
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 10.w,
                                                                                          ),
                                                                                          Icon(
                                                                                            CupertinoIcons.calendar,
                                                                                            size: 15,
                                                                                          ),
                                                                                          //SizedBox(width :3.w),
                                                                                          CustomText(
                                                                                            data: DateFormat("dd/MM/yyyy").format(DateTime.parse(rejecteditems[index].leaveFromDate.toString())),
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 15.w,
                                                                                          ),
                                                                                          CustomText(
                                                                                            data: "to:",
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 15.w,
                                                                                          ),
                                                                                          Icon(
                                                                                            CupertinoIcons.calendar,
                                                                                            size: 15,
                                                                                          ),
                                                                                          //SizedBox(width :3.w),
                                                                                          CustomText(
                                                                                            data: DateFormat("dd/MM/yyyy").format(DateTime.parse(rejecteditems[index].leaveToDate.toString())),
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Divider(),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.all(5.h),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          CustomText(
                                                                                            data: "Resume on :",
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                          CustomText(
                                                                                            data: DateFormat("dd/MM/yyyy").format(DateTime.parse(rejecteditems[index].resumedutyDate.toString())),
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Divider(),
                                                                                    InkWell(
                                                                                        onTap: () {
                                                                                          var data = rejecteditems[index];
                                                                                          Get.toNamed(AppRoutesName.leave_view_all, arguments: [
                                                                                            data.leaveFromDate,
                                                                                            data.leaveToDate,
                                                                                            data.leaveApplyfor,
                                                                                            data.leaveType,
                                                                                            data.alternateContactNo,
                                                                                            data.resumedutyDate,
                                                                                            data.namee,
                                                                                            data.createBy
                                                                                          ]);
                                                                                        },
                                                                                        child: Align(
                                                                                          alignment: Alignment.centerRight,
                                                                                          child: Text(
                                                                                            "View More",
                                                                                            style: TextStyle(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              fontSize: 16.sp,
                                                                                            ),
                                                                                          ),
                                                                                        )),
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
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            controller.updateDataListApi();
                                                                          },
                                                                          child:
                                                                              CustomText(data: "Retry"))
                                                                    ],
                                                                  ),
                                                                );
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
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
                                                      controller
                                                          .updateDataListApi();
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
                  SingleChildScrollView(
                      child: Column(children: [
                    Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: Colors.white,
                        ),
                        child: Form(
                            key: controller.formKey.value,
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(data: "Leave From Date"),
                                    Container(
                                      height: 50.h,
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 4.h),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius:
                                            BorderRadius.circular(50.r),
                                      ),
                                      child: TextFormField(
                                        controller: controller.LeaveFrom,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          suffixIcon:
                                              Icon(Icons.calendar_month),
                                          border: InputBorder.none,
                                          hintText: "Leave From Date",
                                        ),
                                        onTap: () async {
                                          DateTime today = DateTime.now();
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            firstDate: DateTime(1980),
                                            lastDate: DateTime(2025, 12, 31),
                                            // Set lastDate to a specific date in 2025
                                            initialDate: DateTime.now(),
                                          );

                                          if (pickedDate == null) return;
                                          controller.LeaveFrom.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);

                                          // Automatically update Leave To Date (one day after Leave From Date)
                                          //controller.LeaveTo.text = DateFormat('yyyy-MM-dd').format(pickedDate.add(Duration(days: 1)));

                                          print(
                                              "Time ${controller.LeaveFrom.text}");
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Required Field';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    CustomText(data: "Leave To Date"),
                                    Container(
                                      height: 50.h,
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 4.h),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius:
                                            BorderRadius.circular(50.r),
                                      ),
                                      child: TextFormField(
                                        controller: controller.LeaveTo,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          suffixIcon:
                                              Icon(Icons.calendar_month),
                                          border: InputBorder.none,
                                          hintText: "Leave To Date",
                                        ),
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            firstDate: DateTime(1980),
                                            lastDate: DateTime(2025, 12, 31),
                                            // Set lastDate to a specific date in 2025
                                            initialDate: DateTime.now(),
                                          );

                                          if (pickedDate == null) return;
                                          controller.LeaveTo.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);

                                          print(
                                              "Leave To Date: ${controller.LeaveTo.text}");
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Required Field';
                                          }
                                          return null;
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(data: "Leave Apply For"),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 4.h),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                          ),
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller:
                                                controller.LeaveApplyFor,
                                            decoration: InputDecoration(
                                              hintText: "Leave Apply For",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        CustomText(data: "Leave Type"),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20.w,
                                            vertical: 4.h,
                                          ),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                          ),
                                          child: Obx(
                                            () =>
                                                DropdownButtonFormField<String>(
                                              value: controller
                                                      .leaveType.value.isEmpty
                                                  ? null
                                                  : controller.leaveType.value,
                                              onChanged: (String? newValue) {
                                                if (newValue != null) {
                                                  controller.leaveType.value =
                                                      newValue; // Update the RxString value
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                hintText: "",
                                                border: InputBorder.none,
                                              ),
                                              hint: Text(
                                                "Leave Apply For",
                                                style: GoogleFonts.roboto(
                                                    color: Colors.grey),
                                              ),
                                              items: [
                                                "Sick Leave",
                                                "Casual Leave",
                                                "Earn Leave"
                                              ]
                                                  .map((leaveType) =>
                                                      DropdownMenuItem<String>(
                                                        value: leaveType,
                                                        child: Text(leaveType),
                                                      ))
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        CustomText(
                                            data: "Alternate Contact Number"),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 4.h),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                          ),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller:
                                                controller.altContactnumber,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                              // Limit to 10 digits
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              // Allow only digits
                                            ],
                                            decoration: InputDecoration(
                                              hintText: "Alternate Contact NO",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        CustomText(
                                            data: "Backup Resource Name"),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 4.h),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                          ),
                                          child: Obx(
                                            () => controller
                                                    .leaveemployees.isNotEmpty
                                                ? MultiSelectDialogField(
                                                    title: const Text(
                                                      "Select Any One Employee",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 18),
                                                    ),
                                                    items: controller
                                                        .leaveemployees
                                                        .map((employee) =>
                                                            MultiSelectItem(
                                                                '${employee.employeeId}',
                                                                '${employee.employeeId} - ${employee.firstName} ${employee.lastName ?? ''}'))
                                                        .toList(),
                                                    initialValue: controller
                                                            .leaveempName
                                                            .value
                                                            .isNotEmpty
                                                        ? controller
                                                            .leaveempName.value
                                                            .split(',')
                                                        : [],
                                                    onConfirm: (values) {
                                                      if (values.isNotEmpty) {
                                                        var selectedValue =
                                                            values.first;
                                                        int selectedId =
                                                            int.parse(
                                                                selectedValue);
                                                        controller.leaveempName
                                                                .value =
                                                            selectedValue;
                                                        controller
                                                            .leaveemployeesId
                                                            .value = selectedId;
                                                      } else {
                                                        controller.leaveempName
                                                            .value = '';
                                                        controller
                                                            .leaveemployeesId
                                                            .value = 0;
                                                      }
                                                    },
                                                    chipDisplay:
                                                        MultiSelectChipDisplay(
                                                      items: controller
                                                          .leaveemployees
                                                          .where((employee) =>
                                                              controller
                                                                  .leaveemployeesId
                                                                  .value ==
                                                              employee
                                                                  .employeeId)
                                                          .map((employee) =>
                                                              MultiSelectItem(
                                                                  '${employee.employeeId}',
                                                                  '${employee.firstName} ${employee.lastName ?? ''}'))
                                                          .toList(),
                                                      onTap: (value) {},
                                                    ),
                                                  )
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        CustomText(data: "Resume duty On"),
                                        Container(
                                          height: 50.h,
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 4.h),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                          ),
                                          child: TextFormField(
                                            controller: controller.resumedate,
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                              suffixIcon:
                                                  Icon(Icons.calendar_month),
                                              border: InputBorder.none,
                                              hintText: "Resume Date",
                                            ),
                                            onTap: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                context: context,
                                                firstDate: DateTime(1980),
                                                lastDate:
                                                    DateTime(2025, 12, 31),
                                                // Set lastDate to a specific date in 2025
                                                initialDate: DateTime.now(),
                                              );

                                              if (pickedDate == null) return;
                                              controller.resumedate.text =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);

                                              print(
                                                  "resume date: ${controller.LeaveTo.text}");
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Required Field';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            final isValid = controller
                                                .formKey.value.currentState!
                                                .validate();
                                            if (controller.LeaveFrom.value.text
                                                    .toString()
                                                    .isEmpty &&
                                                controller
                                                    .LeaveApplyFor.value.text
                                                    .toString()
                                                    .isEmpty) {
                                              ShortMessage.toast(
                                                  title:
                                                      "Please fill all fields");
                                            } else {
                                              //final addExpenseModel = Get.find<AddExpenseController>();
                                              addLeave(
                                                  controller
                                                      .LeaveFrom.value.text,
                                                  controller.LeaveTo.value.text,
                                                  controller
                                                      .LeaveApplyFor.value.text,
                                                  controller.leaveType.value,
                                                  controller.altContactnumber
                                                      .value.text,
                                                  controller
                                                      .resumedate.value.text,
                                                  controller
                                                      .leaveemployeesId.value,
                                                  controller.empid.value);
                                              await controller
                                                  .datefilterLeaveApi();
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 30.w,
                                                vertical: 10.h),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50.r),
                                                color: CustomColor.blueColor,
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: Offset(0, 0.9),
                                                      blurRadius: 8.r,
                                                      color:
                                                          CustomColor.blueColor)
                                                ]),
                                            child: CustomText(
                                              data: "Submit",
                                              color: Colors.white,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                /* Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 3.h),
              margin: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                color: CustomColor.blueColor,
              ),
              alignment: Alignment.center,
              child: CustomText(
                data: "View Expense Details",
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Obx(
                  () {
                switch (controller.rxRequestStatus.value) {
                  case Status.Loading:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case Status.Complete:
                    return SizedBox(
                      height: 450.h,
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
                        onRefresh: () =>
                            Future.delayed(Duration(milliseconds: 2), () async {
                              await controller.updateDataListApi();
                            }),
                        child: controller
                            .viewExpensedatalist.value.data?.length ==
                            null
                            ? CustomText(data: "Data not found")
                            : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: controller
                              .viewExpensedatalist.value.data?.length,
                          itemBuilder: (context, index) {
                            int reverseIndex = controller
                                .viewExpensedatalist
                                .value
                                .data!
                                .length -
                                1 -
                                index;

                            String apiDate =
                                "${controller.viewExpensedatalist.value.data![reverseIndex].createDate}"; // Replace this with the date from your API
                            DateTime dateString = DateTime.parse(apiDate);

                            String formattedDate =
                            DateFormat("dd/MM/yyyy")
                                .format(dateString);
                            String formattedTime =
                            DateFormat("HH:mm a").format(dateString);
                            String todayDate = DateFormat("dd/MM/yyyy")
                                .format(DateTime.now());
                            return formattedDate != todayDate
                                ? SizedBox()
                                : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 10.h),
                              margin: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 15.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(20.r),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(2, 6),
                                    blurRadius: 8.r,
                                    color:
                                    Colors.lightGreen.shade200,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                            Color(0xFF67a509),
                                            maxRadius: 20.r,
                                            child: Icon(
                                              Icons.oil_barrel,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Column(
                                            children: [
                                              CustomText(
                                                data: controller
                                                    .viewExpensedatalist
                                                    .value
                                                    .data?[
                                                reverseIndex]
                                                    .category ==
                                                    null
                                                    ? ""
                                                    : controller
                                                    .viewExpensedatalist
                                                    .value
                                                    .data![
                                                reverseIndex]
                                                    .category
                                                    .toString(),
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                              CustomText(
                                                data:
                                                "₹${controller.viewExpensedatalist.value.data?[reverseIndex].amount == null ? "" : controller.viewExpensedatalist.value.data![reverseIndex].amount.toString()}",
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          CustomText(
                                            data:
                                            "Date: ${formattedDate}",
                                            fontSize: 14.sp,
                                            fontWeight:
                                            FontWeight.w500,
                                          ),
                                          CustomText(
                                            data:
                                            "Time: ${formattedTime}",
                                            fontSize: 14.sp,
                                            fontWeight:
                                            FontWeight.w500,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Obx(() {
                                    return controller
                                        .viewExpensedatalist
                                        .value
                                        .data?[reverseIndex]
                                        .description ==
                                        null
                                        ? SizedBox()
                                        : Row(
                                      children: [
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Icon(
                                          Icons
                                              .event_note_sharp,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: 21.w,
                                        ),
                                        Expanded(
                                          child: CustomText(
                                            data: controller
                                                .viewExpensedatalist
                                                .value
                                                .data?[
                                            reverseIndex]
                                                .description ??
                                                "",
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                                  // Divider(
                                  //   thickness: 1,
                                  //   color: Colors.black,
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.end,
                                  //   children: [
                                  //     InkWell(
                                  //       onTap: () async {
                                  //         await FileDownloader
                                  //             .downloadFile(
                                  //           url: AppUrl
                                  //                   .expense_invoice_download_url +
                                  //               controller
                                  //                   .viewExpensedatalist
                                  //                   .value
                                  //                   .data![
                                  //                       reverseIndex]
                                  //                   .invoice!,
                                  //           notificationType:
                                  //               NotificationType
                                  //                   .all,
                                  //           onProgress:
                                  //               (name, progress) {
                                  //             print(
                                  //                 "ncncncncncncncncn $name");
                                  //           },
                                  //           onDownloadCompleted:
                                  //               (value) {
                                  //             print(
                                  //                 'path  $value ');
                                  //             ShortMessage.toast(
                                  //                 title:
                                  //                     "File is download in Download folder");
                                  //           },
                                  //           onDownloadError:
                                  //               (value) {
                                  //             print(
                                  //                 'path  $value ');
                                  //             ShortMessage.toast(
                                  //                 title:
                                  //                     "Downloading error");
                                  //           },
                                  //         );
                                  //       },
                                  //       child: Container(
                                  //         child: Row(
                                  //           children: [
                                  //             CircleAvatar(
                                  //               backgroundColor:
                                  //                   Color(
                                  //                       0xFF67a509),
                                  //               maxRadius: 15.r,
                                  //               child: Icon(
                                  //                 Icons.download,
                                  //                 color:
                                  //                     Colors.black,
                                  //                 size: 20.r,
                                  //               ),
                                  //             ),
                                  //             SizedBox(
                                  //               width: 10.w,
                                  //             ),
                                  //             CustomText(
                                  //               data:
                                  //                   "Downaload reciept",
                                  //               fontWeight:
                                  //                   FontWeight.w500,
                                  //             )
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // )
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
                                controller.updateDataListApi();
                              },
                              child: CustomText(data: "Retry"))
                        ],
                      ),
                    );
                }
              },
            ),*/
                              ],
                            )))
                  ])),
                  Column(
                    children: [
                      Obx(() {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: CalendarCarousel<Event>(
                            todayBorderColor: Colors.green,
                            onDayPressed: (date, events) {
                              controller.currentDate2.value = date;
                              for (var event in events) {
                                Get.defaultDialog(
                                  title: "Leave",
                                  middleText: event.title == "A"
                                      ? "ABSENT"
                                      : event.title == "P"
                                          ? event.description.toString()
                                          : "HOLIDAY",
                                  content: Text(event.description.toString()),
                                );
                              }
                            },
                            daysHaveCircularBorder: true,
                            showOnlyCurrentMonthDate: true,
                            weekendTextStyle: const TextStyle(
                              color: Colors.red,
                            ),
                            thisMonthDayBorderColor: Colors.grey,
                            weekFormat: false,
                            markedDatesMap: controller.markedDateMap1.value,
                            height: 450.0.h,
                            selectedDateTime: controller.currentDate2.value,
                            targetDateTime: controller.targetDateTime.value,
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
                            minSelectedDate: controller.currentDate2.value
                                .subtract(const Duration(days: 360)),
                            maxSelectedDate: controller.currentDate2.value
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
                              controller.targetDateTime.value = date;
                              controller.currentMonth.value = DateFormat.yMMM()
                                  .format(controller.targetDateTime.value);
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
                                          color: Colors.red.withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              1000.r,
                                            ),
                                          ),
                                          border: Border.all(
                                            color: Colors.red.withOpacity(0.5),
                                            width: 25.0.w,
                                          )),
                                    ),
                                    CustomText(
                                      data: " : Leave",
                                      color: Colors.black,
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.w400,
                                    )
                                  ],
                                )
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
