import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:sspl/controllers/followup/today_complete_followup_screen_controller.dart';
import 'package:sspl/sevices/api_sevices/api_services.dart';
import 'package:sspl/sevices/models/followup_model/today_complete_followup_model.dart';
import 'package:sspl/utilities/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:search_page/search_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utilities/custom_color/custom_color.dart';

class TodayCompleteFollowupScreen
    extends GetView<TodayCompleteFollowupController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.amber,
        title: CustomText(
          data: "Today Complete Followup",
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchPage<Data>(
                    items: controller
                        .todayconplateFollowupdetailsDataList.value.data!,
                    searchLabel: 'Search Followup',
                    suggestion: Center(
                      child: AutoSizeText(
                        'Search by Organization & Name',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    failure: Center(
                      child: AutoSizeText(
                        'Data not found :(',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    filter: (person) =>
                        [person.organizationname, person.contactname],
                    builder: (person) {
                      String apiDate = "${person.updatedate}";

                      DateTime dateString = DateTime.parse(apiDate);
                      String visitDate =
                          DateFormat("dd MMM yyyy hh:mm a").format(dateString);
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(00, 4),
                                color: Colors.indigo.shade100,
                                blurRadius: 5.r),
                            BoxShadow(
                                offset: Offset(00, -1),
                                color: Colors.indigo.shade100,
                                blurRadius: 3.r),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  data: "Action Type:  ",
                                  fontSize: 16.sp,
                                  color: Colors.green,
                                ),
                                CustomText(
                                  data: person.lAction == null
                                      ? ""
                                      : person.lAction.toString(),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: CustomColor.blueColor,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: CustomText(
                                    data: person.contactname == null
                                        ? ""
                                        : person.contactname.toString(),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomText(
                                  data: "Visit Date",
                                  fontSize: 16.sp,
                                ),
                                CustomText(
                                  data: visitDate,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  data: "Organization:",
                                  fontSize: 15.sp,
                                ),
                                CustomText(
                                  data: person.organizationname == null
                                      ? ""
                                      : person.organizationname.toString(),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  data: "Visit Type:",
                                  fontSize: 16.sp,
                                ),
                                SizedBox(
                                  width: 100.w,
                                ),
                                Expanded(
                                  child: CustomText(
                                    data: person.courseName == null
                                        ? ""
                                        : person.courseName.toString(),
                                    textAlign: TextAlign.right,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            person.lEmail == ""
                                ? SizedBox()
                                : person.lEmail == null
                                    ? SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            data: "Email:",
                                            fontSize: 16.sp,
                                          ),
                                          SizedBox(
                                            width: 100.w,
                                          ),
                                          Expanded(
                                            child: CustomText(
                                              data: person.lEmail == null
                                                  ? ""
                                                  : person.lEmail.toString(),
                                              textAlign: TextAlign.right,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  data: "Mobile Number:",
                                  fontSize: 16.sp,
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      data: person.lMobile == null
                                          ? ""
                                          : person.lMobile.toString(),
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        launch(
                                            "tel://${person.lMobile == null ? "" : person.lMobile.toString()}");
                                      },
                                      child: Container(
                                        height: 25.h,
                                        width: 34.w,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(left: 10.w),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w, vertical: 5.h),
                                        decoration: BoxDecoration(
                                          color: CustomColor.blueColor,
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: Icon(
                                          Icons.phone,
                                          color: Colors.white,
                                          size: 20.r,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            person.alternateMobile == ""
                                ? SizedBox()
                                : person.alternateMobile == null
                                    ? SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            data: "Alternate Number:",
                                            fontSize: 16.sp,
                                          ),
                                          Row(
                                            children: [
                                              CustomText(
                                                data: person.alternateMobile ==
                                                        null
                                                    ? ""
                                                    : person.alternateMobile
                                                        .toString(),
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  launch(
                                                      "tel://${person.alternateMobile == null ? "" : person.alternateMobile.toString()}");
                                                },
                                                child: Container(
                                                  height: 25.h,
                                                  width: 34.w,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      left: 10.w),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5.w,
                                                      vertical: 5.h),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        CustomColor.blueColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                  ),
                                                  child: Icon(
                                                    Icons.phone,
                                                    color: Colors.white,
                                                    size: 20.r,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  data: "Visit Address:",
                                  fontSize: 16.sp,
                                ),
                                SizedBox(
                                  width: 100.w,
                                ),
                                Expanded(
                                  child: CustomText(
                                    data: person.orgAddress == null
                                        ? ""
                                        : person.orgAddress.toString(),
                                    textAlign: TextAlign.right,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  data: "Remarks:",
                                  fontSize: 16.sp,
                                ),
                                SizedBox(
                                  width: 100.w,
                                ),
                                Expanded(
                                  child: CustomText(
                                    data: person.lRemarks == null
                                        ? ""
                                        : person.lRemarks.toString(),
                                    textAlign: TextAlign.right,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: CustomColor.blueColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () {
          switch (controller.rxRequestStatus.value) {
            case Status.Loading:
              return Center(
                child: CircularProgressIndicator(),
              );
            case Status.Complete:
              return CustomRefreshIndicator(
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
                child: controller.todayconplateFollowupdetailsDataList.value
                            .data?.length ==
                        null
                    ? ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Center(
                              child: CustomText(data: "Data not found"));
                        })
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: controller
                            .todayconplateFollowupdetailsDataList
                            .value
                            .data
                            ?.length,
                        itemBuilder: (context, index) {
                          String apiDate =
                              "${controller.todayconplateFollowupdetailsDataList.value.data![index].updatedate}";

                          DateTime dateString = DateTime.parse(apiDate);
                          String visitDate = DateFormat("dd MMM yyyy hh:mm a")
                              .format(dateString);
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 8.h),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(00, 4),
                                    color: Colors.indigo.shade100,
                                    blurRadius: 5.r),
                                BoxShadow(
                                    offset: Offset(00, -1),
                                    color: Colors.indigo.shade100,
                                    blurRadius: 3.r),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      data: "Action Type:  ",
                                      fontSize: 16.sp,
                                      color: Colors.green,
                                    ),
                                    CustomText(
                                      data: controller
                                                  .todayconplateFollowupdetailsDataList
                                                  .value
                                                  .data?[index]
                                                  .lAction ==
                                              null
                                          ? ""
                                          : controller
                                              .todayconplateFollowupdetailsDataList
                                              .value
                                              .data![index]
                                              .lAction
                                              .toString(),
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 3.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: CustomColor.blueColor,
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: CustomText(
                                        data: controller
                                                    .todayconplateFollowupdetailsDataList
                                                    .value
                                                    .data?[index]
                                                    .contactname ==
                                                null
                                            ? ""
                                            : controller
                                                .todayconplateFollowupdetailsDataList
                                                .value
                                                .data![index]
                                                .contactname
                                                .toString(),
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      data: "Visit Date",
                                      fontSize: 16.sp,
                                    ),
                                    CustomText(
                                      data: visitDate,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      data: "Organization:",
                                      fontSize: 15.sp,
                                    ),
                                    CustomText(
                                      data: controller
                                                  .todayconplateFollowupdetailsDataList
                                                  .value
                                                  .data?[index]
                                                  .organizationname ==
                                              null
                                          ? ""
                                          : controller
                                              .todayconplateFollowupdetailsDataList
                                              .value
                                              .data![index]
                                              .organizationname
                                              .toString(),
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      data: "Visit Type:",
                                      fontSize: 16.sp,
                                    ),
                                    SizedBox(
                                      width: 100.w,
                                    ),
                                    Expanded(
                                      child: CustomText(
                                        data: controller
                                                    .todayconplateFollowupdetailsDataList
                                                    .value
                                                    .data?[index]
                                                    .courseName ==
                                                null
                                            ? ""
                                            : controller
                                                .todayconplateFollowupdetailsDataList
                                                .value
                                                .data![index]
                                                .courseName
                                                .toString(),
                                        textAlign: TextAlign.right,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                controller.todayconplateFollowupdetailsDataList
                                            .value.data?[index].lEmail ==
                                        ""
                                    ? SizedBox()
                                    : controller.todayconplateFollowupdetailsDataList
                                                .value.data?[index].lEmail ==
                                            null
                                        ? SizedBox()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                data: "Email:",
                                                fontSize: 16.sp,
                                              ),
                                              SizedBox(
                                                width: 100.w,
                                              ),
                                              Expanded(
                                                child: CustomText(
                                                  data: controller
                                                              .todayconplateFollowupdetailsDataList
                                                              .value
                                                              .data?[index]
                                                              .lEmail ==
                                                          null
                                                      ? ""
                                                      : controller
                                                          .todayconplateFollowupdetailsDataList
                                                          .value
                                                          .data![index]
                                                          .lEmail
                                                          .toString(),
                                                  textAlign: TextAlign.right,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      data: "Mobile Number:",
                                      fontSize: 16.sp,
                                    ),
                                    Row(
                                      children: [
                                        CustomText(
                                          data: controller
                                                      .todayconplateFollowupdetailsDataList
                                                      .value
                                                      .data?[index]
                                                      .lMobile ==
                                                  null
                                              ? ""
                                              : controller
                                                  .todayconplateFollowupdetailsDataList
                                                  .value
                                                  .data![index]
                                                  .lMobile
                                                  .toString(),
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            launch(
                                                "tel://${controller.todayconplateFollowupdetailsDataList.value.data?[index].lMobile == null ? "" : controller.todayconplateFollowupdetailsDataList.value.data![index].lMobile.toString()}");
                                          },
                                          child: Container(
                                            height: 25.h,
                                            width: 34.w,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(left: 10.w),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w, vertical: 5.h),
                                            decoration: BoxDecoration(
                                              color: CustomColor.blueColor,
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: Icon(
                                              Icons.phone,
                                              color: Colors.white,
                                              size: 20.r,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                controller
                                            .todayconplateFollowupdetailsDataList
                                            .value
                                            .data?[index]
                                            .alternateMobile ==
                                        ""
                                    ? SizedBox()
                                    : controller
                                                .todayconplateFollowupdetailsDataList
                                                .value
                                                .data?[index]
                                                .alternateMobile ==
                                            null
                                        ? SizedBox()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                data: "Alternate Number:",
                                                fontSize: 16.sp,
                                              ),
                                              Row(
                                                children: [
                                                  CustomText(
                                                    data: controller
                                                                .todayconplateFollowupdetailsDataList
                                                                .value
                                                                .data?[index]
                                                                .alternateMobile ==
                                                            null
                                                        ? ""
                                                        : controller
                                                            .todayconplateFollowupdetailsDataList
                                                            .value
                                                            .data![index]
                                                            .alternateMobile
                                                            .toString(),
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      launch(
                                                          "tel://${controller.todayconplateFollowupdetailsDataList.value.data?[index].alternateMobile == null ? "" : controller.todayconplateFollowupdetailsDataList.value.data![index].alternateMobile.toString()}");
                                                    },
                                                    child: Container(
                                                      height: 25.h,
                                                      width: 34.w,
                                                      alignment:
                                                          Alignment.center,
                                                      margin: EdgeInsets.only(
                                                          left: 10.w),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.w,
                                                              vertical: 5.h),
                                                      decoration: BoxDecoration(
                                                        color: CustomColor
                                                            .blueColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                      ),
                                                      child: Icon(
                                                        Icons.phone,
                                                        color: Colors.white,
                                                        size: 20.r,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      data: "Visit Address:",
                                      fontSize: 16.sp,
                                    ),
                                    SizedBox(
                                      width: 100.w,
                                    ),
                                    Expanded(
                                      child: CustomText(
                                        data: controller
                                                    .todayconplateFollowupdetailsDataList
                                                    .value
                                                    .data?[index]
                                                    .orgAddress ==
                                                null
                                            ? ""
                                            : controller
                                                .todayconplateFollowupdetailsDataList
                                                .value
                                                .data![index]
                                                .orgAddress
                                                .toString(),
                                        textAlign: TextAlign.right,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      data: "Remarks:",
                                      fontSize: 16.sp,
                                    ),
                                    SizedBox(
                                      width: 100.w,
                                    ),
                                    Expanded(
                                      child: CustomText(
                                        data: controller
                                                    .todayconplateFollowupdetailsDataList
                                                    .value
                                                    .data?[index]
                                                    .lRemarks ==
                                                null
                                            ? ""
                                            : controller
                                                .todayconplateFollowupdetailsDataList
                                                .value
                                                .data![index]
                                                .lRemarks
                                                .toString(),
                                        textAlign: TextAlign.right,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
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
      ),
    );
  }
}
