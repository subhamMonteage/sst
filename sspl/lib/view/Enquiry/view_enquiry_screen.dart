import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:search_page/search_page.dart';
import 'package:sspl/utilities/custom_color/custom_color.dart';

import '../../controllers/EnquiryScreenController/EnquiryScreenController.dart';
import '../../controllers/expense/all_expenses_screen_controller.dart';
import '../../infrastructure/image_constants/image_constants.dart';
import '../../infrastructure/routes/page_constants.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../sevices/models/enquiry/enquiry_model.dart';
import '../../sevices/repo/repo.dart';
import '../../utilities/custom_text/custom_text.dart';
import '../../utilities/custom_toast/custom_toast.dart';

class ViewEnquiryScreen extends GetView<EnquiryController> {
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
              padding: EdgeInsets.symmetric(),
              margin: EdgeInsets.symmetric(),
              decoration: const BoxDecoration(
                //borderRadius: BorderRadius.circular(6.r),
                color: CustomColor.blueColor,
              ),
              child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(vertical: 3.h),
                margin: EdgeInsets.symmetric(
                  horizontal: 10.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: CustomColor.blueColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      data: "View Enquiry",
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutesName.Enquiry_day);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 3.h, horizontal: 10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: CustomColor.blueColor,
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.add,
                              color: Colors.white,
                              size: 30.r,
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              "Add Enquiry",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Obx(
            () {
              switch (controller.rxRequestStatus.value) {
                case Status.Loading:
                  return Center(
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
                                  delegate: SearchPage<ViewEnquiryModelData>(
                                      items: controller
                                              .viewEnquiryList.value.data ??
                                          [],
                                      searchLabel: 'Enquiry',
                                      suggestion: Center(
                                        child: AutoSizeText(
                                          'Filter Enquiry by any field',
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
                                            person.contactPerson,
                                            person.cityName,
                                            person.createBy,
                                            person.emailId,
                                            person.contactNo,
                                            person.enquiryDetails,
                                            person.customerName,
                                            person.date,
                                            person.createdDate,
                                          ],
                                      builder: (person) {
                                        return Container(
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
                                                color: Colors.blue.shade900,
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
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .blueColor,
                                                            maxRadius: 15.r,
                                                            child: Icon(
                                                                Icons
                                                                    .supervised_user_circle_outlined,
                                                                color: Colors
                                                                    .white,
                                                                size: 20.r),
                                                          ),
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                          Column(
                                                            children: [
                                                              CustomText(
                                                                data: person.contactPerson ==
                                                                        null
                                                                    ? ""
                                                                    : person
                                                                        .contactPerson
                                                                        .toString(),
                                                                //fontWeight: FontWeight.w500,
                                                                fontSize: 15.sp,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Row(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .blueColor,
                                                            maxRadius: 15.r,
                                                            child: Icon(
                                                                Icons
                                                                    .supervised_user_circle_outlined,
                                                                color: Colors
                                                                    .white,
                                                                size: 20.r),
                                                          ),
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                          Column(
                                                            children: [
                                                              CustomText(
                                                                data: person.contactPerson ==
                                                                        null
                                                                    ? ""
                                                                    : person
                                                                        .contactPerson
                                                                        .toString(),
                                                                //fontWeight: FontWeight.w500,
                                                                fontSize: 15.sp,
                                                              ),
                                                            ],
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
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .calendar_month_outlined,
                                                            size: 20.r,
                                                          ),
                                                          CustomText(
                                                            data:
                                                                " ${person.createDate}",
                                                            fontSize: 14.sp,
                                                            //fontWeight: FontWeight.w500,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5.h),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            CupertinoIcons
                                                                .clock_fill,
                                                            size: 20.r,
                                                          ),
                                                          CustomText(
                                                            data:
                                                                " ${person.createDate}",
                                                            fontSize: 14.sp,
                                                            //fontWeight: FontWeight.w500,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5.h),
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        CustomColor.blueColor,
                                                    maxRadius: 15.r,
                                                    child: Icon(Icons.mail,
                                                        color: Colors.white,
                                                        size: 20.r),
                                                  ),
                                                  CustomText(
                                                    data:
                                                        "  ${person.emailId == null ? "" : person.emailId.toString()}",
                                                    //fontWeight: FontWeight.w500,
                                                    fontSize: 15.sp,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        CustomColor.blueColor,
                                                    maxRadius: 15.r,
                                                    child: Icon(
                                                        Icons.phone_android,
                                                        color: Colors.white,
                                                        size: 20.r),
                                                  ),
                                                  CustomText(
                                                    data:
                                                        "  ${person.contactNo == null ? "" : person.contactNo.toString()}",
                                                    //fontWeight: FontWeight.w500,
                                                    fontSize: 15.sp,
                                                  ),
                                                ],
                                              ),
                                              person.contactNo == null
                                                  ? const SizedBox()
                                                  : const Divider(
                                                      thickness: 1,
                                                      color: Colors.black,
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
                                  borderRadius: BorderRadius.circular(10.r),
                                  // border: Border.all(
                                  //   color: Colors.black,
                                  // ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50.h,
                                      width: 50.w,
                                      margin: EdgeInsets.only(right: 135.w),
                                      decoration: BoxDecoration(
                                        color: CustomColor.blueColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.r),
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
                                  decoration:
                                      BoxDecoration(color: Colors.white),
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
                                              MainAxisAlignment.spaceBetween,
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
                                                  CupertinoIcons.multiply,
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
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 18.sp,
                                                        color: Colors.black),
                                                    children: [
                                                      TextSpan(
                                                        text: "*",
                                                        style:
                                                            GoogleFonts.roboto(
                                                                fontSize: 20.sp,
                                                                color:
                                                                    Colors.red),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Obx(() {
                                              return Padding(
                                                padding: EdgeInsets.only(
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
                                                          child: InkWell(
                                                            onTap: () => controller
                                                                .selectFromDate(
                                                                    context),
                                                            child: controller
                                                                        .formattedFromDate
                                                                        .value ==
                                                                    ""
                                                                ? Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    height:
                                                                        50.h,
                                                                    width: 400,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10
                                                                                .r),
                                                                        border: Border.all(
                                                                            width:
                                                                                0.5.w)),
                                                                    child:
                                                                        CustomText(
                                                                      data:
                                                                          '   Select From Date',
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    height:
                                                                        50.h,
                                                                    width: 400,
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10
                                                                                .r),
                                                                        border: Border.all(
                                                                            width:
                                                                                0.5.w)),
                                                                    child:
                                                                        CustomText(
                                                                      data:
                                                                          '  ${controller.formattedFromDate.value}',
                                                                      // Display the formatted date

                                                                      fontSize:
                                                                          14,
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
                                                        style:
                                                            GoogleFonts.roboto(
                                                                fontSize: 18.sp,
                                                                color: Colors
                                                                    .black),
                                                        children: [
                                                      TextSpan(
                                                        text: "*",
                                                        style:
                                                            GoogleFonts.roboto(
                                                                fontSize: 20.sp,
                                                                color:
                                                                    Colors.red),
                                                      )
                                                    ])),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Obx(() {
                                              return Padding(
                                                padding: EdgeInsets.only(
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
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: 50.h,
                                                                width: 400,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(10
                                                                            .r),
                                                                    border: Border.all(
                                                                        width: 0.5
                                                                            .w)),
                                                                child: CustomText(
                                                                    data:
                                                                        '   Select To Date'))
                                                            : Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: 50.h,
                                                                width: 400,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(10
                                                                            .r),
                                                                    border: Border.all(
                                                                        width: 0.5
                                                                            .w)),
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
                                                if (controller.formattedFromDate
                                                            .value !=
                                                        "" &&
                                                    controller.formattedToDate
                                                            .value !=
                                                        "") {
                                                  // controller.searchByDateApi();
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
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color:
                                                        CustomColor.blueColor),
                                                child: CustomText(
                                                  data: "Apply Filter",
                                                  fontSize: 18.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
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
                                    borderRadius: BorderRadius.circular(30.r),
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
                      SizedBox(
                        height: 620.h,
                        child: Expanded(
                          child: CustomRefreshIndicator(
                            leadingScrollIndicatorVisible: true,
                            trailingScrollIndicatorVisible: true,
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
                                  opacity:
                                      1.0 - controller.value.clamp(0.0, 1.0),
                                  child: child,
                                );
                              },
                            ).call,
                            onRefresh: () => Future.delayed(
                                Duration(milliseconds: 2), () async {
                              await controller.viewEnquiry();
                            }),
                            child: controller
                                        .viewEnquiryList.value.data?.length ==
                                    null
                                ? CustomText(data: "Data not found")
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: controller
                                        .viewEnquiryList.value.data?.length,
                                    itemBuilder: (context, index) {
                                      int reverseIndex = controller
                                              .viewEnquiryList
                                              .value
                                              .data!
                                              .length -
                                          1 -
                                          index;
                                      String apiDate =
                                          "${controller.viewEnquiryList.value.data![reverseIndex].createDate}"; // Replace this with the date from your API
                                      DateTime dateString =
                                          DateTime.parse(apiDate);

                                      String formattedDate =
                                          DateFormat("dd/MM/yyyy")
                                              .format(dateString);
                                      String formattedTime =
                                          DateFormat("HH:mm a")
                                              .format(dateString);
                                      return Container(
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
                                              color: Colors.blue.shade900,
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
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .blueColor,
                                                            maxRadius: 15.r,
                                                            child: Icon(
                                                              Icons
                                                                  .supervised_user_circle_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size: 20.r,
                                                            ),
                                                          ),
                                                          SizedBox(width: 10.w),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CustomText(
                                                                data: controller
                                                                            .viewEnquiryList
                                                                            .value
                                                                            .data?[
                                                                                reverseIndex]
                                                                            .contactPerson ==
                                                                        null
                                                                    ? ""
                                                                    : controller
                                                                        .viewEnquiryList
                                                                        .value
                                                                        .data![
                                                                            reverseIndex]
                                                                        .contactPerson
                                                                        .toString(),
                                                                fontSize: 15.sp,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5.h),
                                                      Row(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .blueColor,
                                                            maxRadius: 15.r,
                                                            child: Icon(
                                                                Icons.mail,
                                                                color: Colors
                                                                    .white,
                                                                size: 20.r),
                                                          ),
                                                          CustomText(
                                                            data:
                                                                "  ${controller.viewEnquiryList.value.data?[reverseIndex].emailId == null ? "" : controller.viewEnquiryList.value.data![reverseIndex].emailId.toString()}",
                                                            fontSize: 15.sp,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5.h),
                                                      Row(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .blueColor,
                                                            maxRadius: 15.r,
                                                            child: Icon(
                                                                Icons
                                                                    .phone_android,
                                                                color: Colors
                                                                    .white,
                                                                size: 20.r),
                                                          ),
                                                          CustomText(
                                                            data:
                                                                "  ${controller.viewEnquiryList.value.data?[reverseIndex].contactNo == null ? "" : controller.viewEnquiryList.value.data![reverseIndex].contactNo.toString()}",
                                                            fontSize: 15.sp,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .calendar_month_outlined,
                                                            size: 20.r,
                                                            color: CustomColor
                                                                .blueColor),
                                                        CustomText(
                                                          data:
                                                              " ${formattedDate}",
                                                          fontSize: 14.sp,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                            CupertinoIcons
                                                                .clock_fill,
                                                            size: 20.r,
                                                            color: CustomColor
                                                                .blueColor),
                                                        CustomText(
                                                          data:
                                                              " ${formattedTime}",
                                                          fontSize: 14.sp,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.pending_rounded,
                                                          size: 20.r,
                                                          color: CustomColor
                                                              .blueColor,
                                                        ),
                                                        SizedBox(
                                                          width: 3.w,
                                                        ),
                                                        CustomText(
                                                          // data: controller.viewEnquiryList.value.data?[reverseIndex].eStatus == null
                                                          //     ? ""
                                                          //     : controller.viewEnquiryList.value.data![reverseIndex].eStatus.toString(),
                                                          data: controller
                                                                      .viewEnquiryList
                                                                      .value
                                                                      .data?[
                                                                          index]
                                                                      .eStatus ==
                                                                  null
                                                              ? ""
                                                              : controller
                                                                  .viewEnquiryList
                                                                  .value
                                                                  .data![index]
                                                                  .eStatus
                                                                  .toString(),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: controller
                                                                      .viewEnquiryList
                                                                      .value
                                                                      .data![
                                                                          index]
                                                                      .eStatus ==
                                                                  "Pending"
                                                              ? Colors.red
                                                              : controller
                                                                          .viewEnquiryList
                                                                          .value
                                                                          .data![
                                                                              index]
                                                                          .eStatus ==
                                                                      "Completed"
                                                                  ? Colors.green
                                                                  : Colors
                                                                      .black,
                                                          fontSize: 14.sp,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Divider(
                                                thickness: 1,
                                                color: Colors.black),
                                            InkWell(
                                              onTap: () {
                                                var data = controller
                                                    .viewEnquiryList
                                                    .value
                                                    .data![index];
                                                Get.toNamed(
                                                    AppRoutesName
                                                        .enquiry_view_all,
                                                    arguments: [
                                                      data.enquiryId.toString(),
                                                      data.customerName
                                                          .toString(),
                                                      data.cityName.toString(),
                                                      data.contactPerson
                                                          .toString(),
                                                      data.contactNo.toString(),
                                                      data.emailId.toString(),
                                                      data.eStatus.toString(),
                                                      data.enquiryDetails
                                                          .toString(),
                                                      data.action.toString(),
                                                      data.createBy.toString(),
                                                      data.updateBy.toString(),
                                                      data.createDate
                                                          .toString(),
                                                      data.isActive.toString(),
                                                      data.createdDate
                                                          .toString(),
                                                      data.date.toString(),
                                                      data.modifiedDate
                                                          .toString(),
                                                      data.createdby.toString(),
                                                      data.updatedby.toString(),
                                                    ]);
                                              },
                                              child:
                                                  CustomText(data: "View More"),
                                            ),
                                          ],
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
                              controller.viewEnquiry();
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
