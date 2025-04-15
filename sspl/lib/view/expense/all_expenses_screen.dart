import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sspl/utilities/custom_color/custom_color.dart';

import '../../controllers/expense/all_expenses_screen_controller.dart';
import '../../infrastructure/image_constants/image_constants.dart';
import '../../infrastructure/routes/page_constants.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../sevices/repo/repo.dart';
import '../../utilities/custom_text/custom_text.dart';
import '../../utilities/custom_toast/custom_toast.dart';

class AllExpensesScreen extends GetView<AllExpensesScreenController> {
  @override
  Widget build(BuildContext context) {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      data: "VIEW EXPENSE",
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutesName.addvisit_screen);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 3.h, horizontal: 10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: CustomColor.blueColor,
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.add,
                              color: Colors.white,
                              size: 30.r,
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              "Add Visit",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
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
            width: Get.width - 35,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10.r),
              // border: Border.all(
              //   color: Colors.black,
              // ),
            ),
            child: Row(
              children: [
                Container(
                  height: 50.h,
                  width: 50.w,
                  margin: EdgeInsets.only(right: 135.w),
                  decoration: BoxDecoration(
                    color: CustomColor.blueColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
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
                        data: "Visit Date :",
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(data: "20 May 2024"),
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
                        data: "Purpose :",
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(data: "Service"),
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
                      ),
                      CustomText(data: "Deepak "),
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
                        data: "Contact Person :",
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(data: "Shubham"),
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
                        data: "Contact Number :",
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(data: "9999922221"),
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
