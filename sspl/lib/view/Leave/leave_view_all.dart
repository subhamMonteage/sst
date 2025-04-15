import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sspl/controllers/leave/leave_view_all_controller.dart';

import '../../infrastructure/image_constants/image_constants.dart';
import '../../utilities/custom_color/custom_color.dart';
import '../../utilities/custom_text/custom_text.dart';

class AllLeaveView extends GetView<LeaveViewAllController> {
  @override
  Widget build(BuildContext context) {
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
                      data: "LEAVE",
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              )),
          // Obx(
          //   () {
          //     switch (controller.rxRequestStatus.value) {
          //       case Status.Loading:
          //         return Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       case Status.Complete:
          //         return Expanded(
          //           child: CustomRefreshIndicator(
          //             leadingScrollIndicatorVisible: true,
          //             trailingScrollIndicatorVisible: true,
          //             builder: MaterialIndicatorDelegate(
          //               builder: (context, controller) {
          //                 return Icon(
          //                   Icons.refresh,
          //                   color: Theme.of(context).colorScheme.primary,
          //                   size: 30,
          //                 );
          //               },
          //               scrollableBuilder: (context, child, controller) {
          //                 return Opacity(
          //                   opacity: 1.0 - controller.value.clamp(0.0, 1.0),
          //                   child: child,
          //                 );
          //               },
          //             ),
          //             onRefresh: () =>
          //                 Future.delayed(Duration(milliseconds: 2), () async {
          //               await controller.updateDataListApi();
          //             }),
          //             child: controller
          //                         .viewExpensedatalist.value.data?.length ==
          //                     null
          //                 ? CustomText(data: "Data not found")
          //                 : ListView.builder(
          //                     padding: EdgeInsets.zero,
          //                     itemCount: controller
          //                         .viewExpensedatalist.value.data?.length,
          //                     itemBuilder: (context, index) {
          //                       int reverseIndex = controller
          //                               .viewExpensedatalist
          //                               .value
          //                               .data!
          //                               .length -
          //                           1 -
          //                           index;
          //                       String apiDate =
          //                           "${controller.viewExpensedatalist.value.data![reverseIndex].createDate}"; // Replace this with the date from your API
          //                       DateTime dateString = DateTime.parse(apiDate);
          //
          //                       String formattedDate =
          //                           DateFormat("dd/MM/yyyy").format(dateString);
          //                       String formattedTime =
          //                           DateFormat("HH:mm a").format(dateString);
          //                       return
          //                         Container(
          //                         padding: EdgeInsets.symmetric(
          //                             horizontal: 10.w, vertical: 10.h),
          //                         margin: EdgeInsets.symmetric(
          //                           horizontal: 10.w,
          //                           vertical: 15.h,
          //                         ),
          //                         decoration: BoxDecoration(
          //                           borderRadius: BorderRadius.circular(20.r),
          //                           color: Colors.white,
          //                           boxShadow: [
          //                             BoxShadow(
          //                               offset: Offset(2, 6),
          //                               blurRadius: 8.r,
          //                               color: Colors.blue.shade900,
          //                             ),
          //                           ],
          //                         ),
          //                         child: Column(
          //                           mainAxisAlignment: MainAxisAlignment.start,
          //                           children: [
          //                             Row(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.spaceBetween,
          //                               children: [
          //                                 Row(
          //                                   children: [
          //                                     CircleAvatar(
          //                                       backgroundColor:
          //                                       CustomColor.blueColor,
          //                                       maxRadius: 15.r,
          //                                       child: Icon(Icons.shopping_bag,
          //                                           color: Colors.white,
          //                                           size: 20.r),
          //                                     ),
          //                                     SizedBox(
          //                                       width: 10.w,
          //                                     ),
          //                                     Column(
          //                                       children: [
          //                                         CustomText(
          //                                           data: controller
          //                                                       .viewExpensedatalist
          //                                                       .value
          //                                                       .data?[
          //                                                           reverseIndex]
          //                                                       .category ==
          //                                                   null
          //                                               ? ""
          //                                               : controller
          //                                                   .viewExpensedatalist
          //                                                   .value
          //                                                   .data![reverseIndex]
          //                                                   .category
          //                                                   .toString(),
          //                                           fontWeight: FontWeight.w500,
          //                                           fontSize: 15.sp,
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ],
          //                                 ),
          //                                 Column(
          //                                   crossAxisAlignment:
          //                                       CrossAxisAlignment.start,
          //                                   children: [
          //                                     Row(
          //                                       children: [
          //                                         Icon(
          //                                           Icons.calendar_month,
          //                                           size: 20.r,
          //                                         ),
          //                                         CustomText(
          //                                           data: " ${formattedDate}",
          //                                           fontSize: 14.sp,
          //                                           fontWeight: FontWeight.w500,
          //                                         ),
          //                                       ],
          //                                     ),
          //                                     Row(
          //                                       children: [
          //                                         Icon(
          //                                           CupertinoIcons.clock,
          //                                           size: 20.r,
          //                                         ),
          //                                         CustomText(
          //                                           data: " ${formattedTime}",
          //                                           fontSize: 14.sp,
          //                                           fontWeight: FontWeight.w500,
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ],
          //                                 ),
          //                               ],
          //                             ),
          //                             Row(
          //                               children: [
          //                                 CircleAvatar(
          //                                   backgroundColor: CustomColor.blueColor,
          //                                   maxRadius: 15.r,
          //                                   child: Icon(Icons.currency_rupee,
          //                                       color: Colors.white,
          //                                       size: 20.r),
          //                                 ),
          //                                 CustomText(
          //                                   data:
          //                                       "  ${controller.viewExpensedatalist.value.data?[reverseIndex].amount == null ? "" : controller.viewExpensedatalist.value.data![reverseIndex].amount.toString()}",
          //                                   fontWeight: FontWeight.w500,
          //                                   fontSize: 15.sp,
          //                                 ),
          //                               ],
          //                             ),
          //
          //                             SizedBox(
          //                               height: 10.h,
          //                             ),
          //                             // Row(
          //                             //   children: [
          //                             //     Icon(
          //                             //       Icons.location_pin,
          //                             //       color: Colors.black,
          //                             //     ),
          //                             //     SizedBox(
          //                             //       width: 21.w,
          //                             //     ),
          //                             //     Expanded(
          //                             //       child: CustomText(
          //                             //         data:
          //                             //             "Hapur, Gaziabad, Uttar Predesh, 201012",
          //                             //       ),
          //                             //     )
          //                             //   ],
          //                             // ),
          //                             controller
          //                                 .viewExpensedatalist
          //                                 .value
          //                                 .data![reverseIndex]
          //                                 .invoice== null? SizedBox():
          //                             const Divider(
          //                               thickness: 1,
          //                               color: Colors.black,
          //                             ),
          //                             controller
          //                                 .viewExpensedatalist
          //                                 .value
          //                                 .data![reverseIndex]
          //                                 .invoice== null? SizedBox():
          //                             Row(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.end,
          //                               children: [
          //                                 InkWell(
          //                                   onTap: () {
          //                                     FileDownloader.downloadFile(
          //                                       url: AppUrl
          //                                               .expense_invoice_download_url +
          //                                           controller
          //                                               .viewExpensedatalist
          //                                               .value
          //                                               .data![reverseIndex]
          //                                               .invoice!,
          //                                       notificationType:
          //                                           NotificationType.all,
          //                                       onProgress: (name, progress) {
          //                                         print(
          //                                             "file ${AppUrl.expense_invoice_download_url + controller.viewExpensedatalist.value.data![reverseIndex].invoice.toString()}");
          //                                       },
          //                                       onDownloadCompleted: (value) {
          //                                         print('path  $value ');
          //                                         ShortMessage.toast(
          //                                             title:
          //                                                 "File is download in Download folder");
          //                                       },
          //                                       onDownloadError: (value) {
          //                                         print('path  $value ');
          //                                         ShortMessage.toast(
          //                                             title:
          //                                                 "Downloading error");
          //                                       },
          //                                     );
          //                                   },
          //                                   child: Container(
          //                                     child: Row(
          //                                       children: [
          //                                         CircleAvatar(
          //                                           backgroundColor:
          //                                           CustomColor.blueColor,
          //                                           maxRadius: 15.r,
          //                                           child: Icon(
          //                                             Icons.download,
          //                                             color: Colors.white,
          //                                             size: 20.r,
          //                                           ),
          //                                         ),
          //                                         SizedBox(
          //                                           width: 10.w,
          //                                         ),
          //                                         CustomText(
          //                                           data: "Downaload reciept",
          //                                           fontWeight: FontWeight.w500,
          //                                         )
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ],
          //                             )
          //                           ],
          //                         ),
          //                       );
          //                     },
          //                   ),
          //           ),
          //         );
          //
          //       case Status.Error:
          //         return Center(
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               ElevatedButton(
          //                   onPressed: () {
          //                     controller.updateDataListApi();
          //                   },
          //                   child: CustomText(data: "Retry"))
          //             ],
          //           ),
          //         );
          //     }
          //   },
          // ),
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
                      CustomText(
                        data: "Leave Type :",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      CustomText(
                        data: controller.leaveType.value,
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
                        data: "Leave from :",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      CustomText(
                        data: DateFormat("dd/MM/yyyy").format(DateTime.parse(
                            controller.leaveFromDate.toString())),
                        fontSize: 16.sp,
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      CustomText(
                        data: "to:",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      CustomText(
                        data: DateFormat("dd/MM/yyyy").format(
                            DateTime.parse(controller.leaveToDate.toString())),
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
                        data: "Resume duty on :",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      CustomText(
                        data: DateFormat("dd/MM/yyyy").format(DateTime.parse(
                            controller.resumedutyDate.toString())),
                        fontSize: 16.sp,
                      ),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(5.h),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            data: "Leave Apply For:",
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          )),
                      SizedBox(
                        height: 10.h,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            data: controller.leaveApplyfor.value,
                            fontSize: 16.sp,
                          )),
                    ],
                  ),
                ),
                /* Divider(),
              Padding(
                padding: EdgeInsets.all(5.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(data: "Remarks/Comments :",
                          fontWeight: FontWeight.bold,
                        fontSize: 16.sp,),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(data: "Leave",
                        fontSize: 16.sp,),
                    ),
                  ],
                ),
              ),*/
                Divider(),
                Padding(
                  padding: EdgeInsets.all(5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        data: "Backup Resource Name :",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      CustomText(
                        data: controller.namee.value,
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
                        data: "Alternate Contact No :",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      CustomText(
                        data: controller.alternateContactNo.value,
                        fontSize: 16.sp,
                      ),
                    ],
                  ),
                ),
                /*Divider(),
              Padding(
                padding: EdgeInsets.all(5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(data: "Leave Status :",
                        fontWeight: FontWeight.bold),
                    CustomText(data: "Completed"),
                  ],
                ),
              ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}
