/*
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
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';
import 'package:sspl/infrastructure/routes/page_constants.dart';
import 'package:sspl/infrastructure/routes/page_routes.dart';
import 'package:sspl/utilities/custom_color/custom_color.dart';
import 'package:http/http.dart' as http;
import '../../controllers/expense/add_expense_view_model.dart';
import '../../controllers/leave/leave_screen_controller.dart';
import '../../infrastructure/image_constants/image_constants.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../sevices/models/Scheduler/SchedulerModel.dart';
import '../../sevices/models/expense/view_expenses.dart';
import '../../utilities/custom_text/custom_text.dart';
import '../../utilities/custom_toast/custom_toast.dart';



class LeaveScreen extends GetView<LeaveScreenController> {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {


    //function to add the information

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
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(),
              margin: EdgeInsets.symmetric(),
              decoration: const BoxDecoration(
                //borderRadius: BorderRadius.circular(6.r),
                color: CustomColor.blueColor,
              ),
              child:  Container(
                width: Get.width,
                padding: EdgeInsets.symmetric( vertical: 3.h),
                margin: EdgeInsets.symmetric(horizontal: 10.h, ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: CustomColor.blueColor,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child:
                    CustomText(
                      data: "ADD LEAVE",
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    */
/*InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutesName.all_expenses_screen);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: CustomColor.blueColor,
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [


                            Icon(
                              CupertinoIcons.eye,
                              color: Colors.white,
                              size: 50.r,
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              "View",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),*//*

                ),
              )
            ),
            SizedBox(
              height: 20.h,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(data: "Leave From Date"),
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
                            controller: controller.LeaveFrom,
                            readOnly: true,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.calendar_month),
                              border: InputBorder.none,
                              hintText: "Leave From Date",
                            ),
                            onTap: () async {
                              DateTime today = DateTime.now();
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                firstDate: today,
                                lastDate: today,
                                initialDate: today,
                              );

                              if (pickedDate == null) return;
                              controller.LeaveFrom.text = DateFormat('yyyy-MM-dd').format(pickedDate);

                              // Automatically update Leave To Date (one day after Leave From Date)
                              //controller.LeaveTo.text = DateFormat('yyyy-MM-dd').format(pickedDate.add(Duration(days: 1)));

                              print("Time ${controller.LeaveFrom.text}");
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Required Field';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 12.h,),
                        CustomText(data: "Leave To Date"),
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
                            controller: controller.LeaveTo,
                            readOnly: true,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.calendar_month),
                              border: InputBorder.none,
                              hintText: "Leave To Date",
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1980),
                                lastDate: DateTime(2025, 12, 31), // Set lastDate to a specific date in 2025
                                initialDate: DateTime.now(),
                              );

                              if (pickedDate == null) return;
                              controller.LeaveTo.text = DateFormat('yyyy-MM-dd').format(pickedDate);

                              print("Leave To Date: ${controller.LeaveTo.text}");
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Required Field';
                              }
                              return null;
                            },
                          ),

                        )],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Column(
                      children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(data: "Leave Apply For"),
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
                            controller: controller.LeaveApplyFor,
                            decoration: InputDecoration(
                              hintText: "Leave Apply For",
                              hintStyle: GoogleFonts.roboto(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h,),
                        CustomText(data: "Leave Type"),
                        Container(
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
                              value: controller.leaveType.value.isEmpty ? null : controller.leaveType.value,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller.leaveType.value = newValue; // Update the RxString value
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: "",
                                border: InputBorder.none,
                              ),
                              hint: Text(
                                "Leave Apply For",
                                style: GoogleFonts.roboto(color: Colors.grey),
                              ),
                              items: ["Sick Leave", "Casual Leave", "Earn Leave"]
                                  .map((leaveType) => DropdownMenuItem<String>(
                                value: leaveType,
                                child: Text(leaveType),
                              ))
                                  .toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h,),
                        CustomText(data: "Alternate Contact Number"),
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
                            controller: controller.altContactnumber,
                            decoration: InputDecoration(
                              hintText: "Alternate Contact Number",
                              hintStyle: GoogleFonts.roboto(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h,),
                        CustomText(data: "Resume duty On"),
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
                            controller: controller.resumedate,
                            readOnly: true,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.calendar_month),
                              border: InputBorder.none,
                              hintText: "Resume Date",
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1980),
                                lastDate: DateTime(2025, 12, 31), // Set lastDate to a specific date in 2025
                                initialDate: DateTime.now(),
                              );

                              if (pickedDate == null) return;
                              controller.resumedate.text = DateFormat('yyyy-MM-dd').format(pickedDate);

                              print("resume date: ${controller.LeaveTo.text}");
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Required Field';
                              }
                              return null;
                            },
                          ),

                        ),
                        SizedBox(height: 12.h,),
                        CustomText(data: "Backup Resource Name"),

                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [InkWell(
                        onTap: () {
                          final isValid = controller
                              .formKey.value.currentState!
                              .validate();
                          if (controller.LeaveFrom.value.text
                              .toString()
                              .isEmpty &&
                              controller.LeaveApplyFor.value.text
                                  .toString()
                                  .isEmpty) {
                            ShortMessage.toast(
                                title: "Please fill all fields");
                          } else {
                            //final addExpenseModel = Get.find<AddExpenseController>();
                            addLeave
                              (
                              controller.LeaveFrom.value.text,
                              controller.LeaveTo.value.text,
                              controller.LeaveApplyFor.value.text,
                              controller.leaveType.value,
                              controller.altContactnumber.value.text,
                              controller.resumedate.value.text,
                              controller.SelectedemployeesId.value,
                              controller.empid
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
            */
/* Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 3.h),
              margin: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                color: CustomColor.blueColor,
              ),
              alignment: Alignment.center,
              child: CustomText(
                data: "View Expense Details",
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Obx(
                  () {
                switch (controller.rxRequestStatus.value) {
                  case Status.Loading:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case Status.Complete:
                    return SizedBox(
                      height: 450.h,
                      child: CustomRefreshIndicator(
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
                            .viewExpensedatalist.value.data?.length ==
                            null
                            ? CustomText(data: "Data not found")
                            : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: controller
                              .viewExpensedatalist.value.data?.length,
                          itemBuilder: (context, index) {
                            int reverseIndex = controller
                                .viewExpensedatalist
                                .value
                                .data!
                                .length -
                                1 -
                                index;

                            String apiDate =
                                "${controller.viewExpensedatalist.value.data![reverseIndex].createDate}"; // Replace this with the date from your API
                            DateTime dateString = DateTime.parse(apiDate);

                            String formattedDate =
                            DateFormat("dd/MM/yyyy")
                                .format(dateString);
                            String formattedTime =
                            DateFormat("HH:mm a").format(dateString);
                            String todayDate = DateFormat("dd/MM/yyyy")
                                .format(DateTime.now());
                            return formattedDate != todayDate
                                ? SizedBox()
                                : Container(
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
                                    color:
                                    Colors.lightGreen.shade200,
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
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                            Color(0xFF67a509),
                                            maxRadius: 20.r,
                                            child: Icon(
                                              Icons.oil_barrel,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Column(
                                            children: [
                                              CustomText(
                                                data: controller
                                                    .viewExpensedatalist
                                                    .value
                                                    .data?[
                                                reverseIndex]
                                                    .category ==
                                                    null
                                                    ? ""
                                                    : controller
                                                    .viewExpensedatalist
                                                    .value
                                                    .data![
                                                reverseIndex]
                                                    .category
                                                    .toString(),
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                              CustomText(
                                                data:
                                                "₹${controller.viewExpensedatalist.value.data?[reverseIndex].amount == null ? "" : controller.viewExpensedatalist.value.data![reverseIndex].amount.toString()}",
                                                fontWeight:
                                                FontWeight.w500,
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
                                          CustomText(
                                            data:
                                            "Date: ${formattedDate}",
                                            fontSize: 14.sp,
                                            fontWeight:
                                            FontWeight.w500,
                                          ),
                                          CustomText(
                                            data:
                                            "Time: ${formattedTime}",
                                            fontSize: 14.sp,
                                            fontWeight:
                                            FontWeight.w500,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Obx(() {
                                    return controller
                                        .viewExpensedatalist
                                        .value
                                        .data?[reverseIndex]
                                        .description ==
                                        null
                                        ? SizedBox()
                                        : Row(
                                      children: [
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Icon(
                                          Icons
                                              .event_note_sharp,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: 21.w,
                                        ),
                                        Expanded(
                                          child: CustomText(
                                            data: controller
                                                .viewExpensedatalist
                                                .value
                                                .data?[
                                            reverseIndex]
                                                .description ??
                                                "",
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                                  // Divider(
                                  //   thickness: 1,
                                  //   color: Colors.black,
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.end,
                                  //   children: [
                                  //     InkWell(
                                  //       onTap: () async {
                                  //         await FileDownloader
                                  //             .downloadFile(
                                  //           url: AppUrl
                                  //                   .expense_invoice_download_url +
                                  //               controller
                                  //                   .viewExpensedatalist
                                  //                   .value
                                  //                   .data![
                                  //                       reverseIndex]
                                  //                   .invoice!,
                                  //           notificationType:
                                  //               NotificationType
                                  //                   .all,
                                  //           onProgress:
                                  //               (name, progress) {
                                  //             print(
                                  //                 "ncncncncncncncncn $name");
                                  //           },
                                  //           onDownloadCompleted:
                                  //               (value) {
                                  //             print(
                                  //                 'path  $value ');
                                  //             ShortMessage.toast(
                                  //                 title:
                                  //                     "File is download in Download folder");
                                  //           },
                                  //           onDownloadError:
                                  //               (value) {
                                  //             print(
                                  //                 'path  $value ');
                                  //             ShortMessage.toast(
                                  //                 title:
                                  //                     "Downloading error");
                                  //           },
                                  //         );
                                  //       },
                                  //       child: Container(
                                  //         child: Row(
                                  //           children: [
                                  //             CircleAvatar(
                                  //               backgroundColor:
                                  //                   Color(
                                  //                       0xFF67a509),
                                  //               maxRadius: 15.r,
                                  //               child: Icon(
                                  //                 Icons.download,
                                  //                 color:
                                  //                     Colors.black,
                                  //                 size: 20.r,
                                  //               ),
                                  //             ),
                                  //             SizedBox(
                                  //               width: 10.w,
                                  //             ),
                                  //             CustomText(
                                  //               data:
                                  //                   "Downaload reciept",
                                  //               fontWeight:
                                  //                   FontWeight.w500,
                                  //             )
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // )
                                ],
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
                                controller.updateDataListApi();
                              },
                              child: CustomText(data: "Retry"))
                        ],
                      ),
                    );
                }
              },
            ),*//*

          ],
        )))]))
    );
  }
}
*/
