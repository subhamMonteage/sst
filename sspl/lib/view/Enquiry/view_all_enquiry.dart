import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sspl/controllers/EnquiryScreenController/view_all_enquiry_controller.dart';

import '../../controllers/EnquiryScreenController/EnquiryScreenController.dart';
import '../../infrastructure/image_constants/image_constants.dart';
import '../../utilities/custom_color/custom_color.dart';
import '../../utilities/custom_text/custom_text.dart';
import 'package:http/http.dart' as https;

class ViewAllEnquiry extends GetView<ViewAllEnquiryController> {
  @override
  Widget build(BuildContext context) {
    Future<void> updatestatus(
      EnquiryId,
      estatus,
      createBy,
    ) async {
      const String url =
          'http://sarvaperp.eduagentapp.com/api/SarvapErp/EnquiryStatus';

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

    String date = controller.createDate.value.toString();
    DateTime dateTime = DateTime.parse(date);
    String formattedtime = DateFormat("HH:mm:ss a").format(dateTime);
    String formatteddate = DateFormat("dd MMM yyy").format(dateTime);

    // TODO: implement build
    return Scaffold(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      data: "Enquiry",
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              )),
          Container(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            data: "Time :",
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                          SizedBox(
                            width: 30.w,
                          ),
                          CustomText(
                            data: formattedtime,
                            fontSize: 16.sp,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomText(
                            data: "Date :",
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                          SizedBox(
                            width: 30.w,
                          ),
                          CustomText(
                            data: formatteddate,
                            fontSize: 16.sp,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        data: "Contact Person :",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      CustomText(
                        data: controller.contactPerson.value,
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
                        data: "Customer Name :",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      CustomText(
                        data: controller.customerName.value,
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
                        data: "City Name :",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      CustomText(
                        data: controller.cityName.value,
                        fontSize: 16.sp,
                      ),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(5.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          data: "Enquiry Details :",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          data: controller.enquiryDetails.value,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: EdgeInsets.all(5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        data: "Contact no :",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      CustomText(
                        data: controller.contactNo.value,
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
                        data: "Email ID :",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      CustomText(
                        data: controller.emailId.value,
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
                      CustomText(data: "Status :", fontWeight: FontWeight.bold),
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 4.h),
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 4.h),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                    child: Obx(
                                      () => DropdownButtonFormField<String>(
                                        value: controller.EnquiryUpdateStatus
                                                .value.isEmpty
                                            ? null
                                            : controller
                                                .EnquiryUpdateStatus.value,
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            controller
                                                    .EnquiryUpdateStatus.value =
                                                newValue; // Update the RxString value
                                          }
                                        },
                                        decoration: const InputDecoration(
                                          hintText: "",
                                          border: InputBorder.none,
                                        ),
                                        hint: Text(
                                          "Status",
                                          style: GoogleFonts.roboto(
                                              color: Colors.grey),
                                        ),
                                        items: ["Completed"]
                                            .map((leaveType) =>
                                                DropdownMenuItem<String>(
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
                                          controller.enquiryId,
                                          controller.EnquiryUpdateStatus,
                                          controller.empid.value.toString());
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
                          data: controller.eStatus == null
                              ? ""
                              : controller.eStatus.toString(),
                          fontWeight: FontWeight.w500,
                          color: controller.eStatus == "Pending"
                              ? Colors.red
                              : controller.eStatus == "Completed"
                                  ? Colors.green
                                  : Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
