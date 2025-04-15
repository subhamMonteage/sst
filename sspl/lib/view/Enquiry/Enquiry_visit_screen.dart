import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:search_page/search_page.dart';
import 'package:sspl/infrastructure/routes/page_constants.dart';

import '../../controllers/dashboard/existing_sclient_screen_controller.dart';
import '../../infrastructure/image_constants/image_constants.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../sevices/models/enquiry/enquiry_model.dart';
import '../../utilities/custom_color/custom_color.dart';
import '../../utilities/custom_text/custom_text.dart';
import '../../utilities/custom_toast/custom_toast.dart';
import '../dashboard/firmVisit/existing_client_screen.dart';
import 'package:http/http.dart' as https;

class EnquiryVisitScreen extends GetView<ExistingClientController> {
  @override
  Widget build(BuildContext context) {
    Future<void> addEnquiry(
      customerName,
      cityName,
      contactPerson,
      contactNo,
      emailId,
      eStatus,
      enquiryDetails,
      BUid,
      createBy,
    ) async {
      const String url =
          'http://sarvaperp.eduagentapp.com/api/SarvapErp/AddEnquiry';

      // Create the request body
      Map<dynamic, dynamic> body = {
        "CustomerName": customerName.toString(),
        "CityName": cityName.toString(),
        "ContactPerson": contactPerson.toString(),
        "ContactNo": contactNo.toString(),
        "EmailId": emailId.toString(),
        "EStatus": eStatus.toString(),
        "EnquiryDetails": enquiryDetails.toString(),
        "BUId": BUid,
        "CreateBy": createBy.toString(),
      };

      try {
        // Make the HTTP POST request
        final response = await https.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(body),
        );

        // Check the status code of the response
        if (response.statusCode == 200) {
          // Log success message and response body
          print('Enquiry added successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Submit Successfully")),
          );
        } else {
          // Print error message if the request was not successful
          print('Failed to add Enquiry. Status code: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to Submit")),
          );
        }
      } catch (e) {
        // Handle any exceptions that occur during the request
        print('Error occurred while adding enquiry: $e');
      }
    }

