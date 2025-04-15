import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sspl/controllers/add_visit_screen_controller/add_visit_screen_controller.dart';
import 'package:sspl/controllers/dashboard/dashboard.dart';
import 'package:sspl/infrastructure/image_constants/image_constants.dart';
import 'package:sspl/infrastructure/routes/page_constants.dart';
import 'package:sspl/sevices/api_sevices/api_services.dart';
import 'package:sspl/sevices/repo/add_followup_view_model.dart';
import 'package:sspl/utilities/custom_drawer/custom_drawer.dart';
import 'package:sspl/utilities/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sspl/utilities/custom_toast/custom_toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/AddNewController/AddNewCoustomer.dart';
import '../../utilities/custom_color/custom_color.dart';

class DashboardScreen extends GetView<DashboardController> {
  final addfollowupModel = Provider.of<AddFollowUpViewModel>(Get.context!);

  @override
  Widget build(BuildContext context) {
    Future<void> updateSchedulerStatus(
        String schedulerId, String status) async {
      const String apiUrl =
          "http://saleserp.eduagentapp.com/api/SarvapErp/SchedulerUpdate";

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

    Future<void> updatecomplaint(
        complaintid, acceptid, acceptstatus, acceptRemark) async {
      const String url =
          'http://saleserp.eduagentapp.com/api/SarvapErp/AddAccptComplaint';

      // Create the request body
      Map<dynamic, dynamic> body = {
        "ComplaintId": complaintid.toString(),
        "AcceptId": acceptid.toString(),
        "AcceptRemarks": acceptstatus.toString(),
        "AcceptStatus": acceptRemark.toString(),
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
          print('Complain Update successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Update Successfully")),
          );
          await controller.ComplaintViewApi(); // Refresh data
        } else {
          // Print error message if the request was not successful
          print('Failed to add Schedule. Status code: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to Update")),
          );
        }
      } catch (e) {
        // Handle any exceptions that occur during the request
        print('Error occurred while adding enquiry: $e');
      }
    }

    Future<void> Cupdatecomplaint(
        CcomplaintId, acceptid, acceptstatus, acceptRemark) async {
      const String url =
          'http://sarvaperp.eduagentapp.com/api/SarvapErp/AddCompleteComplaint';

      // Create the request body
      Map<dynamic, dynamic> body = {
        "ComplaintId": CcomplaintId.toString(),
        "CAcceptId": acceptid.toString(),
        "CAcceptRemarks": acceptstatus.toString(),
        "CAcceptStatus": acceptRemark.toString(),
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
          print('Complain Update successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Update Successfully")),
          );
          await controller.ComplaintViewApi(); // Refresh data
        } else {
          // Print error message if the request was not successful
          print('Failed to add Schedule. Status code: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to Update")),
          );
        }
      } catch (e) {
        // Handle any exceptions that occur during the request
        print('Error occurred while adding enquiry: $e');
      }
    }

