import 'package:sspl/controllers/followup/followup_details_screen_controller.dart';
import 'package:sspl/utilities/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utilities/custom_color/custom_color.dart';

class FollowupDetailsScreen extends GetView<FollowupDetailsScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.amber,
        title: CustomText(
          data: "Followup Details",
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: CustomColor.blueColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Obx(() {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
              margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(00, 4),
                      color: Colors.indigo.shade100,
                      blurRadius: 5.r),
                  BoxShadow(
                      offset: Offset(00, -1),
                      color: Colors.indigo.shade100,
                      blurRadius: 3.r),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: CustomText(
                          data: controller.contactname.value,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        data: "Action Type:   ",
                        fontSize: 15.sp,
                        color: Colors.green,
                      ),
                      CustomText(
                        data: controller.action.value,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        data: "Organization:",
                        fontSize: 15.sp,
                      ),
                      CustomText(
                        data: controller.organizationname.value,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        data: "Visit Type:",
                        fontSize: 15.sp,
                      ),
                      CustomText(
                        data: controller.courseName.value,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        data: "Mobile Number:",
                        fontSize: 15.sp,
                      ),
                      Row(
                        children: [
                          CustomText(
                            data: controller.lMobile.value,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          InkWell(
                            onTap: () {
                              launch("tel://${controller.lMobile.value}");
                            },
                            child: Container(
                              height: 25.h,
                              width: 34.w,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 10.w),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 5.h),
                              decoration: BoxDecoration(
                                color: CustomColor.blueColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                Icons.phone,
                                color: Colors.white,
                                size: 20.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  controller.alternateMobile.value == ""
                      ? SizedBox()
                      : controller.alternateMobile.value == null
                          ? SizedBox()
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  data: "Alternate Number:",
                                  fontSize: 15.sp,
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      data: controller.alternateMobile.value,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        launch(
                                            "tel://${controller.alternateMobile.value}");
                                      },
                                      child: Container(
                                        height: 25.h,
                                        width: 34.w,
                                        margin: EdgeInsets.only(left: 10.w),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w, vertical: 5.h),
                                        decoration: BoxDecoration(
                                          color: CustomColor.blueColor,
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: Icon(
                                          Icons.phone,
                                          color: Colors.white,
                                          size: 20.r,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                  controller.lEmail == ""
                      ? SizedBox()
                      : controller.lEmail == null
                          ? SizedBox()
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  data: "Email:",
                                  fontSize: 15.sp,
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      data: controller.lEmail.value,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    // InkWell(
                                    //   onTap: () async {
                                    //     String email =
                                    //         Uri.encodeComponent(controller.lEmail.value);
                                    //     Uri mail = Uri.parse("mailto:$email?");
                                    //     if (await launchUrl(mail)) {
                                    //     } else {
                                    //       ShortMessage.toast(title: "Something went wrong");
                                    //     }
                                    //   },
                                    //   child: Container(
                                    //     height: 30.h,
                                    //     width: 40.w,
                                    //     margin: EdgeInsets.only(left: 10.w),
                                    //     padding: EdgeInsets.symmetric(
                                    //         horizontal: 5.w, vertical: 5.h),
                                    //     decoration: BoxDecoration(
                                    //       gradient: LinearGradient(
                                    //         colors: [CustomColor.blueColor, Color(0xFFd21e2b)],
                                    //         begin: Alignment.topLeft,
                                    //         end: Alignment.topRight,
                                    //       ),
                                    //       borderRadius: BorderRadius.circular(10.r),
                                    //     ),
                                    //     child: Icon(
                                    //       Icons.email_outlined,
                                    //       color: Colors.white,
                                    //       size: 24.r,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        data: "Address:",
                        fontSize: 15.sp,
                      ),
                      CustomText(
                        data: controller.orgaddress.value,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        data: "Last Activity:",
                        fontSize: 15.sp,
                      ),
                      CustomText(
                        data: controller.lastAcyivityDate.value,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      CustomText(
                        data: "FollowUp Details",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  for (final element in controller.followupDataList)
                    Column(
                      children: [
                        Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              data: "Remark:",
                              fontSize: 15.sp,
                            ),
                            CustomText(
                              data: element.cRemarks.toString(),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              data: "Followup Date:",
                              fontSize: 15.sp,
                            ),
                            CustomText(
                              data: DateFormat("dd MMM yyyy hh:mm a").format(
                                  DateTime.parse(
                                      element.cFollowupdate.toString())),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ],
                    )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
