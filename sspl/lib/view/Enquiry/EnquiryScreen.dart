import 'dart:convert';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sspl/controllers/AddNewController/AddNewCoustomer.dart';
import 'package:sspl/controllers/EnquiryScreenController/EnquiryScreenController.dart';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';
import 'package:sspl/infrastructure/routes/page_constants.dart';
import 'package:sspl/infrastructure/routes/page_routes.dart';
import 'package:sspl/utilities/custom_color/custom_color.dart';
import 'package:http/http.dart' as https;
import '../../controllers/expense/add_expense_view_model.dart';
import '../../controllers/leave/leave_screen_controller.dart';
import '../../infrastructure/image_constants/image_constants.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../sevices/models/expense/view_expenses.dart';
import '../../utilities/custom_text/custom_text.dart';
import '../../utilities/custom_toast/custom_toast.dart';

class EnquiryScreen extends GetView<EnquiryController> {
  const EnquiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //function to add the information
    Future<void> addEnquiry(
      customerName,
      cityName,
      contactPerson,
      contactNo,
      emailId,
      eStatus,
      enquiryDetails,
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

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Get.toNamed(AppRoutesName.Enquiry_visit);
            },
            child: const Icon(Icons.arrow_back),
          ),
          title: Image.asset(
            ImageConstants.logo,
            width: 130.h,
          ),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              width: Get.width,
              // padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 3.h),
              //margin: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
              decoration: const BoxDecoration(
                //borderRadius: BorderRadius.circular(6.r),
                color: CustomColor.blueColor,
              ),
              child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 3.h),
                margin: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: CustomColor.blueColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      data: "Add new enquiry",
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              )),
          SizedBox(
            height: 10.h,
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.white,
              ),
              child: Form(
                  key: controller.formKey.value,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(data: "Customer Name"),
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
                                  controller: controller.Customername,
                                  decoration: InputDecoration(
                                    hintText: "Customer Name",
                                    hintStyle:
                                        GoogleFonts.roboto(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              CustomText(data: "City Name"),
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
                                  controller: controller.Cityname,
                                  decoration: InputDecoration(
                                    hintText: "City Name",
                                    hintStyle:
                                        GoogleFonts.roboto(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              CustomText(data: "Contact Person"),
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
                                  controller: controller.Contactperson,
                                  decoration: InputDecoration(
                                    hintText: "Contact Person",
                                    hintStyle:
                                        GoogleFonts.roboto(color: Colors.grey),
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
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: controller.ContactNo,
                                  decoration: InputDecoration(
                                    hintText: "Contact NO",
                                    hintStyle:
                                        GoogleFonts.roboto(color: Colors.grey),
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
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: controller.Emailid,
                                  decoration: InputDecoration(
                                    hintText: "Email ID",
                                    hintStyle:
                                        GoogleFonts.roboto(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              CustomText(data: "Status"),
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
                                child: Obx(
                                  () => DropdownButtonFormField<String>(
                                    value: controller.status.value.isEmpty
                                        ? null
                                        : controller.status.value,
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        controller.status.value =
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
                                    items: ["Pending", "Completed"]
                                        .map((leaveType) =>
                                            DropdownMenuItem<String>(
                                              value: leaveType,
                                              child: Text(leaveType),
                                            ))
                                        .toList(),
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
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: controller.EnquiryDetails,
                                  decoration: InputDecoration(
                                    hintText: "Enquiry Details",
                                    hintStyle:
                                        GoogleFonts.roboto(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  final isValid = controller
                                      .formKey.value.currentState!
                                      .validate();
                                  if (controller.Customername.value.text
                                          .toString()
                                          .isEmpty &&
                                      controller.Cityname.value.text
                                          .toString()
                                          .isEmpty) {
                                    ShortMessage.toast(
                                        title: "Please fill all fields");
                                  } else {
                                    addEnquiry(
                                      controller.Customername.value.text,
                                      controller.Cityname.value.text,
                                      controller.Contactperson.value.text,
                                      controller.ContactNo.value.text,
                                      controller.Emailid.value.text,
                                      controller.status.value,
                                      controller.EnquiryDetails.value.text,
                                      controller.empid,
                                    );
                                  }
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
                                    data: "Submit",
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  )))
        ])));
  }
}
