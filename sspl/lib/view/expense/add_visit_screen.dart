import 'dart:convert';
import 'dart:ffi';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sspl/controllers/AddNewController/AddNewCoustomer.dart';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';
import 'package:sspl/infrastructure/routes/page_constants.dart';
import 'package:sspl/infrastructure/routes/page_routes.dart';
import 'package:sspl/utilities/custom_color/custom_color.dart';
import 'package:http/http.dart' as http;
import '../../controllers/AddNewController/AddNewCoustomer.dart';
import '../../controllers/expense/add_expense_view_model.dart';
import '../../controllers/leave/leave_screen_controller.dart';
import '../../infrastructure/image_constants/image_constants.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../sevices/models/expense/view_expenses.dart';
import '../../utilities/custom_text/custom_text.dart';
import '../../utilities/custom_toast/custom_toast.dart';

class AddNewScreen extends GetView<AddNewController> {
  @override
  Widget build(BuildContext context) {
    //function to add the information
    Future<void> addExpense(
      empId,
      vDate,
      vPurpose,
      vcustomerName,
      vcityName,
      vcontactPersonName,
      vContactNO,
      vEmailId,
      vVisitdetails,
      EPurpose,
      EAmount,
      EPublicConveyance,
      Eamount,
      EtravelKm,
      EAmount2,
      EexpenseDetiails,
    ) async {
      const String url =
          'http://sarvaperp.eduagentapp.com/api/SarvapErp/AddEmpMarktingExp';

      // Create the request body
      Map<dynamic, String> body = {
        "VisitDate": vDate.toString(),
        "Purpose": vPurpose.toString(),
        "CustomerName": vcustomerName.toString(),
        "CityName": vcityName.toString(),
        "ContactPersonName": vcontactPersonName.toString(),
        "ContactNo": vContactNO.toString(),
        "emailid": vEmailId.toString(),
        "VisitDetails": vVisitdetails.toString(),
        "EXPPurpose": EPurpose.toString(),
        "EXPAmount ": EAmount.toString(),
        "EXPPublicConveDetails": EPublicConveyance.toString(),
        "EXPAmount2": Eamount.toString(),
        "EXPTravelKmVehicle": EtravelKm.toString(),
        "EXPAmount3": EAmount2.toString(),
        "EXPExpensedetails": EexpenseDetiails.toString(),
        "CreateBy": empId.toString(),
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
          print('Expense added successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Expense update successfully"),
            ),
          );
          //print('Response body: ${response.body}');
        } else {
          // Print error message if the request was not successful
          print(
              'Failed to update expense. Status code: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to update expense. Status code:"),
            ),
          );

          //print('Response body: ${response.body}');
        }
      } catch (e) {
        // Handle any exceptions that occur during the request
        print('Error occurred while adding expense: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error occurred while adding expense:"),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
          title: CustomText(
            data: 'Update Expense',
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
          child: Column(children: [
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          data: "Visit Date",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        Container(
                          height: 50.h,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 4.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: TextFormField(
                            controller: controller.updateVisit,
                            readOnly: true,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.calendar_month),
                              border: InputBorder.none,
                              hintText: "Visit Date",
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
                              controller.updateVisit.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);

                              // Automatically update Leave To Date (one day after Leave From Date)
                              //controller.LeaveTo.text = DateFormat('yyyy-MM-dd').format(pickedDate.add(Duration(days: 1)));

                              print("Time ${controller.Visit.text}");
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Required Field';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        CustomText(data: "Purpose"),
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
                              value: controller.updatepurpose.value.isEmpty
                                  ? null
                                  : controller.updatepurpose.value,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller.updatepurpose.value =
                                      newValue; // Update the RxString value
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: "",
                                border: InputBorder.none,
                              ),
                              hint: Text(
                                "Purpose",
                                style: GoogleFonts.roboto(color: Colors.grey),
                              ),
                              items: ["Service", "Sale", "Both"]
                                  .map((leaveType) => DropdownMenuItem<String>(
                                        value: leaveType,
                                        child: Text(leaveType),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
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
                                controller: controller.customername,
                                //enabled: false,
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
                            CustomText(data: "Contact Person Name"),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 4.h),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: TextFormField(
                                //enabled: false,
                                keyboardType: TextInputType.text,
                                controller: controller.contactpersonN,
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
                                //enabled: false,
                                keyboardType: TextInputType.number,
                                controller: controller.contactNO,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  // Limit to 10 digits
                                  FilteringTextInputFormatter.digitsOnly,
                                  // Allow only digits
                                ],
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
                                //enabled: false,
                                keyboardType: TextInputType.text,
                                controller: controller.EmailiD,
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
                                //enabled: false,
                                keyboardType: TextInputType.text,
                                controller: controller.cityNamE,
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
                            CustomText(data: "Visit Details"),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 4.h),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: TextFormField(
                                //enabled: false,
                                keyboardType: TextInputType.text,
                                controller: controller.VisitDetailS,
                                decoration: InputDecoration(
                                  hintText: "Visit Details",
                                  hintStyle:
                                      GoogleFonts.roboto(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Expense Section",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 19),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            CustomText(data: "Purpose"),
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
                                  value: controller
                                          .updateexpensepurpose.value.isEmpty
                                      ? null
                                      : controller.updateexpensepurpose.value,
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      controller.updateexpensepurpose.value =
                                          newValue; // Update the RxString value
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "",
                                    border: InputBorder.none,
                                  ),
                                  hint: Text(
                                    "Purpose",
                                    style:
                                        GoogleFonts.roboto(color: Colors.grey),
                                  ),
                                  items: [
                                    "Hotel Stay",
                                    "DA",
                                    "Customer RefreshMent",
                                    "Team RefreshMent",
                                    "Cash Purchase",
                                    "Any Compensatory"
                                  ]
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
                            CustomText(data: "Amount"),
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
                                controller: controller.updateAmount,
                                decoration: InputDecoration(
                                  hintText: "Amount",
                                  hintStyle:
                                      GoogleFonts.roboto(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            CustomText(data: "Public Conveyance Details"),
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
                                controller: controller.updatepubliccon,
                                decoration: InputDecoration(
                                  hintText: "Public Conveyance Details",
                                  hintStyle:
                                      GoogleFonts.roboto(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            CustomText(data: "Amount"),
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
                                controller: controller.updateAmount2,
                                decoration: InputDecoration(
                                  hintText: "Amount",
                                  hintStyle:
                                      GoogleFonts.roboto(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            CustomText(data: "Travel KM By Vehicle"),
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
                                controller: controller.updatetravel,
                                decoration: InputDecoration(
                                  hintText: "Travel KM By Vehicle",
                                  hintStyle:
                                      GoogleFonts.roboto(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            CustomText(data: "Amount"),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 4.h),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: TextFormField(
                                // readOnly: true,
                                keyboardType: TextInputType.number,
                                controller: controller.updatetravelamount,
                                decoration: InputDecoration(
                                  hintText: "Amount",
                                  hintStyle:
                                      GoogleFonts.roboto(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                                // readOnly: true,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            CustomText(data: "Expense Details"),
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
                                controller: controller.updateExpenseDetails,
                                decoration: InputDecoration(
                                  hintText: "Enter Expense Details",
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
                                if (controller.Visit.value.text
                                        .toString()
                                        .isEmpty &&
                                    controller.CustomerName.value.text
                                        .toString()
                                        .isEmpty) {
                                  ShortMessage.toast(
                                      title: "Please fill all fields");
                                } else {}
                              },
                              child: InkWell(
                                onTap: () {
                                  addExpense(
                                      controller.empid.value,
                                      controller.updateVisit.value.text,
                                      controller.updatepurpose.value,
                                      controller.customername.value.text,
                                      controller.cityNamE.value.text,
                                      controller.contactpersonN.value.text,
                                      controller.ContactNO.value.text,
                                      controller.EmailiD.value.text,
                                      controller.VisitDetailS.value.text,
                                      controller.updateexpensepurpose.value,
                                      controller.updateAmount.value.text,
                                      controller.updatepubliccon.value.text,
                                      controller.updateAmount2.value.text,
                                      controller.updatetravel.value.text,
                                      controller.updatetravelamount.value.text,
                                      controller
                                          .updateExpenseDetails.value.text);
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
                                    data: "Update",
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                )))
      ])),
    );
  }
}
