import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:search_page/search_page.dart';
import 'package:sspl/controllers/dashboard/dashboard.dart';
import 'package:sspl/sevices/models/followup_model/today_followup_model.dart';

import '../../infrastructure/image_constants/image_constants.dart';
import '../../infrastructure/routes/page_constants.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../utilities/custom_color/custom_color.dart';
import '../../utilities/custom_text/custom_text.dart';
import '../../utilities/custom_toast/custom_toast.dart';

class Job_AssignedBy extends GetView<DashboardController> {
  const Job_AssignedBy({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CustomText(
            data: 'Job Assigned',
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
              )),
        ),
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
                        data: "Pending Job",
                        color: Colors.red,
                      ),
                    ),
                    Tab(
                        child: CustomText(
                      data: "Completed Job",
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
                        switch (controller.rxscheduleStatus.value) {
                          case Status.Loading:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case Status.Complete:
                            // Filter the list to include only items with jobStatus "Pending"
                            var pendingItems = controller
                                    .viewtodayFollowupDataList.value.data
                                    ?.where(
                                        (item) => item.jobStatus == "Pending")
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
                                            delegate:
                                                SearchPage<
                                                        TodayFollowupModelData>(
                                                    items: pendingItems,
                                                    searchLabel: 'Search ',
                                                    suggestion: Center(
                                                      child: AutoSizeText(
                                                        'Filter',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    failure: Center(
                                                      child: AutoSizeText(
                                                        'Found Nothing :(',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    filter: (person) => [
                                                          person.jobDetails,
                                                          person.createBy,
                                                          person.jobStatus,
                                                        ],
                                                    builder: (person) {
                                                      return Column(
                                                        children: [
                                                          Container(
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
                                                              color:
                                                                  Colors.white,
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
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          CustomText(
                                                                        data:
                                                                            "Job Details:",
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.date_range),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10.r),
                                                                            ),
                                                                            child:
                                                                                CustomText(
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
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Divider(),
                                                                    Container(
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            CustomText(
                                                                          data: person.jobDetails == null
                                                                              ? "Job remaining"
                                                                              : person.jobDetails.toString(),
                                                                          fontSize:
                                                                              16.sp,
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
                                                                          FontWeight
                                                                              .bold,
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
                                                                                Align(
                                                                                  alignment: Alignment.centerLeft,
                                                                                  child: Text(
                                                                                    "Remark",
                                                                                    style: TextStyle(
                                                                                      fontSize: 16.sp,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                                                                                  alignment: Alignment.center,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.grey.shade200,
                                                                                    borderRadius: BorderRadius.circular(50.r),
                                                                                  ),
                                                                                  child: TextFormField(
                                                                                    keyboardType: TextInputType.text,
                                                                                    // controller: controller.Emailid,
                                                                                    decoration: InputDecoration(
                                                                                      hintText: "Remark ",
                                                                                      hintStyle: GoogleFonts.roboto(color: Colors.grey),
                                                                                      border: InputBorder.none,
                                                                                    ),
                                                                                  ),
                                                                                ),
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
                                                                                Spacer(),
                                                                                Container(
                                                                                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                                                                                  alignment: Alignment.center,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.grey.shade200,
                                                                                    borderRadius: BorderRadius.circular(50.r),
                                                                                  ),
                                                                                  child: Obx(
                                                                                    () => DropdownButtonFormField<String>(
                                                                                      value: controller.jobStatus.value.isEmpty ? null : controller.jobStatus.value,
                                                                                      onChanged: (String? newValue) {
                                                                                        if (newValue != null) {
                                                                                          controller.jobStatus.value = newValue; // Update the RxString value
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
                                                                                        "Pending",
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
                                                                                  onPressed: () async {},
                                                                                  child: const Text('Submit'),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      child: CustomText(
                                                                          data: person.jobStatus == null
                                                                              ? ""
                                                                              : person.jobStatus
                                                                                  .toString(),
                                                                          fontSize: 16
                                                                              .sp,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color:
                                                                              Colors.red),
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
                                                                          "Assigned By ",
                                                                      fontSize:
                                                                          16.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    CustomText(
                                                                      data: person.createBy ==
                                                                              null
                                                                          ? ""
                                                                          : person
                                                                              .createBy
                                                                              .toString(),
                                                                      fontSize:
                                                                          16.sp,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Divider(),
                                                                person.jobImage ==
                                                                        null
                                                                    ? const SizedBox() // If job image is null, return an empty SizedBox
                                                                    : Align(
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            Icon(Icons.download),
                                                                            CustomText(
                                                                                data: "Download",
                                                                                color: CustomColor.blueColor),
                                                                          ],
                                                                        ),
                                                                      )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
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
                                                margin: EdgeInsets.only(
                                                    right: 135.w),
                                                decoration: BoxDecoration(
                                                  color: CustomColor.blueColor,
                                                  borderRadius:
                                                      BorderRadius.only(
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
                                            height: 300.h,
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
                                                        padding:
                                                            EdgeInsets.only(
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
                                                              text:
                                                                  " Date from",
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
                                                                    height:
                                                                        50.h,
                                                                    width:
                                                                        400.w,
                                                                    child:
                                                                        InkWell(
                                                                      onTap: () =>
                                                                          controller
                                                                              .selectFromDate(context),
                                                                      child: controller.formattedFromDate.value ==
                                                                              ""
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
                                                        height: 10.h,
                                                      ),
                                                      Row(
                                                        children: [
                                                          RichText(
                                                              text: TextSpan(
                                                                  text:
                                                                      "Date to",
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
                                                                  onTap: () =>
                                                                      controller
                                                                          .selectToDate(
                                                                              context),
                                                                  child: controller
                                                                              .formattedToDate
                                                                              .value ==
                                                                          ""
                                                                      ? Container(
                                                                          alignment: Alignment
                                                                              .centerLeft,
                                                                          height: 50
                                                                              .h,
                                                                          width:
                                                                              400,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
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
                                                                              color: Colors.white,
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
                                                                .datefilterapi();
                                                            Get.back();
                                                          } else {
                                                            ShortMessage.toast(
                                                                title:
                                                                    "Please select date");
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 37.h,
                                                          width: Get.width,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color: CustomColor
                                                                  .blueColor),
                                                          child: CustomText(
                                                            data:
                                                                "Apply Filter",
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
                                                  BorderRadius.circular(20.r),
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
                                SingleChildScrollView(
                                  child: SizedBox(
                                    height: 575.h,
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
                                            size: 30,
                                          );
                                        },
                                        scrollableBuilder:
                                            (context, child, controller) {
                                          return Opacity(
                                            opacity: 1.0 -
                                                controller.value
                                                    .clamp(0.0, 1.0),
                                            child: child,
                                          );
                                        },
                                      ).call,
                                      onRefresh: () => Future.delayed(
                                          const Duration(milliseconds: 2),
                                          () async {
                                        await controller
                                            .updateDataListApiTodatfollowup();
                                      }),
                                      child: pendingItems.isEmpty
                                          ? ListView.builder(
                                              itemCount: 1,
                                              itemBuilder: (context, index) {
                                                return Center(
                                                  child: CustomText(
                                                      data: "Data not found"),
                                                );
                                              })
                                          : ListView.builder(
                                              // reverse: true,
                                              padding: EdgeInsets.zero,
                                              itemCount: pendingItems.length,
                                              itemBuilder: (context, index) {
                                                String apiDate =
                                                    "${pendingItems[index].createDate}";

                                                DateTime dateString =
                                                    DateTime.parse(apiDate);
                                                String followupDate = DateFormat(
                                                        "dd MMM yyyy hh:mm a")
                                                    .format(dateString);

                                                return InkWell(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15.w,
                                                            vertical: 5.h),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15.w,
                                                            vertical: 8.h),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset:
                                                                const Offset(
                                                                    0, 4),
                                                            color: Colors.indigo
                                                                .shade100,
                                                            blurRadius: 5.r),
                                                        BoxShadow(
                                                            offset:
                                                                const Offset(
                                                                    0, -1),
                                                            color: Colors.indigo
                                                                .shade100,
                                                            blurRadius: 3.r),
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
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: CustomText(
                                                                data:
                                                                    "Job Details:",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16.sp,
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  const Icon(Icons
                                                                      .date_range),
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal: 10
                                                                            .w,
                                                                        vertical:
                                                                            3.h),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.r),
                                                                    ),
                                                                    child:
                                                                        CustomText(
                                                                      data: pendingItems[index].createDate ==
                                                                              null
                                                                          ? ""
                                                                          : DateFormat('dd MMMM yyyy').format(DateTime.parse(pendingItems[index]
                                                                              .createDate
                                                                              .toString())),
                                                                      fontSize:
                                                                          16.sp,
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
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child:
                                                                    CustomText(
                                                                  data: pendingItems[index]
                                                                              .jobDetails ==
                                                                          null
                                                                      ? "Job remaining"
                                                                      : pendingItems[
                                                                              index]
                                                                          .jobDetails
                                                                          .toString(),
                                                                  fontSize:
                                                                      16.sp,
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
                                                              data: "Status:",
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                //    Show dialog for check in options
                                                                await showAdaptiveDialog<
                                                                    bool>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog
                                                                        .adaptive(
                                                                      content:
                                                                          Text(
                                                                        'Update Status',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16.sp,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Text(
                                                                            "Date",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 16.sp,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              50.h,
                                                                          width:
                                                                              double.infinity,
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: 20.w,
                                                                              vertical: 4.h),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.grey.shade200,
                                                                            borderRadius:
                                                                                BorderRadius.circular(50.r),
                                                                          ),
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                controller.updatedate,
                                                                            readOnly:
                                                                                true,
                                                                            decoration:
                                                                                const InputDecoration(
                                                                              suffixIcon: Icon(Icons.calendar_month),
                                                                              border: InputBorder.none,
                                                                              hintText: "Date",
                                                                            ),
                                                                            onTap:
                                                                                () async {
                                                                              DateTime today = DateTime.now();
                                                                              DateTime? pickedDate = await showDatePicker(
                                                                                context: context,
                                                                                firstDate: today,
                                                                                lastDate: DateTime(2025, 12, 31),
                                                                                initialDate: today,
                                                                              );

                                                                              if (pickedDate == null)
                                                                                return;
                                                                              controller.updatedate.text = DateFormat('yyyy-MM-dd').format(pickedDate);

                                                                              // Automatically update Leave To Date (one day after Leave From Date)
                                                                              //controller.LeaveTo.text = DateFormat('yyyy-MM-dd').format(pickedDate.add(Duration(days: 1)));

                                                                              print("Time ${controller.updatedate.text}");
                                                                            },
                                                                            validator:
                                                                                (value) {
                                                                              if (value!.isEmpty) {
                                                                                return 'Required Field';
                                                                              }
                                                                              return null;
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                                                                            // alignment: Alignment.center,
                                                                            decoration: const BoxDecoration(
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
                                                                        //SizedBox(height: 9.h,),
                                                                        Container(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: 20.w,
                                                                              vertical: 4.h),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.grey.shade200,
                                                                            borderRadius:
                                                                                BorderRadius.circular(50.r),
                                                                          ),
                                                                          child:
                                                                              Obx(
                                                                            () =>
                                                                                DropdownButtonFormField<String>(
                                                                              value: controller.jobStatus.value.isEmpty ? "Pending" : controller.jobStatus.value,
                                                                              onChanged: (String? newValue) {
                                                                                if (newValue != null) {
                                                                                  controller.jobStatus.value = newValue; // Update the RxString value
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
                                                                                "Pending",
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
                                                                          onPressed:
                                                                              () async {
                                                                            DateTime
                                                                                date =
                                                                                DateTime.parse(controller.updatedate.text);

                                                                            Map<String, dynamic>
                                                                                jobData =
                                                                                {
                                                                              "JobStatus": controller.jobStatus.value,
                                                                              "Completedate": controller.updatedate.text,
                                                                              "CreateBy": pendingItems[index].createBy,
                                                                              "JobAssignId": pendingItems[index].jobAssignId
                                                                            };
                                                                            controller.updateJobStatus(jobData);
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Text('Submit'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: CustomText(
                                                                data: pendingItems[index]
                                                                            .jobStatus ==
                                                                        null
                                                                    ? ""
                                                                    : pendingItems[
                                                                            index]
                                                                        .jobStatus
                                                                        .toString(),
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    Colors.red,
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
                                                                  "Assigned By ",
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            CustomText(
                                                              data: pendingItems[
                                                                              index]
                                                                          .createBy ==
                                                                      null
                                                                  ? ""
                                                                  : pendingItems[
                                                                          index]
                                                                      .createBy
                                                                      .toString(),
                                                              fontSize: 16.sp,
                                                            ),
                                                          ],
                                                        ),
                                                        Divider(),
                                                        pendingItems[index]
                                                                    .jobImage !=
                                                                null
                                                            ? Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Icon(Icons
                                                                        .download),
                                                                    CustomText(
                                                                        data:
                                                                            "Download",
                                                                        color: CustomColor
                                                                            .blueColor),
                                                                  ],
                                                                ),
                                                              )
                                                            : SizedBox.shrink(),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
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
                                        controller
                                            .updateDataListApiTodatfollowup();
                                      },
                                      child: CustomText(data: "Retry"))
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
                        switch (controller.rxscheduleStatus.value) {
                          case Status.Loading:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case Status.Complete:
                            // Filter the list to include only items with jobStatus "Completed"
                            var completedItems = controller
                                    .viewtodayFollowupDataList.value.data
                                    ?.where(
                                        (item) => item.jobStatus == "Completed")
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
                                            delegate:
                                                SearchPage<
                                                        TodayFollowupModelData>(
                                                    items: completedItems,
                                                    searchLabel: 'Search',
                                                    suggestion: Center(
                                                      child: AutoSizeText(
                                                        'Filter',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    failure: Center(
                                                      child: AutoSizeText(
                                                        'Found Nothing :(',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    filter: (person) => [
                                                          person.jobDetails,
                                                          person.createBy,
                                                          person.jobStatus,
                                                        ],
                                                    builder: (person) {
                                                      return Column(
                                                        children: [
                                                          Container(
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
                                                              color:
                                                                  Colors.white,
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
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          CustomText(
                                                                        data:
                                                                            "Job Details:",
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.date_range),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10.r),
                                                                            ),
                                                                            child:
                                                                                CustomText(
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
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Divider(),
                                                                    Container(
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            CustomText(
                                                                          data: person.jobDetails == null
                                                                              ? "Job remaining"
                                                                              : person.jobDetails.toString(),
                                                                          fontSize:
                                                                              16.sp,
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
                                                                          FontWeight
                                                                              .bold,
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
                                                                                'Completed',
                                                                                style: TextStyle(
                                                                                  fontSize: 16.sp,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                              actions: [
                                                                                /*  Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Text("Remark",style: TextStyle(
                                                                                fontSize: 16.sp,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),),
                                                                            ),
                                                                            Container(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  horizontal: 20.w, vertical: 4.h),
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.grey.shade200,
                                                                                borderRadius: BorderRadius.circular(50.r),
                                                                              ),
                                                                              child: TextFormField(
                                                                                keyboardType: TextInputType.text,
                                                                                // controller: controller.Emailid,
                                                                                decoration: InputDecoration(
                                                                                  hintText: "Remark ",
                                                                                  hintStyle: GoogleFonts.roboto(color: Colors.grey),
                                                                                  border: InputBorder.none,
                                                                                ),
                                                                              ),
                                                                            ),*/
                                                                                /*   Container(
                                                                                padding: EdgeInsets.symmetric(
                                                                                    horizontal: 20.w, vertical: 4.h),
                                                                                // alignment: Alignment.center,
                                                                                decoration: BoxDecoration(
                                                                                  // color: Colors.grey.shade200,
                                                                                  // borderRadius: BorderRadius.circular(50.r),
                                                                                ),
                                                                                child: Align(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Text("Status",style: TextStyle(
                                                                                      fontSize: 16.sp,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),))
                                                                            ),*/
                                                                                /* Spacer(),
                                                                            Container(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  horizontal: 20.w, vertical: 4.h),
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.grey.shade200,
                                                                                borderRadius: BorderRadius.circular(50.r),
                                                                              ),
                                                                              child: Obx(
                                                                                    () => DropdownButtonFormField<String>(
                                                                                  value: controller.jobStatus.value.isEmpty ? null : controller.jobStatus.value,
                                                                                  onChanged: (String? newValue) {
                                                                                    if (newValue != null) {
                                                                                      controller.jobStatus.value = newValue; // Update the RxString value
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
                                                                                  items: ["Pending", "Completed"]
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
                                                                              },
                                                                              child: const Text('Submit'),
                                                                            ),*/
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      child:
                                                                          CustomText(
                                                                        data: person.jobStatus ==
                                                                                null
                                                                            ? ""
                                                                            : person.jobStatus.toString(),
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                /*Divider(),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                CustomText(
                                                                  data: "Completed Date:",
                                                                  fontSize: 16.sp,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                                CustomText(
                                                                  data:person.completedate!,
                                                                  fontSize: 16.sp,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ],
                                                            ),*/
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
                                                                          "Assigned By ",
                                                                      fontSize:
                                                                          16.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    CustomText(
                                                                      data: person.createBy ==
                                                                              null
                                                                          ? ""
                                                                          : person
                                                                              .createBy
                                                                              .toString(),
                                                                      fontSize:
                                                                          16.sp,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Divider(),
                                                                person.jobImage !=
                                                                        null
                                                                    ? Align(
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            Icon(Icons.download),
                                                                            CustomText(
                                                                                data: "Download",
                                                                                color: CustomColor.blueColor),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    : SizedBox
                                                                        .shrink(),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
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
                                                margin: EdgeInsets.only(
                                                    right: 135.w),
                                                decoration: BoxDecoration(
                                                  color: CustomColor.blueColor,
                                                  borderRadius:
                                                      BorderRadius.only(
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
                                                        padding:
                                                            EdgeInsets.only(
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
                                                                    height:
                                                                        50.h,
                                                                    width:
                                                                        400.w,
                                                                    child:
                                                                        InkWell(
                                                                      onTap: () =>
                                                                          controller
                                                                              .selectFromDate(context),
                                                                      child: controller.formattedFromDate.value ==
                                                                              ""
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
                                                        height: 10.h,
                                                      ),
                                                      Row(
                                                        children: [
                                                          RichText(
                                                              text: TextSpan(
                                                                  text:
                                                                      "Date to",
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
                                                                  onTap: () =>
                                                                      controller
                                                                          .selectToDate(
                                                                              context),
                                                                  child: controller
                                                                              .formattedToDate
                                                                              .value ==
                                                                          ""
                                                                      ? Container(
                                                                          alignment: Alignment
                                                                              .centerLeft,
                                                                          height: 50
                                                                              .h,
                                                                          width:
                                                                              400,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
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
                                                                              color: Colors.white,
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
                                                                .datefilterapi();
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
                                                            data:
                                                                "Apply Filter",
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
                                                  BorderRadius.circular(30.r),
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
                                SingleChildScrollView(
                                  child: SizedBox(
                                    height: 545.h,
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
                                            size: 30,
                                          );
                                        },
                                        scrollableBuilder:
                                            (context, child, controller) {
                                          return Opacity(
                                            opacity: 1.0 -
                                                controller.value
                                                    .clamp(0.0, 1.0),
                                            child: child,
                                          );
                                        },
                                      ).call,
                                      onRefresh: () => Future.delayed(
                                          const Duration(milliseconds: 2),
                                          () async {
                                        await controller
                                            .updateDataListApiTodatfollowup();
                                      }),
                                      child: completedItems.isEmpty
                                          ? ListView.builder(
                                              // reverse: true,
                                              itemCount: 1,
                                              itemBuilder: (context, index) {
                                                return Center(
                                                  child: CustomText(
                                                      data: "Data not found"),
                                                );
                                              })
                                          : ListView.builder(
                                              // reverse: true,
                                              padding: EdgeInsets.zero,
                                              itemCount: completedItems.length,
                                              itemBuilder: (context, index) {
                                                String apiDate =
                                                    "${completedItems[index].completedate}";

                                                DateTime dateString =
                                                    DateTime.parse(apiDate);
                                                String completeddate =
                                                    DateFormat("dd MMM yyyy")
                                                        .format(dateString);

                                                return InkWell(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15.w,
                                                            vertical: 5.h),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15.w,
                                                            vertical: 8.h),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset:
                                                                const Offset(
                                                                    0, 4),
                                                            color: Colors.indigo
                                                                .shade100,
                                                            blurRadius: 5.r),
                                                        BoxShadow(
                                                            offset:
                                                                const Offset(
                                                                    0, -1),
                                                            color: Colors.indigo
                                                                .shade100,
                                                            blurRadius: 3.r),
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
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: CustomText(
                                                                data:
                                                                    "Job Details:",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16.sp,
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .date_range,
                                                                    size: 20,
                                                                  ),
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal: 10
                                                                            .w,
                                                                        vertical:
                                                                            3.h),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.r),
                                                                    ),
                                                                    child:
                                                                        CustomText(
                                                                      data: completedItems[index].createDate ==
                                                                              null
                                                                          ? ""
                                                                          : DateFormat('dd MMMM yyyy').format(DateTime.parse(completedItems[index]
                                                                              .createDate
                                                                              .toString())),
                                                                      fontSize:
                                                                          16.sp,
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
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child:
                                                                    CustomText(
                                                                  data: completedItems[index]
                                                                              .jobDetails ==
                                                                          null
                                                                      ? "Job remaining"
                                                                      : completedItems[
                                                                              index]
                                                                          .jobDetails
                                                                          .toString(),
                                                                  fontSize:
                                                                      16.sp,
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
                                                              data: "Status:",
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            CustomText(
                                                              data: completedItems[
                                                                              index]
                                                                          .jobStatus ==
                                                                      null
                                                                  ? ""
                                                                  : completedItems[
                                                                          index]
                                                                      .jobStatus
                                                                      .toString(),
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.green,
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
                                                                  "Completed Date:",
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            CustomText(
                                                              data:
                                                                  completeddate,
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                                                  "Assigned By ",
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            CustomText(
                                                              data: completedItems[
                                                                              index]
                                                                          .createBy ==
                                                                      null
                                                                  ? ""
                                                                  : completedItems[
                                                                          index]
                                                                      .createBy
                                                                      .toString(),
                                                              fontSize: 16.sp,
                                                            ),
                                                          ],
                                                        ),
                                                        Divider(),
                                                        completedItems[index]
                                                                    .jobImage !=
                                                                null
                                                            ? Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Icon(Icons
                                                                        .download),
                                                                    CustomText(
                                                                        data:
                                                                            "Download",
                                                                        color: CustomColor
                                                                            .blueColor),
                                                                  ],
                                                                ),
                                                              )
                                                            : SizedBox.shrink(),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
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
                                        controller
                                            .updateDataListApiTodatfollowup();
                                      },
                                      child: CustomText(data: "Retry"))
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
    );
  }
}
