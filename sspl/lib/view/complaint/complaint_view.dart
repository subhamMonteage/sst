import 'dart:convert';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sspl/controllers/complaint/complaint_controller.dart';
import 'package:http/http.dart' as http;
import '../../infrastructure/routes/page_constants.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../utilities/custom_color/custom_color.dart';
import '../../utilities/custom_text/custom_text.dart';

class ComplaintView extends GetView<ComplaintController> {
  @override
  Widget build(BuildContext context) {
    Future<void> updatecomplaint(
        complaintId, acceptid, acceptstatus, acceptRemark) async {
      const String url =
          'http://sarvaperp.eduagentapp.com/api/SarvapErp/AddAccptComplaint';

      // Create the request body
      Map<dynamic, dynamic> body = {
        "ComplaintId": complaintId.toString(),
        "AcceptId": acceptid.toString(),
        "AcceptRemarks": acceptstatus.toString(),
        "AcceptStatus": acceptRemark.toString(),
      };
      print("body in update ${body.toString()}");
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
          print(response.body);
          print(url);
          print('Complain Update successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Update Successfully")),
          );
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
        ccomplaintId, acceptid, acceptstatus, acceptRemark) async {
      const String url =
          'http://sarvaperp.eduagentapp.com/api/SarvapErp/AddCompleteComplaint';

      // Create the request body
      Map<dynamic, dynamic> body = {
        "ComplaintId": ccomplaintId.toString(),
        "CAcceptId": acceptid.toString(),
        "CAcceptRemarks": acceptstatus.toString(),
        "CAcceptStatus": acceptRemark.toString(),
      };
      print("body in cupdate ${body.toString()}");

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

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: CustomText(
            data: 'Complaint',
            color: Colors.white,
            fontSize: 20.sp,
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: CustomColor.blueColor,
          actions: [
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutesName.complaint_add);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
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
      body: SingleChildScrollView(
        child: SizedBox(
          height: 700.h,
          child: CustomRefreshIndicator(
            leadingScrollIndicatorVisible: false,
            trailingScrollIndicatorVisible: false,
            builder: MaterialIndicatorDelegate(
              builder: (context, controller) {
                return Icon(
                  Icons.refresh,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                );
              },
              scrollableBuilder: (context, child, controller) {
                return Opacity(
                  opacity: 1.0 - controller.value.clamp(0.0, 1.0),
                  child: child,
                );
              },
            ).call,
            onRefresh: () =>
                Future.delayed(const Duration(milliseconds: 2), () async {
              await controller.ComplaintViewApi();
            }),
            child: Column(
              children: [
                Obx(
                  () {
                    switch (controller.rxRequestStatus.value) {
                      case Status.Loading:
                        return Center(
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
                                  size: 20,
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
                                const Duration(milliseconds: 2), () async {
                              await controller.ComplaintViewApi();
                            }),
                            child: controller
                                        .complaintlist.value.data?.length ==
                                    null
                                ? CustomText(data: "Data not found")
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: controller
                                        .complaintlist.value.data?.length,
                                    itemBuilder: (context, index) {
                                      int reverseIndex = controller
                                              .complaintlist
                                              .value
                                              .data!
                                              .length -
                                          1 -
                                          index;
                                      String attendanceDate = controller
                                                  .complaintlist
                                                  .value
                                                  .data?[reverseIndex]
                                                  .date ==
                                              null
                                          ? ""
                                          : controller.complaintlist.value
                                              .data![reverseIndex].date
                                              .toString();

                                      return InkWell(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w, vertical: 5.h),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 15.w, vertical: 8.h),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: const Offset(0, 4),
                                                  color: Colors.indigo.shade100,
                                                  blurRadius: 5.r),
                                              BoxShadow(
                                                  offset: const Offset(0, -1),
                                                  color: Colors.indigo.shade100,
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
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: CustomText(
                                                      data: "Complaint :",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.sp,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Container(
                                                        height: 20,
                                                        width: 150,
                                                        child: controller
                                                                    .complaintlist
                                                                    .value
                                                                    .data![
                                                                        index]
                                                                    .acceptRemarks
                                                                    .toString() ==
                                                                "null"
                                                            ? ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        title: Text(
                                                                            "Accept Complaint"),
                                                                        content:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
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
                                                                                    items: [
                                                                                      "Accepted",
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
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed:
                                                                                () async {
                                                                              updatecomplaint(
                                                                                controller.complaintlist.value.data?[index].complaintId.toString(),
                                                                                controller.Empid.value,
                                                                                controller.Remarkupdate.value,
                                                                                controller.updatremark.value.text,
                                                                              );
                                                                              Get.back(); // Close the dialog
                                                                              await controller.ComplaintViewApi(); // Refresh data
                                                                            },
                                                                            child:
                                                                                Text("Accept"),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: Text(
                                                                  "Tap Me To Accept",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          9),
                                                                ),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              )
                                                            : controller
                                                                        .complaintlist
                                                                        .value
                                                                        .data![
                                                                            index]
                                                                        .cAcceptStatus
                                                                        .toString() ==
                                                                    "null"
                                                                ? ElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      await showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text("Complete Complaint"),
                                                                            content:
                                                                                SingleChildScrollView(
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
                                                                                        items: [
                                                                                          "Completed",
                                                                                          "Rejected"
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
                                                                                        Cupdatecomplaint(controller.complaintlist.value.data?[index].complaintId.toString(), controller.Empid.value, controller.CRemarkupdate.value, controller.Cupdatremark.value.text); // Clos
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
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              9),
                                                                    ),
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .orangeAccent,
                                                                    ),
                                                                  )
                                                                : controller
                                                                            .complaintlist
                                                                            .value
                                                                            .data![
                                                                                index]
                                                                            .cAcceptRemarks
                                                                            .toString() ==
                                                                        'Rejected'
                                                                    ? ElevatedButton(
                                                                        onPressed:
                                                                            () {},
                                                                        child:
                                                                            Text(
                                                                          "Rejected",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 9),
                                                                        ),
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          backgroundColor:
                                                                              Colors.red,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20.0), // Adjust the radius as needed
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : controller.complaintlist.value.data![index].cAcceptRemarks.toString() ==
                                                                            'Completed'
                                                                        ? ElevatedButton(
                                                                            onPressed:
                                                                                () {},
                                                                            child:
                                                                                Text(
                                                                              "Completed",
                                                                              style: TextStyle(color: Colors.white, fontSize: 9),
                                                                            ),
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              backgroundColor: Colors.green,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : ElevatedButton(
                                                                            onPressed:
                                                                                () {},
                                                                            child:
                                                                                Text(
                                                                              "Rejected",
                                                                              style: TextStyle(color: Colors.white, fontSize: 9),
                                                                            ),
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              backgroundColor: Colors.red,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                                                                              ),
                                                                            ),
                                                                          )), /*Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  const Icon(Icons.date_range),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10.r),
                                                    ),
                                                    child: CustomText(
                                                      data: controller.complaintlist.value.data?[index].createDate == null
                                                          ? ""
                                                          : DateFormat('dd MMMM yyyy').format(DateTime.parse(controller.complaintlist.value.data![index].createDate.toString())),
                                                      fontSize: 16.sp,

                                                    ),
                                                  ),
                                                ],
                                              ),*/
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
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: CustomText(
                                                        data: controller
                                                                    .complaintlist
                                                                    .value
                                                                    .data?[
                                                                        index]
                                                                    .complaintN ==
                                                                null
                                                            ? "Job remaining"
                                                            : controller
                                                                .complaintlist
                                                                .value
                                                                .data![index]
                                                                .complaintN
                                                                .toString(),
                                                        fontSize: 16.sp,
                                                        //fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                    data: "Contact Person: ",
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  CustomText(
                                                    data: controller
                                                                .complaintlist
                                                                .value
                                                                .data?[index]
                                                                .contactPerson ==
                                                            null
                                                        ? ""
                                                        : controller
                                                            .complaintlist
                                                            .value
                                                            .data![index]
                                                            .contactPerson
                                                            .toString(),
                                                    fontSize: 16.sp,
                                                    //fontWeight: FontWeight.w500,
                                                  ),
                                                ],
                                              ),
                                              Divider(),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                    data: "Contact Number: ",
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  CustomText(
                                                    data: controller
                                                                .complaintlist
                                                                .value
                                                                .data?[index]
                                                                .contactNo ==
                                                            null
                                                        ? ""
                                                        : controller
                                                            .complaintlist
                                                            .value
                                                            .data![index]
                                                            .contactNo
                                                            .toString(),
                                                    fontSize: 16.sp,
                                                    //fontWeight: FontWeight.w500,
                                                  ),
                                                ],
                                              ),
                                              Divider(),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                    data: "Remark: ",
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  InkWell(
                                                    child: CustomText(
                                                      data: controller
                                                                  .complaintlist
                                                                  .value
                                                                  .data?[index]
                                                                  .cAcceptRemarks ==
                                                              "Completed"
                                                          ? "Completed"
                                                          : controller
                                                                      .complaintlist
                                                                      .value
                                                                      .data?[
                                                                          index]
                                                                      .cAcceptRemarks ==
                                                                  "Rejected"
                                                              ? "Rejected"
                                                              : controller
                                                                      .complaintlist
                                                                      .value
                                                                      .data![
                                                                          index]
                                                                      .acceptRemarks
                                                                      .toString()
                                                                      .isNotEmpty
                                                                  ? "Accepted It "
                                                                  : controller
                                                                      .complaintlist
                                                                      .value
                                                                      .data![
                                                                          index]
                                                                      .remakrs
                                                                      .toString(),
                                                      fontSize: 16.sp,
                                                      color: controller
                                                                  .complaintlist
                                                                  .value
                                                                  .data?[index]
                                                                  .cAcceptRemarks ==
                                                              "Completed"
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              /* AcceptId": 15,
                                        "AcceptName": "Test test",
                                        "AcceptRemarks": "demo",
                                        "AcceptStatus": "Accepted",
                                        "AcceptDate": "2024-06-11T17:04:13.3",
                                        "CAcceptId": 0,
                                        "CName": " ",
                                        "CAcceptRemarks": null,
                                        "CAcceptStatus": null,*/
                                              Divider(),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                    data: "Accept Name: ",
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  CustomText(
                                                    data: controller
                                                                .complaintlist
                                                                .value
                                                                .data?[index]
                                                                .acceptName ==
                                                            null
                                                        ? ""
                                                        : controller
                                                            .complaintlist
                                                            .value
                                                            .data![index]
                                                            .acceptName
                                                            .toString(),
                                                    fontSize: 16.sp,
                                                    //fontWeight: FontWeight.w500,
                                                  ),
                                                ],
                                              ),
                                              Divider(),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                    data: "Final Remark: ",
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  CustomText(
                                                    data: controller
                                                                .complaintlist
                                                                .value
                                                                .data?[index]
                                                                .cAcceptStatus ==
                                                            null
                                                        ? ""
                                                        : controller
                                                            .complaintlist
                                                            .value
                                                            .data![index]
                                                            .cAcceptStatus
                                                            .toString(),
                                                    fontSize: 16.sp,
                                                    //color: Colors.green,
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
                        );

                      case Status.Error:
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    controller.ComplaintViewApi();
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
          ),
        ),
      ),
    );
  }
}
