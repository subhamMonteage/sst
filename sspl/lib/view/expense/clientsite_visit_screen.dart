import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:provider/single_child_widget.dart';
import 'package:search_page/search_page.dart';
import 'package:sspl/infrastructure/routes/page_constants.dart';
import 'package:sspl/sevices/models/expense/view_expenses.dart';

import '../../controllers/AddNewController/AddNewCoustomer.dart';
import '../../controllers/dashboard/existing_sclient_screen_controller.dart';
import '../../infrastructure/image_constants/image_constants.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../sevices/models/attendance/view_attendance_model.dart';
import '../../sevices/models/expense/viewExpense_modal.dart';
import '../../utilities/custom_color/custom_color.dart';
import '../../utilities/custom_text/custom_text.dart';
import '../../utilities/custom_toast/custom_toast.dart';
import 'package:http/http.dart' as http;
import '../dashboard/firmVisit/existing_client_screen.dart';

class ClientSiteVisitScreen extends GetView<ExistingClientController> {
  @override
  Widget build(BuildContext context) {
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
      total,
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
        "EXPAmount": EAmount.toString(),
        "EXPPublicConveDetails": EPublicConveyance.toString(),
        "EXPAmount2": Eamount.toString(),
        "EXPTravelKmVehicle": EtravelKm.toString(),
        "EXPAmount3": EAmount2.toString(),
        "EXPExpensedetails": EexpenseDetiails.toString(),
        "CreateBy": empId.toString(),
        "Total": total.toString(),
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
              content: Text("Expense added successfully"),
            ),
          );
          //print('Response body: ${response.body}');
        } else {
          // Print error message if the request was not successful
          print('Failed to add expense. Status code: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to add expense. Status code:"),
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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: CustomText(
              data: 'Expense',
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
                      data: "Manage Expense",
                      color: Colors.black,
                    )),
                    Tab(
                        child: CustomText(
                      data: "Add Expense",
                      color: Colors.black,
                    )),
                    Tab(
                      child: CustomText(
                        data: "View Expense",
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
                        switch (controller.rxRequestStatus1.value) {
                          case Status.Loading:
                            return const Center(
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
                                            delegate: SearchPage<
                                                    VieExpenseData>(
                                                items: controller
                                                        .viewExpenseDataList
                                                        .value
                                                        .data ??
                                                    [],
                                                searchLabel: 'Search',
                                                suggestion: Center(
                                                  child: AutoSizeText(
                                                    'Filter by Expense Status , Customer Name',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                failure: Center(
                                                  child: AutoSizeText(
                                                    'Found Nothing :(',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                filter: (person) => [
                                                      person.eXPStatus,
                                                      person.customerName
                                                    ],
                                                builder: (person) {
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.w,
                                                            vertical: 10.h),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 15.h,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          offset: Offset(2, 6),
                                                          blurRadius: 8.r,
                                                          color: Colors
                                                              .blue.shade900,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  5.h),
                                                          child: Row(
                                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Icon(Icons
                                                                  .calendar_today),
                                                              CustomText(
                                                                  data: DateFormat(
                                                                          'dd MMMM yyyy')
                                                                      .format(DateTime.parse(person
                                                                          .visitDate
                                                                          .toString()))),
                                                              // CustomText(data: person.eXPStatus.toString(),color: Colors.green,),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  5.h),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              CustomText(
                                                                data:
                                                                    "Customer Name :",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              CustomText(
                                                                  data: person
                                                                      .customerName
                                                                      .toString()),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  5.h),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              CustomText(
                                                                data:
                                                                    "Contact Person :",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              CustomText(
                                                                  data: person
                                                                      .contactPersonName
                                                                      .toString()),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  5.h),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              CustomText(
                                                                data:
                                                                    "Contact Number :",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              CustomText(
                                                                  data: person
                                                                      .contactNo
                                                                      .toString()),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              var data = person;
                                                              Get.toNamed(
                                                                  AppRoutesName
                                                                      .update_expense,
                                                                  arguments: [
                                                                    person
                                                                        .customerName
                                                                        .toString(),
                                                                    data.contactPersonName
                                                                        .toString(),
                                                                    data.contactNo
                                                                        .toString(),
                                                                    data.emailId
                                                                        .toString(),
                                                                    data.cityName
                                                                        .toString(),
                                                                    data.visitDetails
                                                                        .toString()
                                                                  ]);
                                                            },
                                                            child: Text(
                                                              "Add",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    CustomColor
                                                                        .blueColor),
                                                          ),
                                                        )
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
                                                    right: 135.w),
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
                                                                      onTap: () =>
                                                                          controller
                                                                              .selectFromDate(context),
                                                                      child: controller.formattedFromDate.value ==
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
                                                                                data: '  ${controller.formattedFromDate.value}',
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
                                                                  onTap: () =>
                                                                      controller
                                                                          .selectToDate(
                                                                              context),
                                                                  child: controller
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
                                                          if (controller
                                                                      .formattedFromDate
                                                                      .value !=
                                                                  "" &&
                                                              controller
                                                                      .formattedToDate
                                                                      .value !=
                                                                  "") {
                                                            controller
                                                                .datefilterExpense();
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
                                                  BorderRadius.circular(40.r),
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
                                        controller.userExpenseView();
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
                      child: Column(children: [
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
                                        borderRadius:
                                            BorderRadius.circular(50.r),
                                      ),
                                      child: TextFormField(
                                        controller: controller.showvisit,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          suffixIcon:
                                              Icon(Icons.calendar_month),
                                          border: InputBorder.none,
                                          hintText: "Visit Date",
                                        ),
                                        onTap: () async {
                                          DateTime today = DateTime(2024, 1, 1);
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            firstDate: today,
                                            lastDate: DateTime(2025, 12, 31),
                                            initialDate: DateTime.now(),
                                          );

                                          if (pickedDate == null) return;
                                          controller.Visit.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                          controller.showvisit.text =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(pickedDate);

                                          // Automatically update Leave To Date (one day after Leave From Date)
                                          //controller.LeaveTo.text = DateFormat('yyyy-MM-dd').format(pickedDate.add(Duration(days: 1)));

                                          print(
                                              "Time ${controller.Visit.text}");
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
                                        borderRadius:
                                            BorderRadius.circular(50.r),
                                      ),
                                      child: Obx(
                                        () => DropdownButtonFormField<String>(
                                          value:
                                              controller.purpose.value.isEmpty
                                                  ? null
                                                  : controller.purpose.value,
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              controller.purpose.value =
                                                  newValue; // Update the RxString value
                                            }
                                          },
                                          decoration: const InputDecoration(
                                            hintText: "",
                                            border: InputBorder.none,
                                          ),
                                          hint: Text(
                                            "Purpose",
                                            style: GoogleFonts.roboto(
                                                color: Colors.grey),
                                          ),
                                          items: ["Service", "Sale", "Both"]
                                              .map((leaveType) =>
                                                  DropdownMenuItem<String>(
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
                                            controller: controller.CustomerName,
                                            decoration: InputDecoration(
                                              hintText: "Customer Name",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
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
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                          ),
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller:
                                                controller.ContactPerson,
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
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                              // Limit to 10 digits
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              // Allow only digits
                                            ],
                                            controller: controller.ContactNO,
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
                                            controller: controller.EmailId,
                                            decoration: InputDecoration(
                                              hintText: "Email ID",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
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
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                          ),
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller: controller.CityName,
                                            decoration: InputDecoration(
                                              hintText: "City Name",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
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
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                          ),
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller: controller.VisitDetails,
                                            decoration: InputDecoration(
                                              hintText: "Visit Details",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
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
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19),
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
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                          ),
                                          child: Obx(
                                            () =>
                                                DropdownButtonFormField<String>(
                                              value: controller.expensepurpose
                                                      .value.isEmpty
                                                  ? null
                                                  : controller
                                                      .expensepurpose.value,
                                              onChanged: (String? newValue) {
                                                if (newValue != null) {
                                                  controller.expensepurpose
                                                          .value =
                                                      newValue; // Update the RxString value
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                hintText: "",
                                                border: InputBorder.none,
                                              ),
                                              hint: Text(
                                                "Purpose",
                                                style: GoogleFonts.roboto(
                                                    color: Colors.grey),
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
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                          ),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: controller.Amount,
                                            decoration: InputDecoration(
                                              hintText: "Amount",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        CustomText(
                                            data: "Public Conveyance Details"),
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
                                            controller: controller.publiccon,
                                            decoration: InputDecoration(
                                              hintText:
                                                  "Public Conveyance Details",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
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
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                          ),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: controller.Amount2,
                                            decoration: InputDecoration(
                                              hintText: "Amount",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12.h),
                                        CustomText(
                                            data: "Travel KM By Vehicle"),
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
                                            controller: controller.travel,
                                            decoration: InputDecoration(
                                              hintText: "Travel KM By Vehicle",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
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
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                          ),
                                          child: TextFormField(
                                            // readOnly: true,
                                            keyboardType: TextInputType.number,
                                            controller: controller.travelamount,
                                            decoration: InputDecoration(
                                              hintText: "Amount",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
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
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                          ),
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller:
                                                controller.ExpenseDetails,
                                            decoration: InputDecoration(
                                              hintText: "Enter Expense Details",
                                              hintStyle: GoogleFonts.roboto(
                                                  color: Colors.grey),
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
                                                controller
                                                    .CustomerName.value.text
                                                    .toString()
                                                    .isEmpty) {
                                              ShortMessage.toast(
                                                  title:
                                                      "Please fill all fields");
                                            } else {
                                              addExpense(
                                                  controller.empid.value,
                                                  controller.Visit.value.text,
                                                  controller.purpose.value,
                                                  controller
                                                      .CustomerName.value.text,
                                                  controller
                                                      .CityName.value.text,
                                                  controller
                                                      .ContactPerson.value.text,
                                                  controller
                                                      .ContactNO.value.text,
                                                  controller.EmailId.value.text,
                                                  controller
                                                      .VisitDetails.value.text,
                                                  controller
                                                      .expensepurpose.value,
                                                  controller.Amount.value.text,
                                                  controller
                                                      .publiccon.value.text,
                                                  controller.Amount2.value.text,
                                                  controller.travel.value.text,
                                                  controller
                                                      .travelamount.value.text,
                                                  controller.total.value,
                                                  controller.ExpenseDetails
                                                      .value.text);
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
                                                      color:
                                                          CustomColor.blueColor)
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
                  ])),
                  DefaultTabController(
                      length: 2,
                      child: Scaffold(
                          body: Column(
                        children: [
                          SizedBox(
                            height: 50.h,
                            child: AppBar(
                              automaticallyImplyLeading: false,
                              backgroundColor: Colors.white,
                              bottom: TabBar(
                                indicatorColor: CustomColor.blueColor,
                                indicatorSize: TabBarIndicatorSize.tab,
                                tabs: [
                                  Tab(
                                      child: CustomText(
                                    data: "Paid Expense",
                                    color: Colors.green,
                                  )),
                                  Tab(
                                      child: CustomText(
                                    data: "Unpaid Expense",
                                    color: Colors.red,
                                  )),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              child: TabBarView(children: [
                            SingleChildScrollView(
                              child: Obx(
                                () {
                                  switch (controller.rxRequestStatus1.value) {
                                    case Status.Loading:
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    case Status.Complete:
                                      var completedItems = controller
                                              .viewExpenseDataList.value.data
                                              ?.where((item) =>
                                                  item.eXPStatus == "Paid")
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
                                                              VieExpenseData>(
                                                          items: completedItems,
                                                          searchLabel: 'Search',
                                                          suggestion: Center(
                                                            child: AutoSizeText(
                                                              'Filter by Date , Expense Status , Contact Person Name',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 15.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                          failure: Center(
                                                            child: AutoSizeText(
                                                              'Found Nothing :(',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 15.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                          filter: (person) => [
                                                                person.date,
                                                                person
                                                                    .eXPStatus,
                                                                person
                                                                    .contactPersonName
                                                              ],
                                                          builder: (person) {
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
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .all(5
                                                                            .h),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.calendar_today,
                                                                              size: 20.sp,
                                                                            ),
                                                                            CustomText(
                                                                              data: person.visitDate == null ? "" : DateFormat('dd MMMM yyyy').format(DateTime.parse(person.visitDate.toString())),
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            CustomText(
                                                                              data: person.eXPStatus ?? "",
                                                                              fontSize: 16.sp,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: person.eXPStatus == "Unpaid"
                                                                                  ? Colors.red
                                                                                  : person.eXPStatus == "Paid"
                                                                                      ? Colors.green
                                                                                      : Colors.black,
                                                                            ),
                                                                            CustomText(
                                                                              data: "₹ ${person.allTotalAmount.toString()}",
                                                                              fontSize: 16.sp,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Divider(),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .all(5
                                                                            .h),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        CustomText(
                                                                          data:
                                                                              "Purpose:",
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              16.sp,
                                                                        ),
                                                                        CustomText(
                                                                          data: person
                                                                              .purpose
                                                                              .toString(),
                                                                          fontSize:
                                                                              16.sp,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Divider(),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .all(5
                                                                            .h),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        CustomText(
                                                                          data:
                                                                              "Customer Name :",
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              16.sp,
                                                                        ),
                                                                        CustomText(
                                                                          data: person
                                                                              .customerName
                                                                              .toString(),
                                                                          fontSize:
                                                                              16.sp,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Divider(),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      var data =
                                                                          person;
                                                                      Get.toNamed(
                                                                          AppRoutesName
                                                                              .view_all_expense,
                                                                          arguments: [
                                                                            data.visitDate.toString(),
                                                                            data.purpose.toString(),
                                                                            data.customerName.toString(),
                                                                            data.cityName.toString(),
                                                                            data.contactPersonName.toString(),
                                                                            data.contactNo.toString(),
                                                                            data.emailId.toString(),
                                                                            data.visitDetails.toString(),
                                                                            data.eXPPurpose.toString(),
                                                                            data.eXPAmount.toString(),
                                                                            data.eXPPublicConveDetails.toString(),
                                                                            data.eXPAmount2.toString(),
                                                                            data.eXPTravelKmVehicle.toString(),
                                                                            data.eXPAmount3.toString(),
                                                                            data.eXPExpensedetails.toString(),
                                                                            data.allTotalAmount.toString()
                                                                          ]);
                                                                    },
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        "More",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15.sp,
                                                                            color: CustomColor.blueColor,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          }),
                                                    );
                                                  },
                                                  child: Container(
                                                    // width: Get.width,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade100,
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 135.w),
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
                                                      decoration: BoxDecoration(
                                                          color: Colors.white),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: 50.h,
                                                            width: Get.width,
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
                                                                    left: 20.w,
                                                                  ),
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      Get.back();
                                                                    },
                                                                    child: Icon(
                                                                      CupertinoIcons
                                                                          .multiply,
                                                                      color: Colors
                                                                          .white,
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
                                                                  width: 60.w,
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
                                                                  height: 20.h,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    RichText(
                                                                      text:
                                                                          TextSpan(
                                                                        text:
                                                                            "Date from",
                                                                        style: GoogleFonts.roboto(
                                                                            fontSize:
                                                                                18.sp,
                                                                            color: Colors.black),
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                "*",
                                                                            style:
                                                                                GoogleFonts.roboto(fontSize: 20.sp, color: Colors.red),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Obx(() {
                                                                  return Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: 20
                                                                            .w,
                                                                        right: 20
                                                                            .w,
                                                                        top: 10
                                                                            .h),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 50.h,
                                                                              width: 400.w,
                                                                              child: InkWell(
                                                                                onTap: () => controller.selectFromDate(context),
                                                                                child: controller.formattedFromDate.value == ""
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
                                                                                          data: '  ${controller.formattedFromDate.value}',
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
                                                                            style:
                                                                                GoogleFonts.roboto(fontSize: 18.sp, color: Colors.black),
                                                                            children: [
                                                                          TextSpan(
                                                                            text:
                                                                                "*",
                                                                            style:
                                                                                GoogleFonts.roboto(fontSize: 20.sp, color: Colors.red),
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
                                                                        EdgeInsets
                                                                            .only(
                                                                      left:
                                                                          20.w,
                                                                      right:
                                                                          20.w,
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              50.h,
                                                                          width:
                                                                              400.w,
                                                                          child:
                                                                              InkWell(
                                                                            onTap: () =>
                                                                                controller.selectToDate(context),
                                                                            child: controller.formattedToDate.value == ""
                                                                                ? Container(alignment: Alignment.centerLeft, height: 50.h, width: 400, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)), child: CustomText(data: '   Select To Date'))
                                                                                : Container(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    height: 50.h,
                                                                                    width: 400,
                                                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)),
                                                                                    child: CustomText(
                                                                                      data: '  ${controller.formattedToDate.value}',
                                                                                      // Display the formatted date

                                                                                      fontSize: 14.sp,
                                                                                    ),
                                                                                  ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              15.h,
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
                                                                    if (controller.formattedFromDate.value !=
                                                                            "" &&
                                                                        controller.formattedToDate.value !=
                                                                            "") {
                                                                      controller
                                                                          .datefilterExpense();
                                                                      Get.back();
                                                                    } else {
                                                                      ShortMessage.toast(
                                                                          title:
                                                                              "Please select date");
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        50.h,
                                                                    width: Get
                                                                        .width,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            color:
                                                                                CustomColor.blueColor),
                                                                    child:
                                                                        CustomText(
                                                                      data:
                                                                          "Apply Filter",
                                                                      fontSize:
                                                                          18.sp,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
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
                                                                .circular(40.r),
                                                        border: Border.all(
                                                            width: 0.5.w)),
                                                    child: Icon(
                                                      Icons.calendar_month,
                                                      size: 40.r,
                                                      color:
                                                          CustomColor.blueColor,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          CustomText(
                                              data:
                                                  "Total Paid amount : ₹ ${controller.viewTotalExpenseDataList.value.data![0].totalPaid.toString()}"),
                                          SingleChildScrollView(
                                            child: SizedBox(
                                              height: 530.h,
                                              child: CustomRefreshIndicator(
                                                leadingScrollIndicatorVisible:
                                                    false,
                                                trailingScrollIndicatorVisible:
                                                    false,
                                                builder:
                                                    MaterialIndicatorDelegate(
                                                  builder:
                                                      (context, controller) {
                                                    return Icon(
                                                      Icons.refresh,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: 20,
                                                    );
                                                  },
                                                  scrollableBuilder: (context,
                                                      child, controller) {
                                                    return Opacity(
                                                      opacity: 1.0 -
                                                          controller.value
                                                              .clamp(0.0, 1.0),
                                                      child: child,
                                                    );
                                                  },
                                                ).call,
                                                onRefresh: () => Future.delayed(
                                                    const Duration(
                                                        milliseconds: 2),
                                                    () async {
                                                  await controller
                                                      .userExpenseView();
                                                }),
                                                child: completedItems.isEmpty
                                                    ? ListView.builder(
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
                                                        itemCount:
                                                            completedItems
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Container(
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
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  offset:
                                                                      Offset(
                                                                          2, 6),
                                                                  blurRadius:
                                                                      8.r,
                                                                  color: Colors
                                                                      .blue
                                                                      .shade900,
                                                                ),
                                                              ],
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(5
                                                                              .h),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.calendar_today,
                                                                            size:
                                                                                20.sp,
                                                                          ),
                                                                          CustomText(
                                                                            data: completedItems[index].visitDate == null
                                                                                ? ""
                                                                                : DateFormat('dd MMMM yyyy').format(DateTime.parse(completedItems[index].visitDate.toString())),
                                                                            fontSize:
                                                                                16.sp,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        children: [
                                                                          CustomText(
                                                                            data:
                                                                                completedItems[index].eXPStatus ?? "",
                                                                            fontSize:
                                                                                16.sp,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: completedItems[index].eXPStatus == "Unpaid"
                                                                                ? Colors.red
                                                                                : completedItems[index].eXPStatus == "Paid"
                                                                                    ? Colors.green
                                                                                    : Colors.black,
                                                                          ),
                                                                          CustomText(
                                                                            data:
                                                                                "₹ ${completedItems[index].allTotalAmount.toString()}",
                                                                            fontSize:
                                                                                16.sp,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Divider(),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(5
                                                                              .h),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      CustomText(
                                                                        data:
                                                                            "Purpose:",
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                      CustomText(
                                                                        data: completedItems[index]
                                                                            .purpose
                                                                            .toString(),
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Divider(),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(5
                                                                              .h),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      CustomText(
                                                                        data:
                                                                            "Customer Name :",
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                      CustomText(
                                                                        data: completedItems[index]
                                                                            .customerName
                                                                            .toString(),
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Divider(),
                                                                InkWell(
                                                                  onTap: () {
                                                                    var data = controller
                                                                        .viewExpenseDataList
                                                                        .value
                                                                        .data![index];
                                                                    Get.toNamed(
                                                                        AppRoutesName
                                                                            .view_all_expense,
                                                                        arguments: [
                                                                          data.visitDate
                                                                              .toString(),
                                                                          data.purpose
                                                                              .toString(),
                                                                          data.customerName
                                                                              .toString(),
                                                                          data.cityName
                                                                              .toString(),
                                                                          data.contactPersonName
                                                                              .toString(),
                                                                          data.contactNo
                                                                              .toString(),
                                                                          data.emailId
                                                                              .toString(),
                                                                          data.visitDetails
                                                                              .toString(),
                                                                          data.eXPPurpose
                                                                              .toString(),
                                                                          data.eXPAmount
                                                                              .toString(),
                                                                          data.eXPPublicConveDetails
                                                                              .toString(),
                                                                          data.eXPAmount2
                                                                              .toString(),
                                                                          data.eXPTravelKmVehicle
                                                                              .toString(),
                                                                          data.eXPAmount3
                                                                              .toString(),
                                                                          data.eXPExpensedetails
                                                                              .toString(),
                                                                          data.allTotalAmount
                                                                              .toString()
                                                                        ]);
                                                                  },
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child: Text(
                                                                      "More",
                                                                      style: TextStyle(
                                                                          fontSize: 15
                                                                              .sp,
                                                                          color: CustomColor
                                                                              .blueColor,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        }),
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
                                                  controller.userExpenseView();
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
                            SingleChildScrollView(
                              child: Obx(
                                () {
                                  switch (controller.rxRequestStatus1.value) {
                                    case Status.Loading:
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    case Status.Complete:
                                      var pendingItems = controller
                                              .viewExpenseDataList.value.data
                                              ?.where((item) =>
                                                  item.eXPStatus == "Unpaid")
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
                                                              VieExpenseData>(
                                                          items: pendingItems,
                                                          searchLabel: 'Search',
                                                          suggestion: Center(
                                                            child: AutoSizeText(
                                                              'Filter by Date , Expense Status , Contact Person Name',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 15.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                          failure: Center(
                                                            child: AutoSizeText(
                                                              'Found Nothing :(',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 15.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                          filter: (person) => [
                                                                person.date,
                                                                person
                                                                    .eXPStatus,
                                                                person
                                                                    .customerName
                                                              ],
                                                          builder: (person) {
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
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .all(5
                                                                            .h),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.calendar_today,
                                                                              size: 20.sp,
                                                                            ),
                                                                            CustomText(
                                                                              data: person.visitDate == null ? "" : DateFormat('dd MMMM yyyy').format(DateTime.parse(person.visitDate.toString())),
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            CustomText(
                                                                              data: person.eXPStatus ?? "",
                                                                              fontSize: 16.sp,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: person.eXPStatus == "Unpaid"
                                                                                  ? Colors.red
                                                                                  : person.eXPStatus == "Paid"
                                                                                      ? Colors.green
                                                                                      : Colors.black,
                                                                            ),
                                                                            CustomText(
                                                                              data: "₹ ${person.allTotalAmount.toString()}",
                                                                              fontSize: 16.sp,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Divider(),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .all(5
                                                                            .h),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        CustomText(
                                                                          data:
                                                                              "Purpose:",
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              16.sp,
                                                                        ),
                                                                        CustomText(
                                                                          data: person
                                                                              .purpose
                                                                              .toString(),
                                                                          fontSize:
                                                                              16.sp,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Divider(),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .all(5
                                                                            .h),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        CustomText(
                                                                          data:
                                                                              "Customer Name :",
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              16.sp,
                                                                        ),
                                                                        CustomText(
                                                                          data: person
                                                                              .customerName
                                                                              .toString(),
                                                                          fontSize:
                                                                              16.sp,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Divider(),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      var data =
                                                                          person;
                                                                      Get.toNamed(
                                                                          AppRoutesName
                                                                              .view_all_expense,
                                                                          arguments: [
                                                                            data.visitDate.toString(),
                                                                            data.purpose.toString(),
                                                                            data.customerName.toString(),
                                                                            data.cityName.toString(),
                                                                            data.contactPersonName.toString(),
                                                                            data.contactNo.toString(),
                                                                            data.emailId.toString(),
                                                                            data.visitDetails.toString(),
                                                                            data.eXPPurpose.toString(),
                                                                            data.eXPAmount.toString(),
                                                                            data.eXPPublicConveDetails.toString(),
                                                                            data.eXPAmount2.toString(),
                                                                            data.eXPTravelKmVehicle.toString(),
                                                                            data.eXPAmount3.toString(),
                                                                            data.eXPExpensedetails.toString(),
                                                                            data.allTotalAmount.toString()
                                                                          ]);
                                                                    },
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        "More",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15.sp,
                                                                            color: CustomColor.blueColor,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          }),
                                                    );
                                                  },
                                                  child: Container(
                                                    // width: Get.width,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade100,
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 135.w),
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
                                                      decoration: BoxDecoration(
                                                          color: Colors.white),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: 50.h,
                                                            width: Get.width,
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
                                                                    left: 20.w,
                                                                  ),
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      Get.back();
                                                                    },
                                                                    child: Icon(
                                                                      CupertinoIcons
                                                                          .multiply,
                                                                      color: Colors
                                                                          .white,
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
                                                                  width: 60.w,
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
                                                                  height: 20.h,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    RichText(
                                                                      text:
                                                                          TextSpan(
                                                                        text:
                                                                            "Date from",
                                                                        style: GoogleFonts.roboto(
                                                                            fontSize:
                                                                                18.sp,
                                                                            color: Colors.black),
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                "*",
                                                                            style:
                                                                                GoogleFonts.roboto(fontSize: 20.sp, color: Colors.red),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Obx(() {
                                                                  return Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: 20
                                                                            .w,
                                                                        right: 20
                                                                            .w,
                                                                        top: 10
                                                                            .h),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 50.h,
                                                                              width: 400.w,
                                                                              child: InkWell(
                                                                                onTap: () => controller.selectFromDate(context),
                                                                                child: controller.formattedFromDate.value == ""
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
                                                                                          data: '  ${controller.formattedFromDate.value}',
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
                                                                            style:
                                                                                GoogleFonts.roboto(fontSize: 18.sp, color: Colors.black),
                                                                            children: [
                                                                          TextSpan(
                                                                            text:
                                                                                "*",
                                                                            style:
                                                                                GoogleFonts.roboto(fontSize: 20.sp, color: Colors.red),
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
                                                                        EdgeInsets
                                                                            .only(
                                                                      left:
                                                                          20.w,
                                                                      right:
                                                                          20.w,
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              50.h,
                                                                          width:
                                                                              400.w,
                                                                          child:
                                                                              InkWell(
                                                                            onTap: () =>
                                                                                controller.selectToDate(context),
                                                                            child: controller.formattedToDate.value == ""
                                                                                ? Container(alignment: Alignment.centerLeft, height: 50.h, width: 400, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)), child: CustomText(data: '   Select To Date'))
                                                                                : Container(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    height: 50.h,
                                                                                    width: 400,
                                                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), border: Border.all(width: 0.5.w)),
                                                                                    child: CustomText(
                                                                                      data: '  ${controller.formattedToDate.value}',
                                                                                      // Display the formatted date

                                                                                      fontSize: 14.sp,
                                                                                    ),
                                                                                  ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              15.h,
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
                                                                    if (controller.formattedFromDate.value !=
                                                                            "" &&
                                                                        controller.formattedToDate.value !=
                                                                            "") {
                                                                      controller
                                                                          .datefilterExpense();
                                                                      Get.back();
                                                                    } else {
                                                                      ShortMessage.toast(
                                                                          title:
                                                                              "Please select date");
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        50.h,
                                                                    width: Get
                                                                        .width,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            color:
                                                                                CustomColor.blueColor),
                                                                    child:
                                                                        CustomText(
                                                                      data:
                                                                          "Apply Filter",
                                                                      fontSize:
                                                                          18.sp,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
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
                                                                .circular(40.r),
                                                        border: Border.all(
                                                            width: 0.5.w)),
                                                    child: Icon(
                                                      Icons.calendar_month,
                                                      size: 40.r,
                                                      color:
                                                          CustomColor.blueColor,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          CustomText(
                                              data:
                                                  "Total Unpaid amount : ₹ ${controller.viewTotalExpenseDataList.value.data![0].totalUnPaid.toString()}"),
                                          SingleChildScrollView(
                                            child: SizedBox(
                                              height: 530.h,
                                              child: CustomRefreshIndicator(
                                                leadingScrollIndicatorVisible:
                                                    false,
                                                trailingScrollIndicatorVisible:
                                                    false,
                                                builder:
                                                    MaterialIndicatorDelegate(
                                                  builder:
                                                      (context, controller) {
                                                    return Icon(
                                                      Icons.refresh,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: 20,
                                                    );
                                                  },
                                                  scrollableBuilder: (context,
                                                      child, controller) {
                                                    return Opacity(
                                                      opacity: 1.0 -
                                                          controller.value
                                                              .clamp(0.0, 1.0),
                                                      child: child,
                                                    );
                                                  },
                                                ).call,
                                                onRefresh: () => Future.delayed(
                                                    const Duration(
                                                        milliseconds: 2),
                                                    () async {
                                                  await controller
                                                      .userExpenseView();
                                                }),
                                                child: pendingItems.isEmpty
                                                    ? ListView.builder(
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
                                                        itemCount:
                                                            pendingItems.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Container(
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
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  offset:
                                                                      Offset(
                                                                          2, 6),
                                                                  blurRadius:
                                                                      8.r,
                                                                  color: Colors
                                                                      .blue
                                                                      .shade900,
                                                                ),
                                                              ],
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(5
                                                                              .h),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.calendar_today,
                                                                            size:
                                                                                20.sp,
                                                                          ),
                                                                          CustomText(
                                                                            data: pendingItems[index].visitDate == null
                                                                                ? ""
                                                                                : DateFormat('dd MMMM yyyy').format(DateTime.parse(pendingItems[index].visitDate.toString())),
                                                                            fontSize:
                                                                                16.sp,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        children: [
                                                                          CustomText(
                                                                            data:
                                                                                pendingItems[index].eXPStatus ?? "",
                                                                            fontSize:
                                                                                16.sp,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: pendingItems[index].eXPStatus == "Unpaid"
                                                                                ? Colors.red
                                                                                : pendingItems[index].eXPStatus == "Paid"
                                                                                    ? Colors.green
                                                                                    : Colors.black,
                                                                          ),
                                                                          CustomText(
                                                                            data:
                                                                                "₹ ${pendingItems[index].allTotalAmount.toString()}",
                                                                            fontSize:
                                                                                16.sp,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Divider(),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(5
                                                                              .h),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      CustomText(
                                                                        data:
                                                                            "Purpose:",
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                      CustomText(
                                                                        data: pendingItems[index]
                                                                            .purpose
                                                                            .toString(),
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Divider(),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(5
                                                                              .h),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      CustomText(
                                                                        data:
                                                                            "Customer Name :",
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                      CustomText(
                                                                        data: pendingItems[index]
                                                                            .customerName
                                                                            .toString(),
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Divider(),
                                                                InkWell(
                                                                  onTap: () {
                                                                    var data = controller
                                                                        .viewExpenseDataList
                                                                        .value
                                                                        .data![index];
                                                                    Get.toNamed(
                                                                        AppRoutesName
                                                                            .view_all_expense,
                                                                        arguments: [
                                                                          data.visitDate
                                                                              .toString(),
                                                                          data.purpose
                                                                              .toString(),
                                                                          data.customerName
                                                                              .toString(),
                                                                          data.cityName
                                                                              .toString(),
                                                                          data.contactPersonName
                                                                              .toString(),
                                                                          data.contactNo
                                                                              .toString(),
                                                                          data.emailId
                                                                              .toString(),
                                                                          data.visitDetails
                                                                              .toString(),
                                                                          data.eXPPurpose
                                                                              .toString(),
                                                                          data.eXPAmount
                                                                              .toString(),
                                                                          data.eXPPublicConveDetails
                                                                              .toString(),
                                                                          data.eXPAmount2
                                                                              .toString(),
                                                                          data.eXPTravelKmVehicle
                                                                              .toString(),
                                                                          data.eXPAmount3
                                                                              .toString(),
                                                                          data.eXPExpensedetails
                                                                              .toString(),
                                                                          data.allTotalAmount
                                                                              .toString()
                                                                        ]);
                                                                  },
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child: Text(
                                                                      "More",
                                                                      style: TextStyle(
                                                                          fontSize: 15
                                                                              .sp,
                                                                          color: CustomColor
                                                                              .blueColor,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        }),
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
                                                  // controller.updateDataListApi();
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
                          ]))
                        ],
                      ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
