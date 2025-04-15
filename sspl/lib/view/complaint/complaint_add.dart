import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sspl/controllers/complaint/complaint_controller.dart';
import '../../utilities/custom_color/custom_color.dart';
import '../../utilities/custom_text/custom_text.dart';
import 'package:http/http.dart' as https;

import '../../infrastructure/routes/page_constants.dart';
import '../../utilities/custom_color/custom_color.dart';
import '../../utilities/custom_text/custom_text.dart';

class AddComplaint extends GetView<ComplaintController> {
  @override
  Widget build(BuildContext context) {
    Future<void> addComplaint(
      customer,
      contactperson,
      contactno,
      complain,
      Remark,
      empid,
    ) async {
      const String url =
          'http://sarvaperp.eduagentapp.com/api/SarvapErp/AddComplaint';

      // Create the request body
      Map<dynamic, dynamic> body = {
        "CustomerName": customer.toString(),
        "ContactPerson": contactperson.toString(),
        "ContactNo": contactno.toString(),
        "ComplaintN": complain.toString(),
        "Remakrs": Remark.toString(),
        "CreateBy": empid.toString()
      };
      print(body);

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
          print('Complain added successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Complaint Submit Successfully")),
          );
        } else {
          // Print error message if the request was not successful
          print('Failed to add Enquiry. Status code: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to Submit Complaint")),
          );
        }
      } catch (e) {
        // Handle any exceptions that occur during the request
        print('Error occurred while adding enquiry: $e');
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: CustomText(
              data: 'Add Complaint',
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
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 13, top: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      data: "Customer Name",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                /* Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w, vertical: 4.h,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Obx(
                      () => DropdownButtonFormField<String>(
                    value: controller.Customer.value.isEmpty ? null : controller.Customer.value,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.Customer.value = newValue; // Update the RxString value
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "",
                      border: InputBorder.none,
                    ),
                    */ /*hint: Text(
                          "Status",
                          style: GoogleFonts.roboto(color: Colors.grey),
                        ),*/ /*
                    items: ["Shubham", "Vansh","Deepak","Amit"]
                        .map((leaveType) => DropdownMenuItem<String>(
                      value: leaveType,
                      child: Text(leaveType),
                    ))
                        .toList(),
                  ),
                ),
              ),*/
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
                    controller: controller.customer,
                    decoration: InputDecoration(
                      hintText: "Customer",
                      hintStyle: GoogleFonts.roboto(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.only(left: 13),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      data: "Contact Person",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
                    controller: controller.ContactPerson,
                    decoration: InputDecoration(
                      hintText: "Contact Person",
                      hintStyle: GoogleFonts.roboto(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.only(left: 13),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      data: "Contact Number",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
                    keyboardType: TextInputType.number,
                    controller: controller.ContactNo,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      // Limit to 10 digits
                      FilteringTextInputFormatter.digitsOnly,
                      // Allow only digits
                    ],
                    decoration: InputDecoration(
                      hintText: "Contact Number",
                      hintStyle: GoogleFonts.roboto(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.only(left: 13),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      data: "Complaint",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
                    controller: controller.Complaint,
                    decoration: InputDecoration(
                      hintText: "Complaint",
                      hintStyle: GoogleFonts.roboto(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.only(left: 13),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      data: "Remark",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
                    controller: controller.Remark,
                    decoration: InputDecoration(
                      hintText: "Remark",
                      hintStyle: GoogleFonts.roboto(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      addComplaint(
                          controller.customer.value.text,
                          controller.ContactPerson.value.text,
                          controller.ContactNo.value.text,
                          controller.Complaint.value.text,
                          controller.Remark.value.text,
                          controller.Empid.value);
                      // controller.dispose();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.w, vertical: 10.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          color: CustomColor.blueColor,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 0.9),
                                blurRadius: 8.r,
                                color: CustomColor.blueColor)
                          ]),
                      child: CustomText(
                        data: "Save",
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
