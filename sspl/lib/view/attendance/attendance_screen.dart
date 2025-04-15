import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:search_page/search_page.dart';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';
import 'package:sspl/infrastructure/routes/page_constants.dart';
import 'package:sspl/sevices/models/attendance/dateAttendanceModel.dart';
import 'package:sspl/utilities/custom_toast/custom_toast.dart';

import '../../controllers/attendance/attendance_controller.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../sevices/models/attendance/view_attendance_model.dart';
import '../../utilities/custom_color/custom_color.dart';
import '../../utilities/custom_text/custom_text.dart';

class AttendanceScreen extends GetView<AttendanceScreenController> {
  @override
  Widget build(BuildContext context) {
    Get.put(
      AttendanceScreenController(),
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: CustomText(
              data: 'Attendance',
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
                      data: "Attendance Detail",
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
                  Obx(
                    () {
                      switch (controller.rxRequestStatus.value) {
                        case Status.Loading:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        case Status.Complete:
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
                                                  TodayAttendaceModelData>(
                                              items: controller
                                                      .viewScheduledDataList
                                                      .value
                                                      .data ??
                                                  [],
                                              searchLabel: 'Search',
                                              suggestion: Center(
                                                child: AutoSizeText(
                                                  'Filter by clockin and clockout',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              failure: Center(
                                                child: AutoSizeText(
                                                  'Found Nothing :(',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              filter: (person) => [
                                                    DateFormat('dd MMMM yyyy')
                                                        .format(DateTime.parse(
                                                            person.clockIN
                                                                .toString())),
                                                    person.date,
                                                  ],
                                              builder: (person) {
                                                DateTime dateString =
                                                    DateTime.parse(person
                                                        .clockIN
                                                        .toString());
                                                DateTime dateStringout =
                                                    DateTime.parse(person
                                                        .clockOUT
                                                        .toString());

                                                String attendate =
                                                    DateFormat("dd MMM yyy ")
                                                        .format(dateString);
                                                String checkinTime =
                                                    DateFormat("HH:mm:ss a")
                                                        .format(dateString);
                                                String checkoutTime =
                                                    DateFormat("HH:mm:ss a")
                                                        .format(dateStringout);
                                                return Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 10.h),
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 10.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        offset: Offset(2, 6),
                                                        blurRadius: 8.r,
                                                        color: Colors
                                                            .blue.shade900,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .calendar_month,
                                                            size: 16.r,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          CustomText(
                                                            data: attendate,
                                                            //fontWeight: FontWeight.w500,
                                                            fontSize: 16.sp,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        // crossAxisAlignment:
                                                        // CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            height: 35.h,
                                                            width: 35.h,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(50
                                                                            .r),
                                                                color: CustomColor
                                                                    .blueColor),
                                                            child: CustomText(
                                                              data: "P",
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                          Row(
                                                            // mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CustomText(
                                                                data:
                                                                    "Clock-In    : ",
                                                                fontSize: 12.sp,
                                                                // Reduced font size
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              SizedBox(
                                                                width: 100.w,
                                                                child:
                                                                    CustomText(
                                                                  data:
                                                                      checkinTime,
                                                                  fontSize: 12
                                                                      .sp, // Reduced font size
                                                                ),
                                                              ),
                                                              CustomText(
                                                                data:
                                                                    "Clock-Out : ",
                                                                fontSize: 12.sp,
                                                                // Reduced font size
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              SizedBox(
                                                                width: 100.w,
                                                                child:
                                                                    CustomText(
                                                                  data:
                                                                      checkoutTime,
                                                                  fontSize: 12
                                                                      .sp, // Reduced font size
                                                                ),
                                                              ),
                                                            ],
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
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          // border: Border.all(
                                          //   color: Colors.black,
                                          // ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 50.h,
                                              width: 50.w,
                                              margin:
                                                  EdgeInsets.only(right: 135.w),
                                              decoration: BoxDecoration(
                                                color: CustomColor.blueColor,
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(10.r),
                                                  bottomLeft: Radius.circular(
                                                    10.r,
                                                  ),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.search,
                                                color: Colors.white,
                                              ),
                                            ),
                                            CustomText(
                                              data: "Search",
                                              color: Colors.black,
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
                                        Get.bottomSheet(Container(
                                          height: 320.h,
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                              color: Colors.white),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 50.h,
                                                width: Get.width,
                                                color: CustomColor.blueColor,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 20.w,
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Get.back();
                                                        },
                                                        child: Icon(
                                                          CupertinoIcons
                                                              .multiply,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    CustomText(
                                                      data: "Filters",
                                                      fontSize: 20.sp,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      width: 60.w,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                            text: "Date from",
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    fontSize:
                                                                        18.sp,
                                                                    color: Colors
                                                                        .black),
                                                            children: [
                                                              TextSpan(
                                                                text: "*",
                                                                style: GoogleFonts.roboto(
                                                                    fontSize:
                                                                        20.sp,
                                                                    color: Colors
                                                                        .red),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Obx(() {
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20.w,
                                                                right: 20.w,
                                                                top: 10.h),
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 50.h,
                                                                  width: 400.w,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () =>
                                                                        controller
                                                                            .selectFromDate(context),
                                                                    child: controller.formattedFromDate.value ==
                                                                            ""
                                                                        ? Container(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            height:
                                                                                50.h,
                                                                            width:
                                                                                400,
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(10.r),
                                                                                border: Border.all(width: 0.5.w)),
                                                                            child:
                                                                                CustomText(
                                                                              data: '   Select From Date',
                                                                            ),
                                                                          )
                                                                        : Container(
                                                                            height:
                                                                                50.h,
                                                                            width:
                                                                                400,
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(10.r),
                                                                                border: Border.all(width: 0.5.w)),
                                                                            child:
                                                                                CustomText(
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
                                                      height: 10.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        RichText(
                                                            text: TextSpan(
                                                                text: "Date to",
                                                                style: GoogleFonts.roboto(
                                                                    fontSize:
                                                                        18.sp,
                                                                    color: Colors
                                                                        .black),
                                                                children: [
                                                              TextSpan(
                                                                text: "*",
                                                                style: GoogleFonts.roboto(
                                                                    fontSize:
                                                                        20.sp,
                                                                    color: Colors
                                                                        .red),
                                                              )
                                                            ])),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Obx(() {
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 20.w,
                                                          right: 20.w,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 50.h,
                                                              width: 400.w,
                                                              child: InkWell(
                                                                onTap: () => controller
                                                                    .selectToDate(
                                                                        context),
                                                                child: controller
                                                                            .formattedToDate
                                                                            .value ==
                                                                        ""
                                                                    ? Container(
                                                                        alignment:
                                                                            Alignment
                                                                                .centerLeft,
                                                                        height: 50
                                                                            .h,
                                                                        width:
                                                                            400,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius: BorderRadius.circular(10.r),
                                                                            border: Border.all(width: 0.5.w)),
                                                                        child: CustomText(data: '   Select To Date'))
                                                                    : Container(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        height:
                                                                            50.h,
                                                                        width:
                                                                            400,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius: BorderRadius.circular(10.r),
                                                                            border: Border.all(width: 0.5.w)),
                                                                        child:
                                                                            CustomText(
                                                                          data:
                                                                              '  ${controller.formattedToDate.value}',
                                                                          // Display the formatted date

                                                                          fontSize:
                                                                              14.sp,
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
                                                      height: 10.h,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        if (controller
                                                                    .formattedFromDate
                                                                    .value !=
                                                                "" &&
                                                            controller
                                                                    .formattedToDate
                                                                    .value !=
                                                                "") {
                                                          controller
                                                              .DatewisedataListApi();
                                                          Get.back();
                                                        } else {
                                                          ShortMessage.toast(
                                                              title:
                                                                  "Please select date");
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 50.h,
                                                        width: Get.width,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: CustomColor
                                                                .blueColor),
                                                        child: CustomText(
                                                          data: "Apply Filter",
                                                          fontSize: 18.sp,
                                                          color: Colors.white,
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
                                        margin: EdgeInsets.only(left: 6.w),
                                        height: 50.h,
                                        width: 50.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40.r),
                                            border: Border.all(width: 0.5.w)),
                                        child: Icon(
                                          Icons.calendar_month,
                                          size: 40.r,
                                          color: CustomColor.blueColor,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: CustomRefreshIndicator(
                                  leadingScrollIndicatorVisible: false,
                                  trailingScrollIndicatorVisible: false,
                                  builder: MaterialIndicatorDelegate(
                                    builder: (context, controller) {
                                      return Icon(
                                        Icons.refresh,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 20,
                                      );
                                    },
                                    scrollableBuilder:
                                        (context, child, controller) {
                                      return Opacity(
                                        opacity: 1.0 -
                                            controller.value.clamp(0.0, 1.0),
                                        child: child,
                                      );
                                    },
                                  ).call,
                                  onRefresh: () => Future.delayed(
                                      const Duration(milliseconds: 2),
                                      () async {
                                    await controller.updateDataListApi();
                                  }),
                                  child: controller.viewScheduledMonthDataList
                                              .value.data?.length ==
                                          null
                                      ? CustomText(data: "Data not found")
                                      : ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: controller
                                              .viewScheduledMonthDataList
                                              .value
                                              .data
                                              ?.length,
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
                                                : controller
                                                    .viewScheduledMonthDataList
                                                    .value
                                                    .data![reverseIndex]
                                                    .date
                                                    .toString();
                                            String apiDate =
                                                "${controller.viewScheduledMonthDataList.value.data![reverseIndex].clockIN}";
                                            String apiDate1 =
                                                "${controller.viewScheduledMonthDataList.value.data![reverseIndex].clockOUT}";

                                            DateTime dateString =
                                                DateTime.parse(apiDate);
                                            DateTime dateString1 =
                                                DateTime.parse(apiDate1);
                                            DateTime dateString2 =
                                                DateTime.parse(attendanceDate);
                                            String checkInTime =
                                                DateFormat("hh:mm:ss a")
                                                    .format(dateString);
                                            String checkInDate =
                                                DateFormat("dd MMM yyyy ")
                                                    .format(dateString);

                                            String checkOutTime =
                                                DateFormat("hh:mm:ss a")
                                                    .format(dateString1);

                                            String checkinTime =
                                                DateFormat("HH:mm:ss a")
                                                    .format(dateString);
                                            PrefManager().writeValue(
                                                key: PrefConst.timeonlycheckin,
                                                value: checkinTime);

                                            String checkOutTime2 =
                                                DateFormat("HH:mm:ss a")
                                                    .format(dateString1);
                                            PrefManager().writeValue(
                                                key: PrefConst.timeonlycheckout,
                                                value: checkOutTime2);

                                            String attendanceDateTime =
                                                DateFormat("dd MMM yyyy ")
                                                    .format(dateString2);

                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 10.h),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 10.h),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .calendar_today_sharp,
                                                        size: 20.r,
                                                      ),
                                                      CustomText(
                                                        data: checkInDate,
                                                        //fontWeight: FontWeight.w500,
                                                        fontSize: 16.sp,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    // crossAxisAlignment:
                                                    // CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 35.h,
                                                        width: 35.h,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.r),
                                                            color: CustomColor
                                                                .blueColor),
                                                        child: CustomText(
                                                          data: "P",
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      Row(
                                                        // mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          CustomText(
                                                            data:
                                                                "Clock-In    : ",
                                                            fontSize: 12.sp,
                                                            // Reduced font size
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          SizedBox(
                                                            width: 100.w,
                                                            child: CustomText(
                                                              data: checkInTime,
                                                              fontSize: 12
                                                                  .sp, // Reduced font size
                                                            ),
                                                          ),
                                                          CustomText(
                                                            data:
                                                                "Clock-Out : ",
                                                            fontSize: 12.sp,
                                                            // Reduced font size
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          SizedBox(
                                                            width: 100.w,
                                                            child: CustomText(
                                                              data:
                                                                  checkOutTime,
                                                              fontSize: 12
                                                                  .sp, // Reduced font size
                                                            ),
                                                          ),
                                                        ],
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
                              for (var event in events) {
                                Get.defaultDialog(
                                  title: "Attendance",
                                  middleText: event.title == "A"
                                      ? "ABSENT"
                                      : event.title == "P"
                                          ? event.description.toString()
                                          : "HOLIDAY",
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
                                      data: " : Present",
                                      color: Colors.black,
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.w400,
                                    )
                                  ],
                                ),
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
                                      data: " : Absent",
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