    //update status......
    Future<void> updatestatus(
      EnquiryId,
      estatus,
      createBy,
    ) async {
      const String url =
          'http://saleserp.eduagentapp.com/api/SarvapErp/EnquiryStatus';

      // Create the request body
      Map<dynamic, dynamic> body = {
        "EnquiryId": EnquiryId.toString(),
        "EStatus": estatus.toString(),
        "CreateBy": createBy.toString(),
      };

      try {
        // Make the HTTP POST request
        final response = await https.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(body),
        );

        // Check the status code of the response
        if (response.statusCode == 200) {
          // Log success message and response body
          print('Enquiry Status Update successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Status Update Successfully")),
          );
        } else {
          // Print error message if the request was not successful
          print('Failed to add Enquiry. Status code: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to Update")),
          );
        }
      } catch (e) {
        // Handle any exceptions that occur during the request
        print('Error occurred while adding enquiry: $e');
      }
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: CustomText(
              data: 'Enquiry ',
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
                      data: "Manage Enquiry",
                      color: Colors.black,
                    )),
                    Tab(
                        child: CustomText(
                      data: "Add Enquiry",
                      color: Colors.black,
                    )),
                    Tab(
                      child: CustomText(
                        data: "View Enquiry",
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
                  SingleChildScrollView(
                    child: Obx(
                      () {
                        switch (controller.rxRequestStatus.value) {
                          case Status.Loading:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case Status.Complete:
                            // Filter the list to include only items with jobStatus "Pending"

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
                                                        ViewEnquiryModelData>(
                                                    items: controller
                                                            .enquirycontroller
                                                            .viewEnquiryList
                                                            .value
                                                            .data ??
                                                        [],
                                                    searchLabel:
                                                        'Existing Customer',
                                                    suggestion: Center(
                                                      child: AutoSizeText(
                                                        'Filter by Customer name ',
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
                                                          person.customerName,
                                                        ],
                                                    builder: (person) {
                                                      return InkWell(
                                                        onTap: () {
                                                          print(
                                                              "email h y ===>${person.emailId}");
                                                          var data = person;
                                                          Get.toNamed(
                                                              AppRoutesName
                                                                  .UpdateEnquiry_visit,
                                                              arguments: [
                                                                person
                                                                    .customerName
                                                                    .toString(),
                                                                data.cityName
                                                                    .toString(),
                                                                data.contactPerson
                                                                    .toString(),
                                                                data.contactNo
                                                                    .toString(),
                                                                data.emailId
                                                                    .toString(),
                                                              ]);
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10.w,
                                                                  vertical:
                                                                      10.h),
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 10.w,
                                                            vertical: 15.h,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.r),
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                offset: Offset(
                                                                    2, 6),
                                                                blurRadius: 8.r,
                                                                color: Colors
                                                                    .blue
                                                                    .shade900,
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.pending_rounded,
                                                                              size: 30.r,
                                                                              color: CustomColor.blueColor,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 9.w,
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () async {
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
                                                                                              value: controller.EnqueyUpdateStatus.value.isEmpty ? null : controller.EnqueyUpdateStatus.value,
                                                                                              onChanged: (String? newValue) {
                                                                                                if (newValue != null) {
                                                                                                  controller.EnqueyUpdateStatus.value = newValue; // Update the RxString value
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
                                                                                            updatestatus(
                                                                                              person.enquiryId,
                                                                                              controller.EnqueyUpdateStatus.value,
                                                                                              controller.enquirycontroller.empid,
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
                                                                              child: CustomText(
                                                                                data: person.eStatus == null ? "" : person.eStatus.toString(),
                                                                                fontWeight: FontWeight.w500,
                                                                                color: person.eStatus == "Pending"
                                                                                    ? Colors.red
                                                                                    : person.eStatus == "Completed"
                                                                                        ? Colors.green
                                                                                        : Colors.black,
                                                                                fontSize: 15.sp,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                5.h),
                                                                        Row(
                                                                          children: [
                                                                            CircleAvatar(
                                                                              backgroundColor: CustomColor.blueColor,
                                                                              maxRadius: 15.r,
                                                                              child: Icon(Icons.person, color: Colors.white, size: 20.r),
                                                                            ),
                                                                            CustomText(
                                                                              data: "  ${person.contactPerson == null ? "" : person.contactPerson.toString()}",
                                                                              fontSize: 15.sp,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                5.h),
                                                                        Row(
                                                                          children: [
                                                                            CircleAvatar(
                                                                              backgroundColor: CustomColor.blueColor,
                                                                              maxRadius: 15.r,
                                                                              child: Icon(Icons.phone_android, color: Colors.white, size: 20.r),
                                                                            ),
                                                                            CustomText(
                                                                              data: "  ${person.contactNo == null ? "" : person.contactNo.toString()}",
                                                                              fontSize: 15.sp,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                              Icons.calendar_month_outlined,
                                                                              size: 20.r,
                                                                              color: CustomColor.blueColor),
                                                                          SizedBox(
                                                                            width:
                                                                                5.w,
                                                                          ),
                                                                          CustomText(
                                                                            data:
                                                                                DateFormat("dd/MM/yyyy").format(DateTime.parse(person.createDate.toString())),
                                                                            fontSize:
                                                                                14.sp,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              5.h),
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                              CupertinoIcons.clock_fill,
                                                                              size: 20.r,
                                                                              color: CustomColor.blueColor),
                                                                          SizedBox(
                                                                            width:
                                                                                5.w,
                                                                          ),
                                                                          CustomText(
                                                                            data:
                                                                                DateFormat("HH:mm a").format(DateTime.parse(person.createDate.toString())),
                                                                            fontSize:
                                                                                14.sp,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              5.h),
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.mail,
                                                                            size:
                                                                                20.r,
                                                                            color:
                                                                                CustomColor.blueColor,
                                                                          ),
                                                                          // SizedBox(width: 3.w,),
                                                                          CustomText(
                                                                            // data: controller.viewEnquiryList.value.data?[reverseIndex].eStatus == null
                                                                            //     ? ""
                                                                            //     : controller.viewEnquiryList.value.data![reverseIndex].eStatus.toString(),
                                                                            data:
                                                                                "  ${person.emailId == null ? "" : person.emailId.toString()}",
                                                                            fontSize:
                                                                                14.sp,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              /* Divider(
                                                                            thickness: 1,
                                                                            color:
                                                                            Colors.black),
                                                                        Align(
                                                                          alignment:
                                                                          AlignmentDirectional
                                                                              .centerEnd,
                                                                          child: InkWell(
                                                                            onTap: () {
                                                                              var data = pendingItems[index];
                                                                              Get.toNamed(
                                                                                  AppRoutesName
                                                                                      .enquiry_view_all,
                                                                                  arguments: [
                                                                                    data.enquiryId
                                                                                        .toString(),
                                                                                    data.customerName
                                                                                        .toString(),
                                                                                    data.cityName
                                                                                        .toString(),
                                                                                    data.contactPerson
                                                                                        .toString(),
                                                                                    data.contactNo
                                                                                        .toString(),
                                                                                    data.emailId
                                                                                        .toString(),
                                                                                    data.eStatus
                                                                                        .toString(),
                                                                                    data.enquiryDetails
                                                                                        .toString(),
                                                                                    data.action
                                                                                        .toString(),
                                                                                    data.createBy
                                                                                        .toString(),
                                                                                    data.updateBy
                                                                                        .toString(),
                                                                                    data.createDate
                                                                                        .toString(),
                                                                                    data.isActive
                                                                                        .toString(),
                                                                                    data.createdDate
                                                                                        .toString(),
                                                                                    data.date
                                                                                        .toString(),
                                                                                    data.modifiedDate
                                                                                        .toString(),
                                                                                    data.createdby
                                                                                        .toString(),
                                                                                    data.updatedby
                                                                                        .toString(),
                                                                                  ]);
                                                                            },
                                                                            child: Padding(
                                                                              padding:
                                                                              const EdgeInsets
                                                                                  .only(
                                                                                  right:
                                                                                  14.0),
                                                                              child: Text(
                                                                                "View More",
                                                                                style:
                                                                                TextStyle(
                                                                                  fontSize:
                                                                                  16.sp,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),*/
                                                            ],
                                                          ),
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
                                                margin: EdgeInsets.only(
                                                    right: 20.w),
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
                                                data: "Existing Customer",
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
                                                                      onTap: () => controller
                                                                          .enquirycontroller
                                                                          .selectFromDate(
                                                                              context),
                                                                      child: controller.enquirycontroller.formattedFromDate.value ==
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
                                                                                data: '  ${controller.enquirycontroller.formattedFromDate.value}',
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
                                                                  onTap: () => controller
                                                                      .enquirycontroller
                                                                      .selectToDate(
                                                                          context),
                                                                  child: controller
                                                                              .enquirycontroller
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
                                                                                '  ${controller.enquirycontroller.formattedToDate.value}',
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
                                                                      .enquirycontroller
                                                                      .formattedFromDate
                                                                      .value !=
                                                                  "" &&
                                                              controller
                                                                      .enquirycontroller
                                                                      .formattedToDate
                                                                      .value !=
                                                                  "") {
                                                            controller
                                                                .enquirycontroller
                                                                .datefilterEnquiry();
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
                                        controller.enquirycontroller
                                            .viewEnquiry();
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
                    child: Column(
                      children: [
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
                            key: controller.enquirycontroller.formKey.value,
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    // Existing form fields for Customer Name, City, Contact Person, etc.
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(data: "Customer Name"),
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
                                            controller: controller
                                                .enquirycontroller.Customername,
                                            decoration: InputDecoration(
                                              hintText: "Customer Name",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12.h),
                                        CustomText(data: "City Name"),
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
                                            controller: controller
                                                .enquirycontroller.Cityname,
                                            decoration: InputDecoration(
                                              hintText: "City Name",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12.h),
                                        CustomText(data: "Contact Person"),
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
                                            controller: controller
                                                .enquirycontroller
                                                .Contactperson,
                                            decoration: InputDecoration(
                                              hintText: "Contact Person",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12.h),
                                        CustomText(data: "Contact NO"),
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
                                            controller: controller
                                                .enquirycontroller.ContactNo,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                              // Limit to 10 digits
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              // Allow only digits
                                            ],
                                            decoration: InputDecoration(
                                              hintText: "Contact NO",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12.h),
                                        CustomText(data: "Email Id"),
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
                                            controller: controller
                                                .enquirycontroller.Emailid,
                                            decoration: InputDecoration(
                                              hintText: "Email ID",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12.h),

                                        // BU DropdownButton
                                        CustomText(data: "Business Unit"),
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
                                            () => DropdownButtonFormField<int>(
                                              value: controller
                                                          .selectedBUId.value ==
                                                      0
                                                  ? null
                                                  : controller
                                                      .selectedBUId.value,
                                              onChanged: (int? newValue) {
                                                if (newValue != null) {
                                                  controller.selectedBUId
                                                      .value = newValue;
                                                  print(
                                                      "BUID ${controller.selectedBUId.value}");
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                              hint: Text(
                                                "Select Business Unit",
                                                style: GoogleFonts.roboto(
                                                    color: Colors.grey),
                                              ),
                                              items: controller.buList
                                                  .map((buItem) {
                                                return DropdownMenuItem<int>(
                                                  value: buItem.buId,
                                                  child: Text(buItem.buName),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12.h),

                                        CustomText(data: "Enquiry Details"),
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
                                            controller: controller
                                                .enquirycontroller
                                                .EnquiryDetails,
                                            decoration: InputDecoration(
                                              hintText: "Enquiry Details",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            final isValid = controller
                                                .enquirycontroller
                                                .formKey
                                                .value
                                                .currentState!
                                                .validate();
                                            if (controller
                                                    .enquirycontroller
                                                    .Customername
                                                    .text
                                                    .isEmpty &&
                                                controller.enquirycontroller
                                                    .Cityname.text.isEmpty) {
                                              ShortMessage.toast(
                                                  title:
                                                      "Please fill all fields");
                                            } else {
                                              addEnquiry(
                                                controller.enquirycontroller
                                                    .Customername.text,
                                                controller.enquirycontroller
                                                    .Cityname.text,
                                                controller.enquirycontroller
                                                    .Contactperson.text,
                                                controller.enquirycontroller
                                                    .ContactNo.text,
                                                controller.enquirycontroller
                                                    .Emailid.text,
                                                controller.enquirycontroller
                                                    .status.value,
                                                controller.enquirycontroller
                                                    .EnquiryDetails.text,
                                                controller.selectedBUId.value,
                                                // Pass BUId
                                                controller
                                                    .enquirycontroller.empid,
                                              );
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
                                                  color: CustomColor.blueColor,
                                                )
                                              ],
                                            ),
                                            child: CustomText(
                                              data: "Submit",
                                              color: Colors.white,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                                      data: "Pending Enquiry",
                                      color: Colors.black,
                                    ),
                                  ),
                                  Tab(
                                      child: CustomText(
                                    data: "Completed Enquiry",
                                    color: Colors.black,
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
                                          // Filter the list to include only items with jobStatus "Pending"
                                          var pendingItems = controller
                                                  .enquirycontroller
                                                  .viewEnquiryList
                                                  .value
                                                  .data
                                                  ?.where((item) =>
                                                      item.eStatus == "Pending")
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
                                                                  ViewEnquiryModelData>(
                                                              items:
                                                                  pendingItems ??
                                                                      [],
                                                              searchLabel:
                                                                  'Enquiry',
                                                              suggestion:
                                                                  Center(
                                                                child:
                                                                    AutoSizeText(
                                                                  'Filter Enquiry by any field',
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
                                                                            .contactPerson,
                                                                        person
                                                                            .cityName,
                                                                        person
                                                                            .createBy,
                                                                        person
                                                                            .emailId,
                                                                        person
                                                                            .contactNo,
                                                                        person
                                                                            .enquiryDetails,
                                                                        person
                                                                            .customerName,
                                                                        DateFormat("dd/MM/yyyy").format(DateTime.parse(person
                                                                            .date
                                                                            .toString())),
                                                                        DateFormat("dd/MM/yyyy").format(DateTime.parse(person
                                                                            .createDate
                                                                            .toString())),
                                                                        person
                                                                            .eStatus
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
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.pending_rounded,
                                                                                      size: 30.r,
                                                                                      color: CustomColor.blueColor,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 9.w,
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () async {
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
                                                                                                      value: controller.EnqueyUpdateStatus.value.isEmpty ? null : controller.EnqueyUpdateStatus.value,
                                                                                                      onChanged: (String? newValue) {
                                                                                                        if (newValue != null) {
                                                                                                          controller.EnqueyUpdateStatus.value = newValue; // Update the RxString value
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
                                                                                                    updatestatus(
                                                                                                      person.enquiryId,
                                                                                                      controller.EnqueyUpdateStatus.value,
                                                                                                      controller.enquirycontroller.empid,
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
                                                                                      child: CustomText(
                                                                                        data: person.eStatus == null ? "" : person.eStatus.toString(),
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: person.eStatus == "Pending"
                                                                                            ? Colors.red
                                                                                            : person.eStatus == "Completed"
                                                                                                ? Colors.green
                                                                                                : Colors.black,
                                                                                        fontSize: 15.sp,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 5.h),
                                                                                Row(
                                                                                  children: [
                                                                                    CircleAvatar(
                                                                                      backgroundColor: CustomColor.blueColor,
                                                                                      maxRadius: 15.r,
                                                                                      child: Icon(Icons.person, color: Colors.white, size: 20.r),
                                                                                    ),
                                                                                    CustomText(
                                                                                      data: "  ${person.contactPerson == null ? "" : person.contactPerson.toString()}",
                                                                                      fontSize: 15.sp,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 5.h),
                                                                                Row(
                                                                                  children: [
                                                                                    CircleAvatar(
                                                                                      backgroundColor: CustomColor.blueColor,
                                                                                      maxRadius: 15.r,
                                                                                      child: Icon(Icons.phone_android, color: Colors.white, size: 20.r),
                                                                                    ),
                                                                                    CustomText(
                                                                                      data: "  ${person.contactNo == null ? "" : person.contactNo.toString()}",
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
                                                                                  Icon(Icons.calendar_month_outlined, size: 20.r, color: CustomColor.blueColor),
                                                                                  SizedBox(
                                                                                    width: 5.w,
                                                                                  ),
                                                                                  CustomText(
                                                                                    data: DateFormat("dd/MM/yyyy").format(DateTime.parse(person.createDate.toString())),
                                                                                    fontSize: 14.sp,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 5.h),
                                                                              Row(
                                                                                children: [
                                                                                  Icon(CupertinoIcons.clock_fill, size: 20.r, color: CustomColor.blueColor),
                                                                                  SizedBox(
                                                                                    width: 5.w,
                                                                                  ),
                                                                                  CustomText(
                                                                                    data: DateFormat("HH:mm a").format(DateTime.parse(person.createDate.toString())),
                                                                                    fontSize: 14.sp,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 5.h),
                                                                              Row(
                                                                                children: [
                                                                                  Icon(
                                                                                    Icons.mail,
                                                                                    size: 20.r,
                                                                                    color: CustomColor.blueColor,
                                                                                  ),
                                                                                  // SizedBox(width: 3.w,),
                                                                                  CustomText(
                                                                                    // data: controller.viewEnquiryList.value.data?[reverseIndex].eStatus == null
                                                                                    //     ? ""
                                                                                    //     : controller.viewEnquiryList.value.data![reverseIndex].eStatus.toString(),
                                                                                    data: "  ${person.emailId == null ? "" : person.emailId.toString()}",
                                                                                    fontSize: 14.sp,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      /* Divider(
                                                                          thickness: 1,
                                                                          color:
                                                                          Colors.black),
                                                                      Align(
                                                                        alignment:
                                                                        AlignmentDirectional
                                                                            .centerEnd,
                                                                        child: InkWell(
                                                                          onTap: () {
                                                                            var data = pendingItems[index];
                                                                            Get.toNamed(
                                                                                AppRoutesName
                                                                                    .enquiry_view_all,
                                                                                arguments: [
                                                                                  data.enquiryId
                                                                                      .toString(),
                                                                                  data.customerName
                                                                                      .toString(),
                                                                                  data.cityName
                                                                                      .toString(),
                                                                                  data.contactPerson
                                                                                      .toString(),
                                                                                  data.contactNo
                                                                                      .toString(),
                                                                                  data.emailId
                                                                                      .toString(),
                                                                                  data.eStatus
                                                                                      .toString(),
                                                                                  data.enquiryDetails
                                                                                      .toString(),
                                                                                  data.action
                                                                                      .toString(),
                                                                                  data.createBy
                                                                                      .toString(),
                                                                                  data.updateBy
                                                                                      .toString(),
                                                                                  data.createDate
                                                                                      .toString(),
                                                                                  data.isActive
                                                                                      .toString(),
                                                                                  data.createdDate
                                                                                      .toString(),
                                                                                  data.date
                                                                                      .toString(),
                                                                                  data.modifiedDate
                                                                                      .toString(),
                                                                                  data.createdby
                                                                                      .toString(),
                                                                                  data.updatedby
                                                                                      .toString(),
                                                                                ]);
                                                                          },
                                                                          child: Padding(
                                                                            padding:
                                                                            const EdgeInsets
                                                                                .only(
                                                                                right:
                                                                                14.0),
                                                                            child: Text(
                                                                              "View More",
                                                                              style:
                                                                              TextStyle(
                                                                                fontSize:
                                                                                16.sp,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),*/
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
                                                                                    onTap: () => controller.enquirycontroller.selectFromDate(context),
                                                                                    child: controller.enquirycontroller.formattedFromDate.value == ""
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
                                                                                              data: '  ${controller.enquirycontroller.formattedFromDate.value}',
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
                                                                                onTap: () => controller.enquirycontroller.selectToDate(context),
                                                                                child: controller.enquirycontroller.formattedToDate.value == ""
                                                                                    ? Container(alignment: Alignment.centerLeft, height: 50.h, width: 400, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)), child: CustomText(data: '   Select To Date'))
                                                                                    : Container(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        height: 50.h,
                                                                                        width: 400,
                                                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)),
                                                                                        child: CustomText(
                                                                                          data: '  ${controller.enquirycontroller.formattedToDate.value}',
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
                                                                        if (controller.enquirycontroller.formattedFromDate.value !=
                                                                                "" &&
                                                                            controller.enquirycontroller.formattedToDate.value !=
                                                                                "") {
                                                                          controller
                                                                              .enquirycontroller
                                                                              .datefilterEnquiry();
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
                                                height: 540.h,
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
                                                    await controller
                                                        .enquirycontroller
                                                        .viewEnquiry();
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
                                                                          10.w,
                                                                      vertical:
                                                                          10.h),
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    10.w,
                                                                vertical: 15.h,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.r),
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    offset:
                                                                        Offset(
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
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.pending_rounded,
                                                                                  size: 30.r,
                                                                                  color: CustomColor.blueColor,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 9.w,
                                                                                ),
                                                                                InkWell(
                                                                                  onTap: () async {
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
                                                                                                  value: controller.EnqueyUpdateStatus.value.isEmpty ? null : controller.EnqueyUpdateStatus.value,
                                                                                                  onChanged: (String? newValue) {
                                                                                                    if (newValue != null) {
                                                                                                      controller.EnqueyUpdateStatus.value = newValue; // Update the RxString value
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
                                                                                                updatestatus(
                                                                                                  pendingItems[index].enquiryId,
                                                                                                  controller.EnqueyUpdateStatus.value,
                                                                                                  controller.enquirycontroller.empid,
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
                                                                                  child: CustomText(
                                                                                    // data: controller.viewEnquiryList.value.data?[reverseIndex].eStatus == null
                                                                                    //     ? ""
                                                                                    //     : controller.viewEnquiryList.value.data![reverseIndex].eStatus.toString(),
                                                                                    data: pendingItems[index].eStatus == null ? "" : pendingItems[index].eStatus.toString(),
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: pendingItems[index].eStatus == "Pending"
                                                                                        ? Colors.red
                                                                                        : pendingItems[index].eStatus == "Completed"
                                                                                            ? Colors.green
                                                                                            : Colors.black,
                                                                                    fontSize: 15.sp,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 5.h),
                                                                            Row(
                                                                              children: [
                                                                                CircleAvatar(
                                                                                  backgroundColor: CustomColor.blueColor,
                                                                                  maxRadius: 15.r,
                                                                                  child: Icon(Icons.person, color: Colors.white, size: 20.r),
                                                                                ),
                                                                                CustomText(
                                                                                  data: "  ${pendingItems[index].customerName == null ? "" : pendingItems[index].customerName.toString()}",
                                                                                  fontSize: 15.sp,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 5.h),
                                                                            Row(
                                                                              children: [
                                                                                CircleAvatar(
                                                                                  backgroundColor: CustomColor.blueColor,
                                                                                  maxRadius: 15.r,
                                                                                  child: Icon(Icons.phone_android, color: Colors.white, size: 20.r),
                                                                                ),
                                                                                CustomText(
                                                                                  data: "  ${pendingItems[index].contactNo == null ? "" : pendingItems[index].contactNo.toString()}",
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
                                                                              Icon(Icons.calendar_month_outlined, size: 20.r, color: CustomColor.blueColor),
                                                                              CustomText(
                                                                                data: " ${formattedDate}",
                                                                                fontSize: 14.sp,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                              height: 5.h),
                                                                          Row(
                                                                            children: [
                                                                              Icon(CupertinoIcons.clock_fill, size: 20.r, color: CustomColor.blueColor),
                                                                              CustomText(
                                                                                data: " ${formattedTime}",
                                                                                fontSize: 14.sp,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                              height: 5.h),
                                                                          Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.mail,
                                                                                size: 20.r,
                                                                                color: CustomColor.blueColor,
                                                                              ),
                                                                              // SizedBox(width: 3.w,),
                                                                              CustomText(
                                                                                // data: controller.viewEnquiryList.value.data?[reverseIndex].eStatus == null
                                                                                //     ? ""
                                                                                //     : controller.viewEnquiryList.value.data![reverseIndex].eStatus.toString(),
                                                                                data: "  ${pendingItems[index].emailId == null ? "" : pendingItems[index].emailId.toString()}",
                                                                                fontSize: 14.sp,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Divider(
                                                                      thickness:
                                                                          1,
                                                                      color: Colors
                                                                          .black),
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .centerEnd,
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        var data =
                                                                            pendingItems[index];
                                                                        Get.toNamed(
                                                                            AppRoutesName.enquiry_view_all,
                                                                            arguments: [
                                                                              data.enquiryId.toString(),
                                                                              data.customerName.toString(),
                                                                              data.cityName.toString(),
                                                                              data.contactPerson.toString(),
                                                                              data.contactNo.toString(),
                                                                              data.emailId.toString(),
                                                                              data.eStatus.toString(),
                                                                              data.enquiryDetails.toString(),
                                                                              data.action.toString(),
                                                                              data.createBy.toString(),
                                                                              data.updateBy.toString(),
                                                                              data.createDate.toString(),
                                                                              data.isActive.toString(),
                                                                              data.createdDate.toString(),
                                                                              data.date.toString(),
                                                                              data.modifiedDate.toString(),
                                                                              data.createdby.toString(),
                                                                              data.updatedby.toString(),
                                                                            ]);
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                14.0),
                                                                        child:
                                                                            Text(
                                                                          "View More",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16.sp,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
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
                                                      controller
                                                          .enquirycontroller
                                                          .viewEnquiry();
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
                                          var completedItems = controller
                                                  .enquirycontroller
                                                  .viewEnquiryList
                                                  .value
                                                  .data
                                                  ?.where((item) =>
                                                      item.eStatus ==
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
                                                                  ViewEnquiryModelData>(
                                                              items:
                                                                  completedItems ??
                                                                      [],
                                                              searchLabel:
                                                                  'Enquiry',
                                                              suggestion:
                                                                  Center(
                                                                child:
                                                                    AutoSizeText(
                                                                  'Filter Enquiry by any field',
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
                                                                            .contactPerson,
                                                                        person
                                                                            .cityName,
                                                                        person
                                                                            .createBy,
                                                                        person
                                                                            .emailId,
                                                                        person
                                                                            .contactNo,
                                                                        person
                                                                            .enquiryDetails,
                                                                        person
                                                                            .customerName,
                                                                        DateFormat("dd/MM/yyyy").format(DateTime.parse(person
                                                                            .date
                                                                            .toString())),
                                                                        DateFormat("dd/MM/yyyy").format(DateTime.parse(person
                                                                            .createDate
                                                                            .toString())),
                                                                        person
                                                                            .eStatus
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
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  CircleAvatar(
                                                                                    backgroundColor: CustomColor.blueColor,
                                                                                    maxRadius: 15.r,
                                                                                    child: Icon(Icons.supervised_user_circle_outlined, color: Colors.white, size: 20.r),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 10.w,
                                                                                  ),
                                                                                  Column(
                                                                                    children: [
                                                                                      CustomText(
                                                                                        data: person.contactPerson == null ? "" : person.contactPerson.toString(),
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
                                                                                    backgroundColor: CustomColor.blueColor,
                                                                                    maxRadius: 15.r,
                                                                                    child: Icon(Icons.supervised_user_circle_outlined, color: Colors.white, size: 20.r),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 10.w,
                                                                                  ),
                                                                                  Column(
                                                                                    children: [
                                                                                      CustomText(
                                                                                        data: person.contactPerson == null ? "" : person.contactPerson.toString(),
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
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Icon(
                                                                                    Icons.calendar_month_outlined,
                                                                                    size: 20.r,
                                                                                  ),
                                                                                  CustomText(
                                                                                    data: " ${person.createDate}",
                                                                                    fontSize: 14.sp,
                                                                                    //fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 5.h),
                                                                              Row(
                                                                                children: [
                                                                                  Icon(
                                                                                    CupertinoIcons.clock_fill,
                                                                                    size: 20.r,
                                                                                  ),
                                                                                  CustomText(
                                                                                    data: " ${person.createDate}",
                                                                                    fontSize: 14.sp,
                                                                                    //fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              5.h),
                                                                      Row(
                                                                        children: [
                                                                          CircleAvatar(
                                                                            backgroundColor:
                                                                                CustomColor.blueColor,
                                                                            maxRadius:
                                                                                15.r,
                                                                            child: Icon(Icons.mail,
                                                                                color: Colors.white,
                                                                                size: 20.r),
                                                                          ),
                                                                          CustomText(
                                                                            data:
                                                                                "  ${person.emailId == null ? "" : person.emailId.toString()}",
                                                                            //fontWeight: FontWeight.w500,
                                                                            fontSize:
                                                                                15.sp,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5.h,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          CircleAvatar(
                                                                            backgroundColor:
                                                                                CustomColor.blueColor,
                                                                            maxRadius:
                                                                                15.r,
                                                                            child: Icon(Icons.phone_android,
                                                                                color: Colors.white,
                                                                                size: 20.r),
                                                                          ),
                                                                          CustomText(
                                                                            data:
                                                                                "  ${person.contactNo == null ? "" : person.contactNo.toString()}",
                                                                            //fontWeight: FontWeight.w500,
                                                                            fontSize:
                                                                                15.sp,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      person.contactNo ==
                                                                              null
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
                                                                                    onTap: () => controller.enquirycontroller.selectFromDate(context),
                                                                                    child: controller.enquirycontroller.formattedFromDate.value == ""
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
                                                                                              data: '  ${controller.enquirycontroller.formattedFromDate.value}',
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
                                                                                onTap: () => controller.enquirycontroller.selectToDate(context),
                                                                                child: controller.enquirycontroller.formattedToDate.value == ""
                                                                                    ? Container(alignment: Alignment.centerLeft, height: 50.h, width: 400, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)), child: CustomText(data: '   Select To Date'))
                                                                                    : Container(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        height: 50.h,
                                                                                        width: 400,
                                                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)),
                                                                                        child: CustomText(
                                                                                          data: '  ${controller.enquirycontroller.formattedToDate.value}',
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
                                                                        if (controller.enquirycontroller.formattedFromDate.value !=
                                                                                "" &&
                                                                            controller.enquirycontroller.formattedToDate.value !=
                                                                                "") {
                                                                          controller
                                                                              .enquirycontroller
                                                                              .datefilterEnquiry();
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
                                                height: 540.h,
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
                                                    await controller
                                                        .enquirycontroller
                                                        .viewEnquiry();
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
                                                            int reverseIndex = controller
                                                                    .enquirycontroller
                                                                    .viewEnquiryList
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
                                                                          10.w,
                                                                      vertical:
                                                                          10.h),
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    10.w,
                                                                vertical: 15.h,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.r),
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    offset:
                                                                        Offset(
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
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.pending_rounded,
                                                                                  size: 30.r,
                                                                                  color: CustomColor.blueColor,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 9.w,
                                                                                ),
                                                                                CustomText(
                                                                                  // data: controller.viewEnquiryList.value.data?[reverseIndex].eStatus == null
                                                                                  //     ? ""
                                                                                  //     : controller.viewEnquiryList.value.data![reverseIndex].eStatus.toString(),
                                                                                  data: completedItems[index].eStatus == null ? "" : completedItems[index].eStatus.toString(),
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: completedItems[index].eStatus == "Pending"
                                                                                      ? Colors.red
                                                                                      : completedItems[index].eStatus == "Completed"
                                                                                          ? Colors.green
                                                                                          : Colors.black,
                                                                                  fontSize: 15.sp,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 5.h),
                                                                            Row(
                                                                              children: [
                                                                                CircleAvatar(
                                                                                  backgroundColor: CustomColor.blueColor,
                                                                                  maxRadius: 15.r,
                                                                                  child: Icon(Icons.person, color: Colors.white, size: 20.r),
                                                                                ),
                                                                                CustomText(
                                                                                  data: "  ${completedItems[index].contactPerson == null ? "" : completedItems[index].contactPerson.toString()}",
                                                                                  fontSize: 15.sp,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 5.h),
                                                                            Row(
                                                                              children: [
                                                                                CircleAvatar(
                                                                                  backgroundColor: CustomColor.blueColor,
                                                                                  maxRadius: 15.r,
                                                                                  child: Icon(Icons.phone_android, color: Colors.white, size: 20.r),
                                                                                ),
                                                                                CustomText(
                                                                                  data: "  ${completedItems[index].contactNo == null ? "" : completedItems[index].contactNo.toString()}",
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
                                                                              Icon(Icons.calendar_month_outlined, size: 20.r, color: CustomColor.blueColor),
                                                                              CustomText(
                                                                                data: " ${formattedDate}",
                                                                                fontSize: 14.sp,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                              height: 5.h),
                                                                          Row(
                                                                            children: [
                                                                              Icon(CupertinoIcons.clock_fill, size: 20.r, color: CustomColor.blueColor),
                                                                              CustomText(
                                                                                data: " ${formattedTime}",
                                                                                fontSize: 14.sp,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                              height: 5.h),
                                                                          Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.mail,
                                                                                size: 20.r,
                                                                                color: CustomColor.blueColor,
                                                                              ),
                                                                              // SizedBox(width: 3.w,),
                                                                              CustomText(
                                                                                // data: controller.viewEnquiryList.value.data?[reverseIndex].eStatus == null
                                                                                //     ? ""
                                                                                //     : controller.viewEnquiryList.value.data![reverseIndex].eStatus.toString(),
                                                                                data: "  ${completedItems[index].emailId == null ? "" : completedItems[index].emailId.toString()}",
                                                                                fontSize: 14.sp,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Divider(
                                                                      thickness:
                                                                          1,
                                                                      color: Colors
                                                                          .black),
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .centerEnd,
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        var data =
                                                                            completedItems[index];
                                                                        Get.toNamed(
                                                                            AppRoutesName.enquiry_view_all,
                                                                            arguments: [
                                                                              data.enquiryId.toString(),
                                                                              data.customerName.toString(),
                                                                              data.cityName.toString(),
                                                                              data.contactPerson.toString(),
                                                                              data.contactNo.toString(),
                                                                              data.emailId.toString(),
                                                                              data.eStatus.toString(),
                                                                              data.enquiryDetails.toString(),
                                                                              data.action.toString(),
                                                                              data.createBy.toString(),
                                                                              data.updateBy.toString(),
                                                                              data.createDate.toString(),
                                                                              data.isActive.toString(),
                                                                              data.createdDate.toString(),
                                                                              data.date.toString(),
                                                                              data.modifiedDate.toString(),
                                                                              data.createdby.toString(),
                                                                              data.updatedby.toString(),
                                                                            ]);
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                14.0),
                                                                        child:
                                                                            Text(
                                                                          "View More",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16.sp,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
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
                                                      controller
                                                          .enquirycontroller
                                                          .viewEnquiry();
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
