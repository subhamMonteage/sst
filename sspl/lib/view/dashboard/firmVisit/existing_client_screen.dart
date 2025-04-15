import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:search_page/search_page.dart';
import 'package:sspl/utilities/custom_color/custom_color.dart';

import '../../../controllers/dashboard/existing_sclient_screen_controller.dart';
import '../../../utilities/custom_color/custom_color.dart';
import '../../../utilities/custom_text/custom_text.dart';

class ExistingClientScreen extends GetView<ExistingClientController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 50.h,
          ),
          const Row(
            children: [
              BackButton(),
            ],
          ),
          Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(horizontal: 6.h),
            margin: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              color: CustomColor.blueColor,
            ),
            alignment: Alignment.center,
            child: CustomText(
              data: "Existing Client",
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 15.h,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
            ),
            height: 40.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 2.w, color: CustomColor.blueColor),
              borderRadius: BorderRadius.circular(10.r),
            ),
            //   child: InkWell(
            //     onTap: () {
            //       showSearch(
            //         context: context,
            //         delegate: SearchPage<ClientData>(
            //             items: controller.viewClientdatalist.value.data!,
            //             searchLabel: 'Search Firm/Client',
            //             suggestion: Center(
            //               child: AutoSizeText(
            //                 'Search Firm/Client',
            //                 style: GoogleFonts.poppins(
            //                   fontSize: 15.sp,
            //                   fontWeight: FontWeight.w400,
            //                 ),
            //               ),
            //             ),
            //             failure: Center(
            //               child: AutoSizeText(
            //                 'Firm/Client not found :(',
            //                 style: GoogleFonts.poppins(
            //                   fontSize: 15.sp,
            //                   fontWeight: FontWeight.w400,
            //                 ),
            //               ),
            //             ),
            //             filter: (person) =>
            //                 [person.clientName, person.address, person.orgName],
            //             builder: (person) {
            //               return (person.meetingStatus == 1)
            //                   ? Container(
            //                       padding: EdgeInsets.only(
            //                           left: 10.w,
            //                           top: 10.h,
            //                           bottom: 10.w,
            //                           right: 10.w),
            //                       margin: EdgeInsets.symmetric(
            //                         horizontal: 10.w,
            //                         vertical: 15.h,
            //                       ),
            //                       decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.circular(20.r),
            //                         color: Colors.white,
            //                         border: Border.all(
            //                           color: Colors.red,
            //                           width: 2.w,
            //                         ),
            //                         boxShadow: [
            //                           BoxShadow(
            //                             offset: Offset(2, 6),
            //                             blurRadius: 8.r,
            //                             color: Colors.lightGreen.shade200,
            //                           ),
            //                         ],
            //                       ),
            //                       child: Column(
            //                         children: [
            //                           Row(
            //                             children: [
            //                               Expanded(
            //                                 child: Row(
            //                                   crossAxisAlignment:
            //                                       CrossAxisAlignment.start,
            //                                   children: [
            //                                     CircleAvatar(
            //                                       backgroundColor:
            //                                           Color(0xFF67a509),
            //                                       maxRadius: 20.r,
            //                                       child: Icon(
            //                                         Icons.person_outline,
            //                                         color: Colors.white,
            //                                       ),
            //                                     ),
            //                                     SizedBox(
            //                                       width: 10.w,
            //                                     ),
            //                                     Expanded(
            //                                       child: CustomText(
            //                                         data: person.orgName == null
            //                                             ? ""
            //                                             : person.orgName
            //                                                 .toString(),
            //                                         fontWeight: FontWeight.w500,
            //                                         overflow: TextOverflow.clip,
            //                                       ),
            //                                     )
            //                                   ],
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                           SizedBox(
            //                             height: 8.h,
            //                           ),
            //                           Row(
            //                             crossAxisAlignment:
            //                                 CrossAxisAlignment.start,
            //                             children: [
            //                               CircleAvatar(
            //                                 backgroundColor: Color(0xFF67a509),
            //                                 maxRadius: 20.r,
            //                                 child: Icon(
            //                                   Icons.location_pin,
            //                                   color: Colors.white,
            //                                 ),
            //                               ),
            //                               SizedBox(
            //                                 width: 21.w,
            //                               ),
            //                               (person.address == null ||
            //                                       person.address == "")
            //                                   ? TextButton(
            //                                       onPressed: () async {
            //                                         Map data = {
            //                                            "ClientId":
            //                                               person.clientId ?? "",
            //                                           "Address": controller
            //                                               .draggedAddress.value
            //                                               .toString(),
            //                                           "Latitude": controller
            //                                               .lat.value
            //                                               .toString(),
            //                                           "Longitude": controller
            //                                               .lng.value
            //                                               .toString(),
            //                                           "UpdateBy": controller
            //                                               .homeController
            //                                               .userId
            //                                               .value
            //                                               .toString(),
            //                                         };
            //                                         controller.updateClientModel
            //                                             .updateClientApi(
            //                                                 data, Get.context!);
            //                                         print(
            //                                             "this is data value $data");
            //                                         print("api hit");
            //                                       },
            //                                       child: CustomText(
            //                                         data: "Update your Location",
            //                                       ).animate().fade().scale(),
            //                                     )
            //                                   : Expanded(
            //                                       child: CustomText(
            //                                         data: person.address ?? "",
            //                                         fontWeight: FontWeight.w400,
            //                                         fontSize: 15.sp,
            //                                       ),
            //                                     )
            //                             ],
            //                           ),
            //                           SizedBox(
            //                             height: 1.h,
            //                           ),
            //                           (person.remark == "" ||
            //                                   person.remark == null)
            //                               ? SizedBox()
            //                               : Row(
            //                                   children: [
            //                                     Icon(
            //                                       Icons.note_alt,
            //                                       color: Colors.black,
            //                                     ),
            //                                     SizedBox(
            //                                       width: 15.w,
            //                                     ),
            //                                     Expanded(
            //                                       child: CustomText(
            //                                         data: person.remark ?? "",
            //                                         fontWeight: FontWeight.w400,
            //                                         fontSize: 16.sp,
            //                                       ),
            //                                     )
            //                                   ],
            //                                 ),
            //                           Divider(
            //                             thickness: 1,
            //                             color: Colors.black,
            //                           ),
            //                           (person.phoneNo == "" ||
            //                                   person.phoneNo == "")
            //                               ? SizedBox()
            //                               : Row(
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment.spaceBetween,
            //                                   children: [
            //                                     Row(
            //                                       children: [
            //                                         CircleAvatar(
            //                                           backgroundColor:
            //                                               Color(0xFF67a509),
            //                                           maxRadius: 15.r,
            //                                           child: Icon(
            //                                             Icons.phone,
            //                                             color: Colors.white,
            //                                             size: 20.r,
            //                                           ),
            //                                         ),
            //                                         SizedBox(
            //                                           width: 10.w,
            //                                         ),
            //                                         CustomText(
            //                                           data: person.phoneNo ?? "",
            //                                           fontSize: 16.sp,
            //                                         )
            //                                       ],
            //                                     ),
            //                                   ],
            //                                 ),
            //                           SizedBox(
            //                             height: 7.h,
            //                           ),
            //                           Row(
            //                             mainAxisAlignment:
            //                                 MainAxisAlignment.spaceBetween,
            //                             children: [
            //                               Container(
            //                                 padding: EdgeInsets.symmetric(
            //                                     horizontal: 10.w, vertical: 8.h),
            //                                 decoration: BoxDecoration(
            //                                   color: Colors.white,
            //                                   border: Border.all(
            //                                     color: Color(0xFF67a509),
            //                                   ),
            //                                   borderRadius:
            //                                       BorderRadius.circular(10.r),
            //                                 ),
            //                                 child: CustomText(
            //                                   data: "Meeting started",
            //                                   color: Color(0xFF67a509),
            //                                   fontSize: 16.sp,
            //                                 ),
            //                               ),
            //                               InkWell(
            //                                 onTap: () async {
            //                                   controller.isNoMeetingRunning
            //                                       .value = true;
            //
            //                                   Map<dynamic, dynamic> data = {
            //                                     "MeetingId": person.meetingId!,
            //                                     "AddUserId": controller
            //                                         .homeController.userId.value,
            //                                     "ClientId": person.clientId!,
            //                                     "EndTime": DateFormat(
            //                                             "yyyy-MM-ddTHH:mm:ss")
            //                                         .format(
            //                                       DateTime.parse(
            //                                         DateTime.now().toString(),
            //                                       ),
            //                                     ),
            //                                     "UpdateBy": controller
            //                                         .homeController.userId.value
            //                                         .toString(),
            //                                   };
            //                                   print(
            //                                       "body in end meeting ===> ${data}");
            //                                   controller.endMeetingModel
            //                                       .endMeetingApi(
            //                                           data, Get.context!);
            //                                   Get.back();
            //
            //                                   print("update journey api  $data");
            //                                   print("api hit");
            //                                 },
            //                                 child: Container(
            //                                   padding: EdgeInsets.symmetric(
            //                                       horizontal: 10.w,
            //                                       vertical: 4.h),
            //                                   decoration: BoxDecoration(
            //                                     borderRadius:
            //                                         BorderRadius.circular(10.r),
            //                                     color: Colors.red,
            //                                   ),
            //                                   child: CustomText(
            //                                     data: "End Meeting",
            //                                     color: Colors.white,
            //                                   ),
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                         ],
            //                       ),
            //                     )
            //                   : controller.isNoMeetingRunning.value == true
            //                       ? Container(
            //                           padding: EdgeInsets.only(
            //                               left: 10.w,
            //                               top: 10.h,
            //                               bottom: 10.w,
            //                               right: 10.w),
            //                           margin: EdgeInsets.symmetric(
            //                             horizontal: 10.w,
            //                             vertical: 15.h,
            //                           ),
            //                           decoration: BoxDecoration(
            //                             borderRadius: BorderRadius.circular(20.r),
            //                             color: Colors.white,
            //                             border: person.meetingStatus == 1
            //                                 ? Border.all(
            //                                     color: Colors.red,
            //                                     width: 2.w,
            //                                   )
            //                                 : Border.all(
            //                                     width: 0.w, color: Colors.white),
            //                             boxShadow: [
            //                               BoxShadow(
            //                                 offset: Offset(2, 6),
            //                                 blurRadius: 8.r,
            //                                 color: Colors.lightGreen.shade200,
            //                               ),
            //                             ],
            //                           ),
            //                           child: Column(
            //                             children: [
            //                               Row(
            //                                 children: [
            //                                   Expanded(
            //                                     child: Row(
            //                                       crossAxisAlignment:
            //                                           CrossAxisAlignment.center,
            //                                       children: [
            //                                         CircleAvatar(
            //                                           backgroundColor:
            //                                               Color(0xFF67a509),
            //                                           maxRadius: 20.r,
            //                                           child: Icon(
            //                                             Icons.person_outline,
            //                                             color: Colors.white,
            //                                           ),
            //                                         ),
            //                                         SizedBox(
            //                                           width: 10.w,
            //                                         ),
            //                                         Expanded(
            //                                           child: CustomText(
            //                                             data:
            //                                                 person.orgName ?? "",
            //                                             fontWeight:
            //                                                 FontWeight.w500,
            //                                           ),
            //                                         )
            //                                       ],
            //                                     ),
            //                                   ),
            //                                   person.meetingStatus == 1
            //                                       ? Container(
            //                                           padding:
            //                                               EdgeInsets.symmetric(
            //                                                   horizontal: 10.w,
            //                                                   vertical: 8.h),
            //                                           decoration: BoxDecoration(
            //                                             color: Color(0xFF67a509),
            //                                             borderRadius:
            //                                                 BorderRadius.circular(
            //                                                     10.r),
            //                                           ),
            //                                           child: CustomText(
            //                                             data:
            //                                                 "Meeting already started",
            //                                             color: Colors.white,
            //                                             fontSize: 16.sp,
            //                                           ),
            //                                         )
            //                                       : SizedBox(),
            //                                 ],
            //                               ),
            //                               SizedBox(
            //                                 height: 8.h,
            //                               ),
            //                               Row(
            //                                 crossAxisAlignment:
            //                                     CrossAxisAlignment.start,
            //                                 children: [
            //                                   CircleAvatar(
            //                                     backgroundColor:
            //                                         Color(0xFF67a509),
            //                                     maxRadius: 20.r,
            //                                     child: Icon(
            //                                       Icons.location_pin,
            //                                       color: Colors.white,
            //                                     ),
            //                                   ),
            //                                   SizedBox(
            //                                     width: 21.w,
            //                                   ),
            //                                   (person.address == null ||
            //                                           person.address == "")
            //                                       ? TextButton(
            //                                           onPressed: () async {
            //                                             Map data = {
            //                                               "ClientId":
            //                                                   person.clientId ??
            //                                                       "",
            //                                               "Address": controller
            //                                                   .draggedAddress
            //                                                   .value
            //                                                   .toString(),
            //                                               "Latitude": controller
            //                                                   .lat.value
            //                                                   .toString(),
            //                                               "Longitude": controller
            //                                                   .lng.value
            //                                                   .toString(),
            //                                               "UpdateBy": controller
            //                                                   .homeController
            //                                                   .userId
            //                                                   .value
            //                                                   .toString(),
            //                                             };
            //                                             controller
            //                                                 .updateClientModel
            //                                                 .updateClientApi(data,
            //                                                     Get.context!);
            //                                             print(
            //                                                 "this is data value $data");
            //                                             print("api hit");
            //                                           },
            //                                           child: CustomText(
            //                                             data:
            //                                                 "Update your Location",
            //                                           ).animate().fade().scale(),
            //                                         )
            //                                       : Expanded(
            //                                           child: CustomText(
            //                                             data:
            //                                                 person.address ?? "",
            //                                             fontWeight:
            //                                                 FontWeight.w400,
            //                                             fontSize: 15.sp,
            //                                           ),
            //                                         )
            //                                 ],
            //                               ),
            //                               SizedBox(
            //                                 height: 1.h,
            //                               ),
            //                               (person.remark == "" ||
            //                                       person.remark == null)
            //                                   ? SizedBox()
            //                                   : Row(
            //                                       children: [
            //                                         Icon(
            //                                           Icons.note_alt,
            //                                           color: Colors.black,
            //                                         ),
            //                                         SizedBox(
            //                                           width: 15.w,
            //                                         ),
            //                                         Expanded(
            //                                           child: CustomText(
            //                                             data: person.remark ?? "",
            //                                             fontWeight:
            //                                                 FontWeight.w400,
            //                                             fontSize: 16.sp,
            //                                           ),
            //                                         )
            //                                       ],
            //                                     ),
            //                               Divider(
            //                                 thickness: 1,
            //                                 color: Colors.black,
            //                               ),
            //                               (person.phoneNo == "" ||
            //                                       person.phoneNo == null)
            //                                   ? SizedBox()
            //                                   : Row(
            //                                       mainAxisAlignment:
            //                                           MainAxisAlignment
            //                                               .spaceBetween,
            //                                       children: [
            //                                         Row(
            //                                           children: [
            //                                             CircleAvatar(
            //                                               backgroundColor:
            //                                                   Color(0xFF67a509),
            //                                               maxRadius: 15.r,
            //                                               child: Icon(
            //                                                 Icons.phone,
            //                                                 color: Colors.white,
            //                                                 size: 20.r,
            //                                               ),
            //                                             ),
            //                                             SizedBox(
            //                                               width: 10.w,
            //                                             ),
            //                                             CustomText(
            //                                               data: person.phoneNo ??
            //                                                   "",
            //                                               fontSize: 16.sp,
            //                                             )
            //                                           ],
            //                                         ),
            //                                       ],
            //                                     ),
            //                               SizedBox(
            //                                 height: 7.h,
            //                               ),
            //                               Row(
            //                                 mainAxisAlignment:
            //                                     MainAxisAlignment.end,
            //                                 children: [
            //                                   InkWell(
            //                                     onTap: () {
            //                                       Map<dynamic, dynamic> data1 = {
            //                                         "AddUserId": controller
            //                                             .homeController
            //                                             .userId
            //                                             .value
            //                                             .toString(),
            //                                         "ClientId":
            //                                             person.clientId ?? "",
            //                                         "Latitude": controller
            //                                             .lat.value
            //                                             .toString(),
            //                                         "Longitude": controller
            //                                             .lng.value
            //                                             .toString(),
            //                                         "Address": controller
            //                                             .draggedAddress.value
            //                                             .toString(),
            //                                         "StartTime": DateFormat(
            //                                                 "yyyy-MM-ddTHH:mm:ss")
            //                                             .format(
            //                                               DateTime.parse(
            //                                                 DateTime.now()
            //                                                     .toString(),
            //                                               ),
            //                                             )
            //                                             .removeAllWhitespace
            //                                             .toString(),
            //                                         "MeetingDate":
            //                                             DateFormat("yyyy-MM-dd")
            //                                                 .format(
            //                                           DateTime.parse(
            //                                             DateTime.now().toString(),
            //                                           ),
            //                                         ),
            //                                         "CreateBy": controller
            //                                             .homeController
            //                                             .userId
            //                                             .value
            //                                             .toString()
            //                                       };
            //                                       controller.addMeetingModel
            //                                           .addMeetingApi(
            //                                               data1, Get.context!);
            //                                       Get.back();
            //
            //                                       print(
            //                                           "update journey api  $data1");
            //                                       print("api hit");
            //                                     },
            //                                     child: Container(
            //                                       padding: EdgeInsets.symmetric(
            //                                           horizontal: 10.w,
            //                                           vertical: 4.h),
            //                                       decoration: BoxDecoration(
            //                                         borderRadius:
            //                                             BorderRadius.circular(
            //                                                 10.r),
            //                                         color: Color(0xFF67a509),
            //                                       ),
            //                                       child: CustomText(
            //                                         data: "Start Meeting",
            //                                         color: Colors.white,
            //                                       ),
            //                                     ),
            //                                   ),
            //                                   SizedBox(
            //                                     width: 10.w,
            //                                   ),
            //                                 ],
            //                               ),
            //                             ],
            //                           ),
            //                         )
            //                       : SizedBox();
            //             }),
            //       );
            //     },
            //     child: Container(
            //         padding: EdgeInsets.symmetric(horizontal: 10.w),
            //         width: Get.width,
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(10.r),
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             CustomText(
            //               data: "Firm Name",
            //               color: Colors.grey,
            //               fontWeight: FontWeight.w400,
            //               fontSize: 18.sp,
            //             ),
            //             Icon(Icons.search)
            //           ],
            //         )),
            //   ),
            // ),
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
            //             leadingScrollIndicatorVisible: false,
            //             trailingScrollIndicatorVisible: false,
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
            //                 Future.delayed(Duration(milliseconds: 1), () async {
            //               await controller.updateDataListApi();
            //               await controller.setUserData();
            //             }),
            //             child:
            //                 controller.viewClientdatalist.value.data?.length ==
            //                         null
            //                     ? ListView.builder(
            //                         itemCount: 1,
            //                         itemBuilder: (context, index) {
            //                           return CustomText(
            //                             data: "Data not found",
            //                           );
            //                         })
            //                     : ListView.builder(
            //                         padding: EdgeInsets.zero,
            //                         itemCount: controller
            //                             .viewClientdatalist.value.data?.length,
            //                         itemBuilder: (context, index) {
            //                           int reverseIndex = controller
            //                                   .viewClientdatalist
            //                                   .value
            //                                   .data!
            //                                   .length -
            //                               1 -
            //                               index;
            //
            //                           return (controller
            //                                       .viewClientdatalist
            //                                       .value
            //                                       .data?[reverseIndex]
            //                                       .meetingStatus ==
            //                                   1)
            //                               ? Container(
            //                                   padding: EdgeInsets.only(
            //                                       left: 10.w,
            //                                       top: 10.h,
            //                                       bottom: 10.w,
            //                                       right: 10.w),
            //                                   margin: EdgeInsets.symmetric(
            //                                     horizontal: 10.w,
            //                                     vertical: 15.h,
            //                                   ),
            //                                   decoration: BoxDecoration(
            //                                     borderRadius:
            //                                         BorderRadius.circular(20.r),
            //                                     color: Colors.white,
            //                                     border: Border.all(
            //                                       color: Colors.red,
            //                                       width: 2.w,
            //                                     ),
            //                                     boxShadow: [
            //                                       BoxShadow(
            //                                         offset: Offset(2, 6),
            //                                         blurRadius: 8.r,
            //                                         color: Colors
            //                                             .lightGreen.shade200,
            //                                       ),
            //                                     ],
            //                                   ),
            //                                   child: Column(
            //                                     children: [
            //                                       Row(
            //                                         children: [
            //                                           Expanded(
            //                                             child: Row(
            //                                               crossAxisAlignment:
            //                                                   CrossAxisAlignment
            //                                                       .start,
            //                                               children: [
            //                                                 CircleAvatar(
            //                                                   backgroundColor:
            //                                                       Color(
            //                                                           0xFF67a509),
            //                                                   maxRadius: 20.r,
            //                                                   child: Icon(
            //                                                     Icons
            //                                                         .person_outline,
            //                                                     color:
            //                                                         Colors.white,
            //                                                   ),
            //                                                 ),
            //                                                 SizedBox(
            //                                                   width: 10.w,
            //                                                 ),
            //                                                 Expanded(
            //                                                   child: CustomText(
            //                                                     data: controller
            //                                                                 .viewClientdatalist
            //                                                                 .value
            //                                                                 .data?[
            //                                                                     reverseIndex]
            //                                                                 .orgName ==
            //                                                             null
            //                                                         ? ""
            //                                                         : controller
            //                                                             .viewClientdatalist
            //                                                             .value
            //                                                             .data![
            //                                                                 reverseIndex]
            //                                                             .orgName
            //                                                             .toString(),
            //                                                     fontWeight:
            //                                                         FontWeight
            //                                                             .w500,
            //                                                     overflow:
            //                                                         TextOverflow
            //                                                             .clip,
            //                                                   ),
            //                                                 )
            //                                               ],
            //                                             ),
            //                                           ),
            //                                         ],
            //                                       ),
            //                                       SizedBox(
            //                                         height: 8.h,
            //                                       ),
            //                                       Row(
            //                                         crossAxisAlignment:
            //                                             CrossAxisAlignment.start,
            //                                         children: [
            //                                           CircleAvatar(
            //                                             backgroundColor:
            //                                                 Color(0xFF67a509),
            //                                             maxRadius: 20.r,
            //                                             child: Icon(
            //                                               Icons.location_pin,
            //                                               color: Colors.white,
            //                                             ),
            //                                           ),
            //                                           SizedBox(
            //                                             width: 21.w,
            //                                           ),
            //                                           controller
            //                                                       .viewClientdatalist
            //                                                       .value
            //                                                       .data?[
            //                                                           reverseIndex]
            //                                                       .address ==
            //                                                   null
            //                                               ? TextButton(
            //                                                   onPressed:
            //                                                       () async {
            //                                                     Map data = {
            //                                                       "ClientId": controller
            //                                                                   .viewClientdatalist
            //                                                                   .value
            //                                                                   .data?[
            //                                                                       reverseIndex]
            //                                                                   .clientId ==
            //                                                               null
            //                                                           ? ""
            //                                                           : controller
            //                                                               .viewClientdatalist
            //                                                               .value
            //                                                               .data![
            //                                                                   reverseIndex]
            //                                                               .clientId,
            //                                                       "Address": controller
            //                                                           .draggedAddress
            //                                                           .value
            //                                                           .toString(),
            //                                                       "Latitude":
            //                                                           controller
            //                                                               .lat
            //                                                               .value
            //                                                               .toString(),
            //                                                       "Longitude":
            //                                                           controller
            //                                                               .lng
            //                                                               .value
            //                                                               .toString(),
            //                                                       "UpdateBy": controller
            //                                                           .homeController
            //                                                           .userId
            //                                                           .value
            //                                                           .toString(),
            //                                                     };
            //                                                     controller
            //                                                         .updateClientModel
            //                                                         .updateClientApi(
            //                                                             data,
            //                                                             Get.context!);
            //                                                     print(
            //                                                         "this is data value $data");
            //                                                     print("api hit");
            //                                                   },
            //                                                   child: CustomText(
            //                                                     data:
            //                                                         "Update your Location",
            //                                                   )
            //                                                       .animate()
            //                                                       .fade()
            //                                                       .scale(),
            //                                                 )
            //                                               : Expanded(
            //                                                   child: CustomText(
            //                                                     data: controller
            //                                                                 .viewClientdatalist
            //                                                                 .value
            //                                                                 .data?[
            //                                                                     reverseIndex]
            //                                                                 .address ==
            //                                                             null
            //                                                         ? ""
            //                                                         : controller
            //                                                             .viewClientdatalist
            //                                                             .value
            //                                                             .data![
            //                                                                 reverseIndex]
            //                                                             .address
            //                                                             .toString(),
            //                                                     fontWeight:
            //                                                         FontWeight
            //                                                             .w400,
            //                                                     fontSize: 15.sp,
            //                                                   ),
            //                                                 )
            //                                         ],
            //                                       ),
            //                                       SizedBox(
            //                                         height: 1.h,
            //                                       ),
            //                                       Obx(() {
            //                                         return controller
            //                                                     .viewClientdatalist
            //                                                     .value
            //                                                     .data?[
            //                                                         reverseIndex]
            //                                                     .remark ==
            //                                                 ""
            //                                             ? SizedBox()
            //                                             : controller
            //                                                         .viewClientdatalist
            //                                                         .value
            //                                                         .data?[
            //                                                             reverseIndex]
            //                                                         .remark ==
            //                                                     null
            //                                                 ? SizedBox()
            //                                                 : Row(
            //                                                     children: [
            //                                                       Icon(
            //                                                         Icons
            //                                                             .note_alt,
            //                                                         color: Colors
            //                                                             .black,
            //                                                       ),
            //                                                       SizedBox(
            //                                                         width: 15.w,
            //                                                       ),
            //                                                       Expanded(
            //                                                         child:
            //                                                             CustomText(
            //                                                           data: controller.viewClientdatalist.value.data?[reverseIndex].remark ==
            //                                                                   null
            //                                                               ? ""
            //                                                               : controller
            //                                                                   .viewClientdatalist
            //                                                                   .value
            //                                                                   .data![reverseIndex]
            //                                                                   .remark
            //                                                                   .toString(),
            //                                                           fontWeight:
            //                                                               FontWeight
            //                                                                   .w400,
            //                                                           fontSize:
            //                                                               16.sp,
            //                                                         ),
            //                                                       )
            //                                                     ],
            //                                                   );
            //                                       }),
            //                                       Divider(
            //                                         thickness: 1,
            //                                         color: Colors.black,
            //                                       ),
            //                                       Obx(() {
            //                                         return controller
            //                                                     .viewClientdatalist
            //                                                     .value
            //                                                     .data?[
            //                                                         reverseIndex]
            //                                                     .phoneNo ==
            //                                                 ""
            //                                             ? SizedBox()
            //                                             : controller
            //                                                         .viewClientdatalist
            //                                                         .value
            //                                                         .data?[
            //                                                             reverseIndex]
            //                                                         .phoneNo ==
            //                                                     null
            //                                                 ? SizedBox()
            //                                                 : Row(
            //                                                     mainAxisAlignment:
            //                                                         MainAxisAlignment
            //                                                             .spaceBetween,
            //                                                     children: [
            //                                                       Row(
            //                                                         children: [
            //                                                           CircleAvatar(
            //                                                             backgroundColor:
            //                                                                 Color(
            //                                                                     0xFF67a509),
            //                                                             maxRadius:
            //                                                                 15.r,
            //                                                             child:
            //                                                                 Icon(
            //                                                               Icons
            //                                                                   .phone,
            //                                                               color: Colors
            //                                                                   .white,
            //                                                               size: 20
            //                                                                   .r,
            //                                                             ),
            //                                                           ),
            //                                                           SizedBox(
            //                                                             width:
            //                                                                 10.w,
            //                                                           ),
            //                                                           CustomText(
            //                                                             data: controller.viewClientdatalist.value.data?[reverseIndex].phoneNo ==
            //                                                                     null
            //                                                                 ? ""
            //                                                                 : controller
            //                                                                     .viewClientdatalist
            //                                                                     .value
            //                                                                     .data![reverseIndex]
            //                                                                     .phoneNo
            //                                                                     .toString(),
            //                                                             fontSize:
            //                                                                 16.sp,
            //                                                           )
            //                                                         ],
            //                                                       ),
            //                                                     ],
            //                                                   );
            //                                       }),
            //                                       SizedBox(
            //                                         height: 7.h,
            //                                       ),
            //                                       Row(
            //                                         mainAxisAlignment:
            //                                             MainAxisAlignment
            //                                                 .spaceBetween,
            //                                         children: [
            //                                           Container(
            //                                             padding:
            //                                                 EdgeInsets.symmetric(
            //                                                     horizontal: 10.w,
            //                                                     vertical: 8.h),
            //                                             decoration: BoxDecoration(
            //                                               color: Colors.white,
            //                                               border: Border.all(
            //                                                 color:
            //                                                     Color(0xFF67a509),
            //                                               ),
            //                                               borderRadius:
            //                                                   BorderRadius
            //                                                       .circular(10.r),
            //                                             ),
            //                                             child: CustomText(
            //                                               data: "Meeting started",
            //                                               color:
            //                                                   Color(0xFF67a509),
            //                                               fontSize: 16.sp,
            //                                             ),
            //                                           ),
            //                                           InkWell(
            //                                             onTap: () async {
            //                                               controller
            //                                                   .isNoMeetingRunning
            //                                                   .value = true;
            //
            //                                               var res = Geolocator
            //                                                   .distanceBetween(
            //                                                 double.parse(controller
            //                                                     .userLocationDataList
            //                                                     .value
            //                                                     .data![0]
            //                                                     .sLatitude
            //                                                     .toString()),
            //                                                 double.parse(controller
            //                                                     .userLocationDataList
            //                                                     .value
            //                                                     .data![0]
            //                                                     .sLongitude
            //                                                     .toString()),
            //                                                 double.parse(
            //                                                     controller
            //                                                         .lat.value
            //                                                         .toString()),
            //                                                 double.parse(
            //                                                     controller
            //                                                         .lng.value
            //                                                         .toString()),
            //                                               );
            //                                               print(
            //                                                   "res data in km ===> ${(res / 1000).toPrecision(5).toInt()}");
            //
            //                                               print(
            //                                                   "latitude from server ===> ${controller.userLocationDataList.value.data![0].sLatitude.toString()}");
            //                                               print(
            //                                                   "longitude from server ===> ${controller.userLocationDataList.value.data![0].sLongitude.toString()}");
            //
            //                                               if (controller
            //                                                       .viewClientdatalist
            //                                                       .value
            //                                                       .data![
            //                                                           reverseIndex]
            //                                                       .clientId ==
            //                                                   0) {
            //                                                 ShortMessage.toast(
            //                                                     title:
            //                                                         "Please try again");
            //                                               } else {
            //                                                 Map<dynamic, dynamic>
            //                                                     data = {
            //                                                   "MeetingId": controller
            //                                                           .viewClientdatalist
            //                                                           .value
            //                                                           .data![
            //                                                               reverseIndex]
            //                                                           .meetingId ??
            //                                                       0,
            //                                                   "AddUserId": controller
            //                                                       .homeController
            //                                                       .userId
            //                                                       .value,
            //                                                   "ClientId": controller
            //                                                           .viewClientdatalist
            //                                                           .value
            //                                                           .data![
            //                                                               reverseIndex]
            //                                                           .clientId ??
            //                                                       0,
            //                                                   "EndTime": DateFormat(
            //                                                           "yyyy-MM-ddTHH:mm:ss")
            //                                                       .format(
            //                                                     DateTime.parse(
            //                                                       DateTime.now()
            //                                                           .toString(),
            //                                                     ),
            //                                                   ),
            //                                                   "UpdateBy": controller
            //                                                       .homeController
            //                                                       .userId
            //                                                       .value
            //                                                       .toString(),
            //                                                 };
            //                                                 print(
            //                                                     "body in end meeting ===> ${data}");
            //                                                 controller
            //                                                     .endMeetingModel
            //                                                     .endMeetingApi(
            //                                                         data,
            //                                                         Get.context!);
            //
            //                                                 print(
            //                                                     "update journey api  $data");
            //                                                 print("api hit");
            //                                               }
            //                                             },
            //                                             child: Container(
            //                                               padding: EdgeInsets
            //                                                   .symmetric(
            //                                                       horizontal:
            //                                                           10.w,
            //                                                       vertical: 4.h),
            //                                               decoration:
            //                                                   BoxDecoration(
            //                                                 borderRadius:
            //                                                     BorderRadius
            //                                                         .circular(
            //                                                             10.r),
            //                                                 color: Colors.red,
            //                                               ),
            //                                               child: CustomText(
            //                                                 data: "End Meeting",
            //                                                 color: Colors.white,
            //                                               ),
            //                                             ),
            //                                           ),
            //                                         ],
            //                                       ),
            //                                     ],
            //                                   ),
            //                                 )
            //                               : Obx(() {
            //                                   return controller.isNoMeetingRunning
            //                                               .value ==
            //                                           true
            //                                       ? Container(
            //                                           padding: EdgeInsets.only(
            //                                               left: 10.w,
            //                                               top: 10.h,
            //                                               bottom: 10.w,
            //                                               right: 10.w),
            //                                           margin:
            //                                               EdgeInsets.symmetric(
            //                                             horizontal: 10.w,
            //                                             vertical: 15.h,
            //                                           ),
            //                                           decoration: BoxDecoration(
            //                                             borderRadius:
            //                                                 BorderRadius.circular(
            //                                                     20.r),
            //                                             color: Colors.white,
            //                                             border: controller
            //                                                         .viewClientdatalist
            //                                                         .value
            //                                                         .data?[
            //                                                             reverseIndex]
            //                                                         .meetingStatus ==
            //                                                     1
            //                                                 ? Border.all(
            //                                                     color: Colors.red,
            //                                                     width: 2.w,
            //                                                   )
            //                                                 : Border.all(
            //                                                     width: 0.w,
            //                                                     color:
            //                                                         Colors.white),
            //                                             boxShadow: [
            //                                               BoxShadow(
            //                                                 offset: Offset(2, 6),
            //                                                 blurRadius: 8.r,
            //                                                 color: Colors
            //                                                     .lightGreen
            //                                                     .shade200,
            //                                               ),
            //                                             ],
            //                                           ),
            //                                           child: Column(
            //                                             children: [
            //                                               Row(
            //                                                 children: [
            //                                                   Expanded(
            //                                                     child: Row(
            //                                                       crossAxisAlignment:
            //                                                           CrossAxisAlignment
            //                                                               .center,
            //                                                       children: [
            //                                                         CircleAvatar(
            //                                                           backgroundColor:
            //                                                               Color(
            //                                                                   0xFF67a509),
            //                                                           maxRadius:
            //                                                               20.r,
            //                                                           child: Icon(
            //                                                             Icons
            //                                                                 .person_outline,
            //                                                             color: Colors
            //                                                                 .white,
            //                                                           ),
            //                                                         ),
            //                                                         SizedBox(
            //                                                           width: 10.w,
            //                                                         ),
            //                                                         Expanded(
            //                                                           child:
            //                                                               CustomText(
            //                                                             data: controller.viewClientdatalist.value.data?[reverseIndex].orgName ==
            //                                                                     null
            //                                                                 ? ""
            //                                                                 : controller
            //                                                                     .viewClientdatalist
            //                                                                     .value
            //                                                                     .data![reverseIndex]
            //                                                                     .orgName
            //                                                                     .toString(),
            //                                                             fontWeight:
            //                                                                 FontWeight
            //                                                                     .w500,
            //                                                           ),
            //                                                         )
            //                                                       ],
            //                                                     ),
            //                                                   ),
            //                                                   controller
            //                                                               .viewClientdatalist
            //                                                               .value
            //                                                               .data?[
            //                                                                   reverseIndex]
            //                                                               .meetingStatus ==
            //                                                           1
            //                                                       ? Container(
            //                                                           padding: EdgeInsets.symmetric(
            //                                                               horizontal: 10
            //                                                                   .w,
            //                                                               vertical:
            //                                                                   8.h),
            //                                                           decoration:
            //                                                               BoxDecoration(
            //                                                             color: Color(
            //                                                                 0xFF67a509),
            //                                                             borderRadius:
            //                                                                 BorderRadius.circular(
            //                                                                     10.r),
            //                                                           ),
            //                                                           child:
            //                                                               CustomText(
            //                                                             data:
            //                                                                 "Meeting already started",
            //                                                             color: Colors
            //                                                                 .white,
            //                                                             fontSize:
            //                                                                 16.sp,
            //                                                           ),
            //                                                         )
            //                                                       : SizedBox(),
            //                                                 ],
            //                                               ),
            //                                               SizedBox(
            //                                                 height: 8.h,
            //                                               ),
            //                                               Row(
            //                                                 crossAxisAlignment:
            //                                                     CrossAxisAlignment
            //                                                         .start,
            //                                                 children: [
            //                                                   CircleAvatar(
            //                                                     backgroundColor:
            //                                                         Color(
            //                                                             0xFF67a509),
            //                                                     maxRadius: 20.r,
            //                                                     child: Icon(
            //                                                       Icons
            //                                                           .location_pin,
            //                                                       color: Colors
            //                                                           .white,
            //                                                     ),
            //                                                   ),
            //                                                   SizedBox(
            //                                                     width: 21.w,
            //                                                   ),
            //                                                   controller
            //                                                               .viewClientdatalist
            //                                                               .value
            //                                                               .data?[
            //                                                                   reverseIndex]
            //                                                               .address ==
            //                                                           null
            //                                                       ? TextButton(
            //                                                           onPressed:
            //                                                               () async {
            //                                                             Map data =
            //                                                                 {
            //                                                               "ClientId": controller.viewClientdatalist.value.data?[reverseIndex].clientId ==
            //                                                                       null
            //                                                                   ? ""
            //                                                                   : controller.viewClientdatalist.value.data![reverseIndex].clientId,
            //                                                               "Address": controller
            //                                                                   .draggedAddress
            //                                                                   .value
            //                                                                   .toString(),
            //                                                               "Latitude": controller
            //                                                                   .lat
            //                                                                   .value
            //                                                                   .toString(),
            //                                                               "Longitude": controller
            //                                                                   .lng
            //                                                                   .value
            //                                                                   .toString(),
            //                                                               "UpdateBy": controller
            //                                                                   .homeController
            //                                                                   .userId
            //                                                                   .value
            //                                                                   .toString(),
            //                                                             };
            //                                                             controller
            //                                                                 .updateClientModel
            //                                                                 .updateClientApi(
            //                                                                     data,
            //                                                                     Get.context!);
            //                                                             print(
            //                                                                 "this is data value $data");
            //                                                             print(
            //                                                                 "api hit");
            //                                                           },
            //                                                           child:
            //                                                               CustomText(
            //                                                             data:
            //                                                                 "Update your Location",
            //                                                           )
            //                                                                   .animate()
            //                                                                   .fade()
            //                                                                   .scale(),
            //                                                         )
            //                                                       : Expanded(
            //                                                           child:
            //                                                               CustomText(
            //                                                             data: controller.viewClientdatalist.value.data?[reverseIndex].address ==
            //                                                                     null
            //                                                                 ? ""
            //                                                                 : controller
            //                                                                     .viewClientdatalist
            //                                                                     .value
            //                                                                     .data![reverseIndex]
            //                                                                     .address
            //                                                                     .toString(),
            //                                                             fontWeight:
            //                                                                 FontWeight
            //                                                                     .w400,
            //                                                             fontSize:
            //                                                                 15.sp,
            //                                                           ),
            //                                                         )
            //                                                 ],
            //                                               ),
            //                                               SizedBox(
            //                                                 height: 1.h,
            //                                               ),
            //                                               Obx(() {
            //                                                 return controller
            //                                                             .viewClientdatalist
            //                                                             .value
            //                                                             .data?[
            //                                                                 reverseIndex]
            //                                                             .remark ==
            //                                                         ""
            //                                                     ? SizedBox()
            //                                                     : controller
            //                                                                 .viewClientdatalist
            //                                                                 .value
            //                                                                 .data?[
            //                                                                     reverseIndex]
            //                                                                 .remark ==
            //                                                             null
            //                                                         ? SizedBox()
            //                                                         : Row(
            //                                                             children: [
            //                                                               Icon(
            //                                                                 Icons
            //                                                                     .note_alt,
            //                                                                 color:
            //                                                                     Colors.black,
            //                                                               ),
            //                                                               SizedBox(
            //                                                                 width:
            //                                                                     15.w,
            //                                                               ),
            //                                                               Expanded(
            //                                                                 child:
            //                                                                     CustomText(
            //                                                                   data: controller.viewClientdatalist.value.data?[reverseIndex].remark == null
            //                                                                       ? ""
            //                                                                       : controller.viewClientdatalist.value.data![reverseIndex].remark.toString(),
            //                                                                   fontWeight:
            //                                                                       FontWeight.w400,
            //                                                                   fontSize:
            //                                                                       16.sp,
            //                                                                 ),
            //                                                               )
            //                                                             ],
            //                                                           );
            //                                               }),
            //                                               Divider(
            //                                                 thickness: 1,
            //                                                 color: Colors.black,
            //                                               ),
            //                                               Obx(() {
            //                                                 return controller
            //                                                             .viewClientdatalist
            //                                                             .value
            //                                                             .data?[
            //                                                                 reverseIndex]
            //                                                             .phoneNo ==
            //                                                         ""
            //                                                     ? SizedBox()
            //                                                     : controller
            //                                                                 .viewClientdatalist
            //                                                                 .value
            //                                                                 .data?[
            //                                                                     reverseIndex]
            //                                                                 .phoneNo ==
            //                                                             null
            //                                                         ? SizedBox()
            //                                                         : Row(
            //                                                             mainAxisAlignment:
            //                                                                 MainAxisAlignment
            //                                                                     .spaceBetween,
            //                                                             children: [
            //                                                               Row(
            //                                                                 children: [
            //                                                                   CircleAvatar(
            //                                                                     backgroundColor: Color(0xFF67a509),
            //                                                                     maxRadius: 15.r,
            //                                                                     child: Icon(
            //                                                                       Icons.phone,
            //                                                                       color: Colors.white,
            //                                                                       size: 20.r,
            //                                                                     ),
            //                                                                   ),
            //                                                                   SizedBox(
            //                                                                     width: 10.w,
            //                                                                   ),
            //                                                                   CustomText(
            //                                                                     data: controller.viewClientdatalist.value.data?[reverseIndex].phoneNo == null ? "" : controller.viewClientdatalist.value.data![reverseIndex].phoneNo.toString(),
            //                                                                     fontSize: 16.sp,
            //                                                                   )
            //                                                                 ],
            //                                                               ),
            //                                                             ],
            //                                                           );
            //                                               }),
            //                                               SizedBox(
            //                                                 height: 7.h,
            //                                               ),
            //                                               Row(
            //                                                 mainAxisAlignment:
            //                                                     MainAxisAlignment
            //                                                         .end,
            //                                                 children: [
            //                                                   InkWell(
            //                                                       onTap:
            //                                                           () async {
            //                                                         Map<dynamic,
            //                                                                 dynamic>
            //                                                             data1 = {
            //                                                           "AddUserId": controller
            //                                                               .homeController
            //                                                               .userId
            //                                                               .value
            //                                                               .toString(),
            //                                                           "ClientId": controller.viewClientdatalist.value.data?[reverseIndex].clientId.toString() ==
            //                                                                   null
            //                                                               ? ""
            //                                                               : controller
            //                                                                   .viewClientdatalist
            //                                                                   .value
            //                                                                   .data![reverseIndex]
            //                                                                   .clientId
            //                                                                   .toString(),
            //                                                           "Latitude":
            //                                                               controller
            //                                                                   .lat
            //                                                                   .value
            //                                                                   .toString(),
            //                                                           "Longitude":
            //                                                               controller
            //                                                                   .lng
            //                                                                   .value
            //                                                                   .toString(),
            //                                                           "Address": controller
            //                                                               .draggedAddress
            //                                                               .value
            //                                                               .toString(),
            //                                                           "StartTime": DateFormat(
            //                                                                   "yyyy-MM-ddTHH:mm:ss")
            //                                                               .format(
            //                                                                 DateTime
            //                                                                     .parse(
            //                                                                   DateTime.now().toString(),
            //                                                                 ),
            //                                                               )
            //                                                               .removeAllWhitespace
            //                                                               .toString(),
            //                                                           "MeetingDate":
            //                                                               DateFormat("yyyy-MM-dd")
            //                                                                   .format(
            //                                                             DateTime
            //                                                                 .parse(
            //                                                               DateTime.now()
            //                                                                   .toString(),
            //                                                             ),
            //                                                           ),
            //                                                           "CreateBy": controller
            //                                                               .homeController
            //                                                               .userId
            //                                                               .value
            //                                                               .toString()
            //                                                         };
            //                                                         controller
            //                                                             .addMeetingModel
            //                                                             .addMeetingApi(
            //                                                                 data1,
            //                                                                 Get.context!);
            //
            //                                                         controller
            //                                                             .isNoMeetingRunning
            //                                                             .value = true;
            //
            //                                                         var res =
            //                                                             Geolocator
            //                                                                 .distanceBetween(
            //                                                           double.parse(controller
            //                                                               .userLocationDataList
            //                                                               .value
            //                                                               .data![
            //                                                                   0]
            //                                                               .sLatitude
            //                                                               .toString()),
            //                                                           double.parse(controller
            //                                                               .userLocationDataList
            //                                                               .value
            //                                                               .data![
            //                                                                   0]
            //                                                               .sLongitude
            //                                                               .toString()),
            //                                                           double.parse(
            //                                                               controller
            //                                                                   .lat
            //                                                                   .value
            //                                                                   .toString()),
            //                                                           double.parse(
            //                                                               controller
            //                                                                   .lng
            //                                                                   .value
            //                                                                   .toString()),
            //                                                         );
            //                                                         print(
            //                                                             "res data in km ===> ${(res / 1000).toPrecision(5).toInt()}");
            //
            //                                                         print(
            //                                                             "latitude from server ===> ${controller.userLocationDataList.value.data![0].sLatitude.toString()}");
            //                                                         print(
            //                                                             "longitude from server ===> ${controller.userLocationDataList.value.data![0].sLongitude.toString()}");
            //
            //                                                         if (controller
            //                                                                 .viewClientdatalist
            //                                                                 .value
            //                                                                 .data![
            //                                                                     reverseIndex]
            //                                                                 .clientId ==
            //                                                             0) {
            //                                                           ShortMessage
            //                                                               .toast(
            //                                                                   title:
            //                                                                       "Please try again");
            //                                                         } else {
            //                                                           Map<dynamic,
            //                                                                   dynamic>
            //                                                               data1 =
            //                                                               {
            //                                                             "AddUserId": controller
            //                                                                 .homeController
            //                                                                 .userId
            //                                                                 .value,
            //                                                             "ClientId": controller
            //                                                                 .viewClientdatalist
            //                                                                 .value
            //                                                                 .data![
            //                                                                     reverseIndex]
            //                                                                 .clientId,
            //                                                             "SLatitude": controller
            //                                                                 .lat
            //                                                                 .value
            //                                                                 .toString(),
            //                                                             "SLongitude": controller
            //                                                                 .lng
            //                                                                 .value
            //                                                                 .toString(),
            //                                                             "SAddress": controller
            //                                                                 .draggedAddress
            //                                                                 .value
            //                                                                 .toString(),
            //                                                             "CurrentTime": DateFormat(
            //                                                                     'HH:mm:ss.S')
            //                                                                 .format(
            //                                                                     DateTime.now())
            //                                                                 .toString(),
            //                                                             "VisitDate": DateFormat(
            //                                                                     'yyyy-MM-ddTHH:mm:ss.S')
            //                                                                 .format(
            //                                                                     DateTime.now())
            //                                                                 .toString(),
            //                                                             "Distance": (res /
            //                                                                     1000)
            //                                                                 .toPrecision(
            //                                                                     5)
            //                                                                 .toInt(),
            //                                                             "JId": controller
            //                                                                 .homeController
            //                                                                 .uniqueValue
            //                                                                 .value,
            //                                                             "Usid": await PrefManager()
            //                                                                 .readValue(
            //                                                               key: PrefConst
            //                                                                   .startMeetingUID,
            //                                                             ),
            //                                                             "CreateBy": controller
            //                                                                 .homeController
            //                                                                 .userId
            //                                                                 .value
            //                                                                 .toString()
            //                                                           };
            //                                                           controller
            //                                                               .journeyUpdateModel
            //                                                               .updateJourneyApi(
            //                                                             data1,
            //                                                             Get.context!,
            //                                                             // 39679593410
            //                                                             controller
            //                                                                 .viewClientdatalist
            //                                                                 .value
            //                                                                 .data![
            //                                                                     reverseIndex]
            //                                                                 .clientId!,
            //                                                             controller
            //                                                                 .viewClientdatalist
            //                                                                 .value
            //                                                                 .data![
            //                                                                     reverseIndex]
            //                                                                 .meetingId!,
            //                                                           );
            //
            //                                                           print(
            //                                                               "update journey api  $data1");
            //                                                           print(
            //                                                               "api hit");
            //                                                         }
            //                                                       },
            //                                                       child:
            //                                                           Container(
            //                                                         padding: EdgeInsets.symmetric(
            //                                                             horizontal:
            //                                                                 10.w,
            //                                                             vertical:
            //                                                                 4.h),
            //                                                         decoration:
            //                                                             BoxDecoration(
            //                                                           borderRadius:
            //                                                               BorderRadius.circular(
            //                                                                   10.r),
            //                                                           color: Color(
            //                                                               0xFF67a509),
            //                                                         ),
            //                                                         child:
            //                                                             CustomText(
            //                                                           data:
            //                                                               "Start Meeting",
            //                                                           color: Colors
            //                                                               .white,
            //                                                         ),
            //                                                       )),
            //                                                   SizedBox(
            //                                                     width: 10.w,
            //                                                   ),
            //                                                 ],
            //                                               ),
            //                                             ],
            //                                           ),
            //                                         )
            //                                       : SizedBox();
            //                                 });
            //                         },
            //                       ),
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
          ),
        ],
      ),
    );
  }
}