    Get.put(AddVisitScreenController());
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: controller.present.value
          ? CustomAppDrawer()
          : Dialog(
              child: SizedBox(
                  height: 100.h,
                  width: 100.w,
                  child:
                      const Center(child: Text("Fill the attendance first"))),
            ),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.amber,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: CustomText(
          data: "SARVAP SOLUTIONS PVT. LTD.",
          fontSize: 21.sp,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: CustomColor.blueColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      height: 100.h,
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: CustomColor.blueColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.r),
                              bottomRight: Radius.circular(30.r))),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 30.w, right: 30.w, top: 10.h, bottom: 15.h),
                  child: Container(
                    padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(00, 10),
                            color: Colors.black12,
                            blurRadius: 7.r)
                      ],
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                maxRadius: 50.r,
                                backgroundColor: Colors.amber,
                                child: Icon(
                                  Icons.person,
                                  size: 50.r,
                                ),
                              ),
                              CustomText(
                                data:
                                    "${controller.userDetails.value.data?.firstName == null ? "" : controller.userDetails.value.data!.firstName} ${controller.userDetails.value.data?.lastName == null ? "" : controller.userDetails.value.data!.lastName}",
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              CustomText(
                                data: controller
                                            .userDetails.value.data?.mobileNo ==
                                        null
                                    ? ""
                                    : controller
                                        .userDetails.value.data!.mobileNo
                                        .toString(),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.toNamed(AppRoutesName.check_in_screen);
                                },
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6.h, horizontal: 10.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: Colors.white,
                                  ),
                                  child: CustomText(
                                    data: "Mark Attendance",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                            ],
                          )
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
            controller.present.value
                ? Column(
                    children: [
                      Container(
                        width: Get.width,
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.h, vertical: 5.h),
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.toNamed(AppRoutesName.Enquiry_visit);
                              },
                              child: Container(
                                height: 80.h,
                                width: 130.w,
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 20.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: CustomColor.blueColor),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    CustomText(
                                      data: "Enquiry",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      textAlign: TextAlign.center,
                                      fontSize: 14.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(AppRoutesName.clientvisit_screen);
                              },
                              child: Container(
                                height: 80.h,
                                width: 130.w,
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 20.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: CustomColor.blueColor),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_history,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    CustomText(
                                      data: "Expense",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      textAlign: TextAlign.center,
                                      fontSize: 14.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(AppRoutesName.Leave_view_screen);
                              },
                              child: Container(
                                height: 80.h,
                                width: 130.w,
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 10.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: CustomColor.blueColor),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    CustomText(
                                      data: "Leave",
                                      textAlign: TextAlign.center,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.h, vertical: 5.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0.6),
                                blurRadius: 8.r,
                                color: Colors.indigo.shade100,
                              ),
                            ]),
                        child: Column(
                          children: [
                            Container(
                              width: Get.width,
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.r),
                                    topRight: Radius.circular(20.r),
                                  ),
                                  color: CustomColor.blueColor),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90.w,
                                  ),
                                  CustomText(
                                    data: "Complaint",
                                    color: Colors.white,
                                    fontSize: 22.sp,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(AppRoutesName.complaint_add);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.h, horizontal: 10.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
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
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
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
                                      return SingleChildScrollView(
                                        child: SizedBox(
                                          height: 200.h,
                                          child: CustomRefreshIndicator(
                                            leadingScrollIndicatorVisible:
                                                false,
                                            trailingScrollIndicatorVisible:
                                                false,
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
                                                  .ComplaintViewApi();
                                            }),
                                            child:
                                                controller.complaintlist.value
                                                            .data?.length ==
                                                        null
                                                    ? Center(
                                                        child: CustomText(
                                                            data:
                                                                "Data not found"),
                                                      )
                                                    : ListView.builder(
                                                        // reverse: true,
                                                        padding:
                                                            EdgeInsets.zero,
                                                        itemCount: controller
                                                            .complaintlist
                                                            .value
                                                            .data
                                                            ?.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return InkWell(
                                                            child: Container(
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
                                                                        5.r,
                                                                  ),
                                                                  BoxShadow(
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            -1),
                                                                    color: Colors
                                                                        .indigo
                                                                        .shade100,
                                                                    blurRadius:
                                                                        3.r,
                                                                  ),
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
                                                                              "Complaint :",
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              16.sp,
                                                                        ),
                                                                      ),
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                        child: Container(
                                                                            height: 20,
                                                                            width: 150,
                                                                            child: controller.complaintlist.value.data![index].acceptRemarks.toString() == "null"
                                                                                ? ElevatedButton(
                                                                                    onPressed: () async {
                                                                                      await showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext context) {
                                                                                          return AlertDialog(
                                                                                            title: Text("Accept Complaint"),
                                                                                            content: SingleChildScrollView(
                                                                                              child: Column(
                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                children: [
                                                                                                  Container(
                                                                                                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                                                                                                    child: Align(
                                                                                                      alignment: Alignment.centerLeft,
                                                                                                      child: Text(
                                                                                                        "Status",
                                                                                                        style: TextStyle(
                                                                                                          fontSize: 16.sp,
                                                                                                          fontWeight: FontWeight.bold,
                                                                                                        ),
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
                                                                                                    child: Obx(
                                                                                                      () => DropdownButtonFormField<String>(
                                                                                                        value: controller.Remarkupdate.value.isEmpty ? null : controller.Remarkupdate.value,
                                                                                                        onChanged: (String? newValue) {
                                                                                                          if (newValue != null) {
                                                                                                            controller.Remarkupdate.value = newValue; // Update the RxString value
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
                                                                                                        items: ["Accepted", "Completed"]
                                                                                                            .map(
                                                                                                              (status) => DropdownMenuItem<String>(
                                                                                                                value: status,
                                                                                                                child: Text(status),
                                                                                                              ),
                                                                                                            )
                                                                                                            .toList(),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            actions: [
                                                                                              TextButton(
                                                                                                onPressed: () async {
                                                                                                  updatecomplaint(
                                                                                                    controller.complaintlist.value.data?[index].complaintId.toString(),
                                                                                                    controller.empId.value,
                                                                                                    controller.Remarkupdate.value,
                                                                                                    controller.updatremark.value.text,
                                                                                                  );
                                                                                                  Get.back(); // Close the dialog
                                                                                                  await controller.ComplaintViewApi(); // Refresh data
                                                                                                },
                                                                                                child: Text("Accept"),
                                                                                              ),
                                                                                            ],
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                    child: Text(
                                                                                      "Tap Me To Accept",
                                                                                      style: TextStyle(color: Colors.white, fontSize: 9),
                                                                                    ),
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      backgroundColor: Colors.red,
                                                                                    ),
                                                                                  )
                                                                                : controller.complaintlist.value.data![index].cAcceptStatus.toString() == "null"
                                                                                    ? ElevatedButton(
                                                                                        onPressed: () async {
                                                                                          await showDialog(
                                                                                            context: context,
                                                                                            builder: (BuildContext context) {
                                                                                              return AlertDialog(
                                                                                                title: Text("Complete Complaint"),
                                                                                                content: SingleChildScrollView(
                                                                                                  child: Column(
                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                    children: [
                                                                                                      Container(
                                                                                                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                                                                                                        decoration: BoxDecoration(),
                                                                                                        child: Align(
                                                                                                          alignment: Alignment.centerLeft,
                                                                                                          child: Text(
                                                                                                            "Status",
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 16.sp,
                                                                                                              fontWeight: FontWeight.bold,
                                                                                                            ),
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
                                                                                                        child: Obx(
                                                                                                          () => DropdownButtonFormField<String>(
                                                                                                            value: controller.CRemarkupdate.value.isEmpty ? null : controller.CRemarkupdate.value,
                                                                                                            onChanged: (String? newValue) {
                                                                                                              if (newValue != null) {
                                                                                                                controller.CRemarkupdate.value = newValue; // Update the RxString value
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
                                                                                                            items: ["Completed", "Rejected"]
                                                                                                                .map(
                                                                                                                  (status) => DropdownMenuItem<String>(
                                                                                                                    value: status,
                                                                                                                    child: Text(status),
                                                                                                                  ),
                                                                                                                )
                                                                                                                .toList(),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      SizedBox(height: 5),
                                                                                                      Container(
                                                                                                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                                                                                                        decoration: BoxDecoration(),
                                                                                                        child: Align(
                                                                                                          alignment: Alignment.centerLeft,
                                                                                                          child: Text(
                                                                                                            "Remark",
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 16.sp,
                                                                                                              fontWeight: FontWeight.bold,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      Container(
                                                                                                        padding: EdgeInsets.symmetric(
                                                                                                          horizontal: 20.w,
                                                                                                          vertical: 4.h,
                                                                                                        ),
                                                                                                        alignment: Alignment.center,
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: Colors.grey.shade200,
                                                                                                          borderRadius: BorderRadius.circular(50.r),
                                                                                                        ),
                                                                                                        child: TextFormField(
                                                                                                          keyboardType: TextInputType.text,
                                                                                                          controller: controller.Cupdatremark,
                                                                                                          decoration: InputDecoration(
                                                                                                            hintText: "Remark",
                                                                                                            hintStyle: GoogleFonts.roboto(color: Colors.grey),
                                                                                                            border: InputBorder.none,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      Align(
                                                                                                        alignment: Alignment.centerRight,
                                                                                                        child: TextButton(
                                                                                                          onPressed: () {
                                                                                                            Cupdatecomplaint(controller.complaintlist.value.data?[index].complaintId.toString(), controller.empId.value, controller.CRemarkupdate.value, controller.Cupdatremark.value.text); // Clos
                                                                                                            Get.back(); // e the dialog
                                                                                                          },
                                                                                                          child: Text("Complete"),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                            },
                                                                                          );
                                                                                        },
                                                                                        child: Text(
                                                                                          "Tap Me To Complete",
                                                                                          style: TextStyle(color: Colors.white, fontSize: 9),
                                                                                        ),
                                                                                        style: ElevatedButton.styleFrom(
                                                                                          backgroundColor: Colors.orangeAccent,
                                                                                        ),
                                                                                      )
                                                                                    : controller.complaintlist.value.data![index].cAcceptRemarks.toString() == 'Rejected'
                                                                                        ? ElevatedButton(
                                                                                            onPressed: () {},
                                                                                            child: Text(
                                                                                              "Rejected",
                                                                                              style: TextStyle(color: Colors.white, fontSize: 9),
                                                                                            ),
                                                                                            style: ElevatedButton.styleFrom(
                                                                                              backgroundColor: Colors.red,
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        : controller.complaintlist.value.data![index].cAcceptRemarks.toString() == 'Completed'
                                                                                            ? ElevatedButton(
                                                                                                onPressed: () {},
                                                                                                child: Text(
                                                                                                  "Completed",
                                                                                                  style: TextStyle(color: Colors.white, fontSize: 9),
                                                                                                ),
                                                                                                style: ElevatedButton.styleFrom(
                                                                                                  backgroundColor: Colors.green,
                                                                                                  shape: RoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                                                                                                  ),
                                                                                                ),
                                                                                              )
                                                                                            : ElevatedButton(
                                                                                                onPressed: () {},
                                                                                                child: Text(
                                                                                                  "Rejected",
                                                                                                  style: TextStyle(color: Colors.white, fontSize: 9),
                                                                                                ),
                                                                                                style: ElevatedButton.styleFrom(
                                                                                                  backgroundColor: Colors.red,
                                                                                                  shape: RoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                                                                                                  ),
                                                                                                ),
                                                                                              )),
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
                                                                            data: controller.complaintlist.value.data?[index].complaintN == null
                                                                                ? "Job remaining"
                                                                                : controller.complaintlist.value.data![index].complaintN.toString(),
                                                                            fontSize:
                                                                                16.sp,
                                                                          ),
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
                                                                            "Contact Person: ",
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      CustomText(
                                                                        data: controller.complaintlist.value.data?[index].contactPerson ==
                                                                                null
                                                                            ? ""
                                                                            : controller.complaintlist.value.data![index].contactPerson.toString(),
                                                                        fontSize:
                                                                            16.sp,
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
                                                                            "Contact Number: ",
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      CustomText(
                                                                        data: controller.complaintlist.value.data?[index].contactNo ==
                                                                                null
                                                                            ? ""
                                                                            : controller.complaintlist.value.data![index].contactNo.toString(),
                                                                        fontSize:
                                                                            16.sp,
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
                                                                            "Remark: ",
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      CustomText(
                                                                        data: controller.complaintlist.value.data?[index].cAcceptRemarks ==
                                                                                "Completed"
                                                                            ? "Completed"
                                                                            : controller.complaintlist.value.data?[index].cAcceptRemarks == "Rejected"
                                                                                ? "Rejected"
                                                                                : controller.complaintlist.value.data![index].acceptRemarks.toString().isNotEmpty
                                                                                    ? "Accepted It "
                                                                                    : controller.complaintlist.value.data![index].remakrs.toString(),
                                                                        fontSize:
                                                                            16.sp,
                                                                        color: controller.complaintlist.value.data?[index].cAcceptRemarks ==
                                                                                "Completed"
                                                                            ? Colors.green
                                                                            : Colors.red,
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
                                                                            "Accept Name: ",
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      CustomText(
                                                                        data: controller.complaintlist.value.data?[index].acceptName ==
                                                                                null
                                                                            ? ""
                                                                            : controller.complaintlist.value.data![index].acceptName.toString(),
                                                                        fontSize:
                                                                            16.sp,
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
                                                                            "Final Remark: ",
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      CustomText(
                                                                        data: controller.complaintlist.value.data?[index].cAcceptStatus ==
                                                                                null
                                                                            ? ""
                                                                            : controller.complaintlist.value.data![index].cAcceptStatus.toString(),
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                          ),
                                        ),
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
                                                    .updateviewschedular();
                                              },
                                              child: CustomText(data: "Retry"),
                                            ),
                                          ],
                                        ),
                                      );
                                  }
                                },
                              ),
                            ),
                            Container(
                              width: Get.width,
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.r),
                                  bottomRight: Radius.circular(20.r),
                                ),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(AppRoutesName.complaint_view);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 6.h, horizontal: 10.w),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          color: CustomColor.blueColor),
                                      child: CustomText(
                                        data: "View All",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 5.h,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0.6),
                                blurRadius: 8.r,
                                color: Colors.indigo.shade100,
                              ),
                            ]),
                        child: Column(
                          children: [
                            Container(
                              width: Get.width,
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.r),
                                    topRight: Radius.circular(20.r),
                                  ),
                                  color: CustomColor.blueColor),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 60.w,
                                  ),
                                  CustomText(
                                    data: "Assigned Job",
                                    color: Colors.white,
                                    fontSize: 22.sp,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(AppRoutesName
                                          .next_day_followuo_screen);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.h, horizontal: 10.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
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
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
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
                                      return SizedBox(
                                        height: 200.h,
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
                                          child: controller
                                                      .viewtodayFollowupDataList
                                                      .value
                                                      .data
                                                      ?.isEmpty ??
                                                  true
                                              ? Center(
                                                  child: CustomText(
                                                      data: "Data not found"),
                                                )
                                              : ListView.builder(
                                                  // reverse: true,
                                                  padding: EdgeInsets.zero,
                                                  itemCount: controller
                                                          .viewtodayFollowupDataList
                                                          .value
                                                          .data
                                                          ?.length ??
                                                      0,

                                                  itemBuilder:
                                                      (context, index) {
                                                    var item = controller
                                                        .viewtodayFollowupDataList
                                                        .value
                                                        .data![index];
                                                    String apiDate =
                                                        item.createDate ?? '';
                                                    DateTime dateString =
                                                        DateTime.parse(apiDate);
                                                    String followUpDate =
                                                        DateFormat(
                                                                "dd MMM yyyy hh:mm a")
                                                            .format(dateString);
                                                    return InkWell(
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    15.w,
                                                                vertical: 5.h),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    15.w,
                                                                vertical: 8.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.r),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              offset:
                                                                  const Offset(
                                                                      0, 4),
                                                              color: Colors
                                                                  .indigo
                                                                  .shade100,
                                                              blurRadius: 5.r,
                                                            ),
                                                            BoxShadow(
                                                              offset:
                                                                  const Offset(
                                                                      0, -1),
                                                              color: Colors
                                                                  .indigo
                                                                  .shade100,
                                                              blurRadius: 3.r,
                                                            ),
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
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16.sp,
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      const Icon(
                                                                          Icons
                                                                              .date_range),
                                                                      Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                10.w,
                                                                            vertical: 3.h),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.r),
                                                                        ),
                                                                        child:
                                                                            CustomText(
                                                                          data:
                                                                              DateFormat('dd MMMM yyyy').format(dateString),
                                                                          fontSize:
                                                                              16.sp,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Divider(),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: CustomText(
                                                                data: item
                                                                        .jobDetails ??
                                                                    "Job remaining",
                                                                fontSize: 16.sp,
                                                              ),
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
                                                                    if (controller
                                                                            .viewtodayFollowupDataList
                                                                            .value
                                                                            .data![index]
                                                                            .jobStatus ==
                                                                        "Pending") {
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
                                                                              style: TextStyle(
                                                                                fontSize: 16.sp,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            actions: [
                                                                              Align(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Text(
                                                                                  "Date",
                                                                                  style: TextStyle(
                                                                                    fontSize: 16.sp,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 50.h,
                                                                                width: double.infinity,
                                                                                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.grey.shade200,
                                                                                  borderRadius: BorderRadius.circular(50.r),
                                                                                ),
                                                                                child: TextFormField(
                                                                                  controller: controller.updatedate,
                                                                                  readOnly: true,
                                                                                  decoration: const InputDecoration(
                                                                                    suffixIcon: Icon(Icons.calendar_month),
                                                                                    border: InputBorder.none,
                                                                                    hintText: "Date",
                                                                                  ),
                                                                                  onTap: () async {
                                                                                    DateTime today = DateTime.now();
                                                                                    DateTime? pickedDate = await showDatePicker(
                                                                                      context: context,
                                                                                      firstDate: today,
                                                                                      lastDate: DateTime(2025, 12, 31),
                                                                                      initialDate: today,
                                                                                    );

                                                                                    if (pickedDate == null) return;
                                                                                    controller.updatedate.text = DateFormat('yyyy-MM-dd').format(pickedDate);

                                                                                    // Automatically update Leave To Date (one day after Leave From Date)
                                                                                    //controller.LeaveTo.text = DateFormat('yyyy-MM-dd').format(pickedDate.add(Duration(days: 1)));

                                                                                    print("Time ${controller.updatedate.text}");
                                                                                  },
                                                                                  validator: (value) {
                                                                                    if (value!.isEmpty) {
                                                                                      return 'Required Field';
                                                                                    }
                                                                                    return null;
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                                                                                decoration: BoxDecoration(),
                                                                                child: Align(
                                                                                  alignment: Alignment.centerLeft,
                                                                                  child: Text(
                                                                                    "Status",
                                                                                    style: TextStyle(
                                                                                      fontSize: 16.sp,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 6.h,
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
                                                                                        .map(
                                                                                          (status) => DropdownMenuItem<String>(
                                                                                            value: status,
                                                                                            child: Text(status),
                                                                                          ),
                                                                                        )
                                                                                        .toList(),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              TextButton(
                                                                                onPressed: () async {
                                                                                  // Handle the submit action here
                                                                                  Map<String, dynamic> jobData = {
                                                                                    "JobStatus": controller.jobStatus.value,
                                                                                    "Completedate": controller.updatedate.text,
                                                                                    "CreateBy": item.createBy,
                                                                                    "JobAssignId": item.jobAssignId
                                                                                  };
                                                                                  controller.updateJobStatus(jobData);
                                                                                  Navigator.pop(context);
                                                                                  ShortMessage.toast(title: "Submitted");
                                                                                },
                                                                                child: const Text('Submit'),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    }
                                                                  },
                                                                  child:
                                                                      CustomText(
                                                                    data: controller
                                                                            .viewtodayFollowupDataList
                                                                            .value
                                                                            .data![index]
                                                                            .jobStatus ??
                                                                        "",
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: controller.viewtodayFollowupDataList.value.data![index].jobStatus ==
                                                                            "Pending"
                                                                        ? Colors
                                                                            .red
                                                                        : controller.viewtodayFollowupDataList.value.data![index].jobStatus ==
                                                                                "Completed"
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
                                                                      "Assigned By ",
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                CustomText(
                                                                  data:
                                                                      item.createBy ??
                                                                          "",
                                                                  fontSize:
                                                                      16.sp,
                                                                ),
                                                              ],
                                                            ),
                                                            Divider(),
                                                            item.jobImage !=
                                                                    null
                                                                ? Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .download_for_offline_outlined,
                                                                          color: Colors
                                                                              .green
                                                                              .withOpacity(0.6),
                                                                          size:
                                                                              17,
                                                                        ),
                                                                        CustomText(
                                                                          data:
                                                                              "Download",
                                                                          color:
                                                                              CustomColor.blueColor,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
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
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                controller
                                                    .updateDataListApiTodatfollowup();
                                              },
                                              child: CustomText(data: "Retry"),
                                            ),
                                          ],
                                        ),
                                      );
                                    default:
                                      return const Center(
                                          child: CircularProgressIndicator());
                                  }
                                },
                              ),
                            ),
                            Container(
                              width: Get.width,
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.r),
                                  bottomRight: Radius.circular(20.r),
                                ),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(
                                          AppRoutesName.assigned_job_screen);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 6.h, horizontal: 10.w),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          color: CustomColor.blueColor),
                                      child: CustomText(
                                        data: "View All",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.h, vertical: 5.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0.6),
                                blurRadius: 8.r,
                                color: Colors.indigo.shade100,
                              ),
                            ]),
                        child: Column(
                          children: [
                            Container(
                              width: Get.width,
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.r),
                                    topRight: Radius.circular(20.r),
                                  ),
                                  color: CustomColor.blueColor),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90.w,
                                  ),
                                  CustomText(
                                    data: "Scheduler",
                                    color: Colors.white,
                                    fontSize: 22.sp,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(
                                          AppRoutesName.Scheduler_screen);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.h, horizontal: 10.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
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
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
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
                                      return SingleChildScrollView(
                                        child: SizedBox(
                                          height: 165.h,
                                          child: CustomRefreshIndicator(
                                            leadingScrollIndicatorVisible:
                                                false,
                                            trailingScrollIndicatorVisible:
                                                false,
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
                                                  .updateviewschedular();
                                            }),
                                            child:
                                                controller
                                                            .viewSchedularList
                                                            .value
                                                            .data
                                                            ?.length ==
                                                        null
                                                    ? ListView.builder(
                                                        //reverse: true,
                                                        itemCount: 1,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Center(
                                                            child: CustomText(
                                                                data:
                                                                    "Data not found"),
                                                          );
                                                        })
                                                    : ListView.builder(
                                                        // reverse: true,
                                                        padding:
                                                            EdgeInsets.zero,
                                                        itemCount: controller
                                                            .viewSchedularList
                                                            .value
                                                            .data
                                                            ?.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          String apiDate =
                                                              "${controller.viewSchedularList.value.data![index].createDate}";

                                                          DateTime dateString =
                                                              DateTime.parse(
                                                                  apiDate);
                                                          String folloupDate =
                                                              DateFormat(
                                                                      "dd MMM yyyy hh:mm a")
                                                                  .format(
                                                                      dateString);

                                                          return InkWell(
                                                            child: Container(
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
                                                                                data: controller.viewSchedularList.value.data?[index].createDate == null ? "" : DateFormat('dd MMMM yyyy').format(DateTime.parse(controller.viewSchedularList.value.data![index].createDate.toString())),
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
                                                                            data: controller.viewSchedularList.value.data?[index].description == null
                                                                                ? "Job remaining"
                                                                                : controller.viewSchedularList.value.data![index].description.toString(),
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
                                                                                        controller.viewSchedularList.value.data![index].schedulerId.toString(),
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
                                                                          data: controller.viewSchedularList.value.data![index].status ??
                                                                              "",
                                                                          fontSize:
                                                                              16.sp,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color: controller.viewSchedularList.value.data![index].status == "Pending"
                                                                              ? Colors.red
                                                                              : controller.viewSchedularList.value.data![index].status == "Completed"
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
                                                                        data: controller.viewSchedularList.value.data?[index].namee ==
                                                                                null
                                                                            ? ""
                                                                            : controller.viewSchedularList.value.data![index].namee.toString(),
                                                                        fontSize:
                                                                            16.sp,
                                                                        //fontWeight: FontWeight.w500,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                          ),
                                        ),
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
                                                      .updateviewschedular();
                                                },
                                                child:
                                                    CustomText(data: "Retry"))
                                          ],
                                        ),
                                      );
                                  }
                                },
                              ),
                            ),
                            Container(
                              width: Get.width,
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.r),
                                  bottomRight: Radius.circular(20.r),
                                ),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(
                                          AppRoutesName.schedular_view_);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 6.h, horizontal: 10.w),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          color: CustomColor.blueColor),
                                      child: CustomText(
                                        data: "View All",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                : const Text("Fill the attendance first"),

            // controller.present.value ?  : Text("Fill the attendance first") ,
            // SizedBox(
            //   height: 20.h,
            // ),
          ],
        ),
      ),
    );
  }
}
