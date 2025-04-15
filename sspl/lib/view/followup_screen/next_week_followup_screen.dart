import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:sspl/controllers/followup/next_week_followup_screen_controller.dart';
import 'package:sspl/infrastructure/routes/page_constants.dart';
import 'package:sspl/sevices/api_sevices/api_services.dart';
import 'package:sspl/sevices/models/followup_model/nextweek_followup_model.dart';
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

class NextWeekFollowupScreen extends GetView<NextWeekFollowupScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.amber,
        title: CustomText(
          data: "View Job",
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchPage<Data>(
                    items: controller.viewNextWeekFollowupDataList.value.data!,
                    searchLabel: 'Search Job',
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
                      String folloupDate =
                          DateFormat("dd MMM yyyy hh:mm a").format(dateString);
                      return InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutesName.followup_Screen_Details,
                              arguments: [
                                person.contactname == null
                                    ? ""
                                    : person.contactname.toString(),
                                person.courseName == null
                                    ? ""
                                    : person.courseName.toString(),
                                person.organizationname == null
                                    ? ""
                                    : person.toString(),
                                person.lMobile == null
                                    ? ""
                                    : person.lMobile.toString(),
                                person.lEmail == null
                                    ? ""
                                    : person.lEmail.toString(),
                                person.curruntAddrs == null
                                    ? ""
                                    : person.curruntAddrs.toString(),
                                person.orgAddress == null
                                    ? ""
                                    : person.orgAddress.toString(),
                                person.alternateMobile == null
                                    ? ""
                                    : person.alternateMobile.toString(),
                                person.alternateEmail == null
                                    ? ""
                                    : person.alternateEmail.toString(),
                                person.updatedate == null
                                    ? ""
                                    : person.updatedate.toString(),
                                person.lRemarks == null
                                    ? ""
                                    : person.lRemarks.toString(),
                                person.lSubstatus == null
                                    ? ""
                                    : person.lSubstatus.toString(),
                                person.leadsId == null
                                    ? ""
                                    : person.leadsId.toString(),
                                person.lAction == null
                                    ? ""
                                    : person.lAction.toString(),
                              ]);
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 10.h),
                            margin: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 8.h),
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
                            child: Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    data: "Action Type:   ",
                                    fontSize: 15.sp,
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
                              SizedBox(
                                height: 10.h,
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
                                    data: person.organizationname == null
                                        ? ""
                                        : person.organizationname.toString(),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    data: "Visit Type:",
                                    fontSize: 15.sp,
                                  ),
                                  CustomText(
                                    data: person.courseName == null
                                        ? ""
                                        : person.courseName.toString(),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    data: "Mobile Number:",
                                    fontSize: 15.sp,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              data: "Alternate Number:",
                                              fontSize: 15.sp,
                                            ),
                                            Row(
                                              children: [
                                                CustomText(
                                                  data:
                                                      person.alternateMobile ==
                                                              null
                                                          ? ""
                                                          : person
                                                              .alternateMobile
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
                                                    width: 35.w,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.only(
                                                        left: 10.w),
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                              person.lEmail == ""
                                  ? SizedBox()
                                  : person.lEmail == null
                                      ? SizedBox()
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              data: "Email:",
                                              fontSize: 15.sp,
                                            ),
                                            Row(
                                              children: [
                                                CustomText(
                                                  data: person.lEmail == null
                                                      ? ""
                                                      : person.lEmail
                                                          .toString(),
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                // InkWell(
                                                //   onTap: () async {
                                                //     String email =
                                                //         Uri.encodeComponent(controller.lEmail.value);
                                                //     Uri mail = Uri.parse("mailto:$email?");
                                                //     if (await launchUrl(mail)) {
                                                //     } else {
                                                //       ShortMessage.toast(title: "Something went wrong");
                                                //     }
                                                //   },
                                                //   child: Container(
                                                //     height: 30.h,
                                                //     width: 40.w,
                                                //     margin: EdgeInsets.only(left: 10.w),
                                                //     padding: EdgeInsets.symmetric(
                                                //         horizontal: 5.w, vertical: 5.h),
                                                //     decoration: BoxDecoration(
                                                //       gradient: LinearGradient(
                                                //         colors: [CustomColor.blueColor, Color(0xFFd21e2b)],
                                                //         begin: Alignment.topLeft,
                                                //         end: Alignment.topRight,
                                                //       ),
                                                //       borderRadius: BorderRadius.circular(10.r),
                                                //     ),
                                                //     child: Icon(
                                                //       Icons.email_outlined,
                                                //       color: Colors.white,
                                                //       size: 24.r,
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    data: "Address:",
                                    fontSize: 15.sp,
                                  ),
                                  CustomText(
                                    data: person.orgAddress == null
                                        ? ""
                                        : person.orgAddress.toString(),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    data: "Last Activity:",
                                    fontSize: 15.sp,
                                  ),
                                  CustomText(
                                    data: folloupDate,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ])),
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
              return const Center(
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
                child: controller
                            .viewNextWeekFollowupDataList.value.data?.length ==
                        null
                    ? ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Center(
                            child: CustomText(data: "Data not found"),
                          );
                        })
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: controller
                            .viewNextWeekFollowupDataList.value.data?.length,
                        itemBuilder: (context, index) {
                          String apiDate =
                              "${controller.viewNextWeekFollowupDataList.value.data![index].updatedate}";

                          DateTime dateString = DateTime.parse(apiDate);
                          String folloupDate = DateFormat("dd MMM yyyy hh:mm a")
                              .format(dateString);
                          String apiDate1 =
                              "${controller.viewNextWeekFollowupDataList.value.data![index].lFollowupdate}";

                          DateTime dateString1 = DateTime.parse(apiDate1);
                          String visitDate =
                              DateFormat("dd MMM yyyy").format(dateString1);

                          return InkWell(
                            onTap: () {
                              Get.toNamed(AppRoutesName.followup_Screen_Details,
                                  arguments: [
                                    controller
                                                .viewNextWeekFollowupDataList
                                                .value
                                                .data?[index]
                                                .contactname ==
                                            null
                                        ? ""
                                        : controller
                                            .viewNextWeekFollowupDataList
                                            .value
                                            .data![index]
                                            .contactname
                                            .toString(),
                                    controller
                                                .viewNextWeekFollowupDataList
                                                .value
                                                .data?[index]
                                                .courseName ==
                                            null
                                        ? ""
                                        : controller
                                            .viewNextWeekFollowupDataList
                                            .value
                                            .data![index]
                                            .courseName
                                            .toString(),
                                    controller
                                                .viewNextWeekFollowupDataList
                                                .value
                                                .data?[index]
                                                .organizationname ==
                                            null
                                        ? ""
                                        : controller
                                            .viewNextWeekFollowupDataList
                                            .value
                                            .data![index]
                                            .organizationname
                                            .toString(),
                                    controller.viewNextWeekFollowupDataList
                                                .value.data?[index].lMobile ==
                                            null
                                        ? ""
                                        : controller
                                            .viewNextWeekFollowupDataList
                                            .value
                                            .data![index]
                                            .lMobile
                                            .toString(),
                                    controller.viewNextWeekFollowupDataList
                                                .value.data?[index].lEmail ==
                                            null
                                        ? ""
                                        : controller
                                            .viewNextWeekFollowupDataList
                                            .value
                                            .data![index]
                                            .lEmail
                                            .toString(),
                                    controller
                                                .viewNextWeekFollowupDataList
                                                .value
                                                .data?[index]
                                                .curruntAddrs ==
                                            null
                                        ? ""
                                        : controller
                                            .viewNextWeekFollowupDataList
                                            .value
                                            .data![index]
                                            .curruntAddrs
                                            .toString(),
                                    controller
                                                .viewNextWeekFollowupDataList
                                                .value
                                                .data?[index]
                                                .orgAddress ==
                                            null
                                        ? ""
                                        : controller
                                            .viewNextWeekFollowupDataList
                                            .value
                                            .data![index]
                                            .orgAddress
                                            .toString(),
                                    controller
                                                .viewNextWeekFollowupDataList
                                                .value
                                                .data?[index]
                                                .alternateMobile ==
                                            null
                                        ? ""
                                        : controller
                                            .viewNextWeekFollowupDataList
                                            .value
                                            .data![index]
                                            .alternateMobile
                                            .toString(),
                                    controller
                                                .viewNextWeekFollowupDataList
                                                .value
                                                .data?[index]
                                                .alternateEmail ==
                                            null
                                        ? ""
                                        : controller
                                            .viewNextWeekFollowupDataList
                                            .value
                                            .data![index]
                                            .alternateEmail
                                            .toString(),
                                    controller
                                                .viewNextWeekFollowupDataList
                                                .value
                                                .data?[index]
                                                .updatedate ==
                                            null
                                        ? ""
                                        : controller
                                            .viewNextWeekFollowupDataList
                                            .value
                                            .data![index]
                                            .updatedate
                                            .toString(),
                                    controller.viewNextWeekFollowupDataList
                                                .value.data?[index].lRemarks ==
                                            null
                                        ? ""
                                        : controller
                                            .viewNextWeekFollowupDataList
                                            .value
                                            .data![index]
                                            .lRemarks
                                            .toString(),
                                    controller
                                                .viewNextWeekFollowupDataList
                                                .value
                                                .data?[index]
                                                .lSubstatus ==
                                            null
                                        ? ""
                                        : controller
                                            .viewNextWeekFollowupDataList
                                            .value
                                            .data![index]
                                            .lSubstatus
                                            .toString(),
                                    controller.viewNextWeekFollowupDataList
                                                .value.data?[index].leadsId ==
                                            null
                                        ? ""
                                        : controller
                                            .viewNextWeekFollowupDataList
                                            .value
                                            .data![index]
                                            .leadsId
                                            .toString(),
                                    controller.viewNextWeekFollowupDataList
                                                .value.data?[index].lAction ==
                                            null
                                        ? ""
                                        : controller
                                            .viewNextWeekFollowupDataList
                                            .value
                                            .data![index]
                                            .lAction
                                            .toString(),
                                  ]);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 5.h),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 8.h),
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
                                                      .viewNextWeekFollowupDataList
                                                      .value
                                                      .data?[index]
                                                      .contactname ==
                                                  null
                                              ? ""
                                              : controller
                                                  .viewNextWeekFollowupDataList
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
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        data: "Action Type:   ",
                                        fontSize: 15.sp,
                                        color: Colors.green,
                                      ),
                                      CustomText(
                                        data: controller
                                                    .viewNextWeekFollowupDataList
                                                    .value
                                                    .data?[index]
                                                    .lAction ==
                                                null
                                            ? ""
                                            : controller
                                                .viewNextWeekFollowupDataList
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        data: "Organization:",
                                        fontSize: 15.sp,
                                      ),
                                      CustomText(
                                        data: controller
                                                    .viewNextWeekFollowupDataList
                                                    .value
                                                    .data?[index]
                                                    .organizationname ==
                                                null
                                            ? ""
                                            : controller
                                                .viewNextWeekFollowupDataList
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        data: "Visit Type:",
                                        fontSize: 15.sp,
                                      ),
                                      CustomText(
                                        data: controller
                                                    .viewNextWeekFollowupDataList
                                                    .value
                                                    .data?[index]
                                                    .courseName ==
                                                null
                                            ? ""
                                            : controller
                                                .viewNextWeekFollowupDataList
                                                .value
                                                .data![index]
                                                .courseName
                                                .toString(),
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        data: "Mobile Number:",
                                        fontSize: 15.sp,
                                      ),
                                      Row(
                                        children: [
                                          CustomText(
                                            data: controller
                                                        .viewNextWeekFollowupDataList
                                                        .value
                                                        .data?[index]
                                                        .lMobile ==
                                                    null
                                                ? ""
                                                : controller
                                                    .viewNextWeekFollowupDataList
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
                                                  "tel://${controller.viewNextWeekFollowupDataList.value.data?[index].lMobile == null ? "" : controller.viewNextWeekFollowupDataList.value.data![index].lMobile.toString()}");
                                            },
                                            child: Container(
                                              height: 25.h,
                                              width: 34.w,
                                              alignment: Alignment.center,
                                              margin:
                                                  EdgeInsets.only(left: 10.w),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.w,
                                                  vertical: 5.h),
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
                                  controller.viewNextWeekFollowupDataList.value
                                              .data?[index].alternateMobile ==
                                          ""
                                      ? SizedBox()
                                      : controller
                                                  .viewNextWeekFollowupDataList
                                                  .value
                                                  .data?[index]
                                                  .alternateMobile ==
                                              null
                                          ? SizedBox()
                                          : Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CustomText(
                                                  data: "Alternate Number:",
                                                  fontSize: 15.sp,
                                                ),
                                                Row(
                                                  children: [
                                                    CustomText(
                                                      data: controller
                                                                  .viewNextWeekFollowupDataList
                                                                  .value
                                                                  .data?[index]
                                                                  .alternateMobile ==
                                                              null
                                                          ? ""
                                                          : controller
                                                              .viewNextWeekFollowupDataList
                                                              .value
                                                              .data![index]
                                                              .alternateMobile
                                                              .toString(),
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        launch(
                                                            "tel://${controller.viewNextWeekFollowupDataList.value.data?[index].alternateMobile == null ? "" : controller.viewNextWeekFollowupDataList.value.data![index].alternateMobile.toString()}");
                                                      },
                                                      child: Container(
                                                        height: 25.h,
                                                        width: 34.w,
                                                        alignment:
                                                            Alignment.center,
                                                        margin: EdgeInsets.only(
                                                            left: 10.w),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5.w,
                                                                vertical: 5.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: CustomColor
                                                              .blueColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                                  controller.viewNextWeekFollowupDataList.value
                                              .data?[index].lEmail ==
                                          ""
                                      ? SizedBox()
                                      : controller.viewNextWeekFollowupDataList
                                                  .value.data?[index].lEmail ==
                                              null
                                          ? SizedBox()
                                          : Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CustomText(
                                                  data: "Email:",
                                                  fontSize: 15.sp,
                                                ),
                                                Row(
                                                  children: [
                                                    CustomText(
                                                      data: controller
                                                                  .viewNextWeekFollowupDataList
                                                                  .value
                                                                  .data?[index]
                                                                  .lEmail ==
                                                              null
                                                          ? ""
                                                          : controller
                                                              .viewNextWeekFollowupDataList
                                                              .value
                                                              .data![index]
                                                              .lEmail
                                                              .toString(),
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    // InkWell(
                                                    //   onTap: () async {
                                                    //     String email =
                                                    //         Uri.encodeComponent(controller.lEmail.value);
                                                    //     Uri mail = Uri.parse("mailto:$email?");
                                                    //     if (await launchUrl(mail)) {
                                                    //     } else {
                                                    //       ShortMessage.toast(title: "Something went wrong");
                                                    //     }
                                                    //   },
                                                    //   child: Container(
                                                    //     height: 30.h,
                                                    //     width: 40.w,
                                                    //     margin: EdgeInsets.only(left: 10.w),
                                                    //     padding: EdgeInsets.symmetric(
                                                    //         horizontal: 5.w, vertical: 5.h),
                                                    //     decoration: BoxDecoration(
                                                    //       gradient: LinearGradient(
                                                    //         colors: [CustomColor.blueColor, Color(0xFFd21e2b)],
                                                    //         begin: Alignment.topLeft,
                                                    //         end: Alignment.topRight,
                                                    //       ),
                                                    //       borderRadius: BorderRadius.circular(10.r),
                                                    //     ),
                                                    //     child: Icon(
                                                    //       Icons.email_outlined,
                                                    //       color: Colors.white,
                                                    //       size: 24.r,
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        data: "Address:",
                                        fontSize: 15.sp,
                                      ),
                                      CustomText(
                                        data: controller
                                                    .viewNextWeekFollowupDataList
                                                    .value
                                                    .data?[index]
                                                    .orgAddress ==
                                                null
                                            ? ""
                                            : controller
                                                .viewNextWeekFollowupDataList
                                                .value
                                                .data![index]
                                                .orgAddress
                                                .toString(),
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        data: " Next Visit Date:",
                                        fontSize: 15.sp,
                                      ),
                                      CustomText(
                                        data: visitDate,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        data: "Last Activity:",
                                        fontSize: 15.sp,
                                      ),
                                      CustomText(
                                        data: folloupDate,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
