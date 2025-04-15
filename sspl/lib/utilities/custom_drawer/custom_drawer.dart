import 'package:sspl/controllers/dashboard/dashboard.dart';
import 'package:sspl/infrastructure/image_constants/image_constants.dart';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/routes/page_constants.dart';
import 'package:sspl/utilities/custom_text/custom_text.dart';
import 'package:sspl/utilities/custom_toast/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../custom_color/custom_color.dart';

class CustomAppDrawer extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: CustomColor.blueColor,
            ),
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    maxRadius: 40.r,
                    backgroundColor: Colors.yellow,
                    child: Icon(
                      Icons.person,
                      size: 50.r,
                    ),
                  ),
                  CustomText(
                    data:
                        "${controller.userDetails.value.data?.firstName == null ? "" : controller.userDetails.value.data!.firstName} ${controller.userDetails.value.data?.lastName == null ? "" : controller.userDetails.value.data!.lastName}",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  CustomText(
                    data: controller.userDetails.value.data?.mobileNo == null
                        ? ""
                        : controller.userDetails.value.data!.mobileNo
                            .toString(),
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  )
                ],
              );
            }),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: CustomText(data: 'Attendance'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutesName.attendance_screen);
            },
          ),
          ListTile(
            leading: Icon(Icons.business_center_outlined),
            title: CustomText(
              data: "Job Assign",
            ),
            onTap: () {
              Get.toNamed(AppRoutesName.assigned_job_screen);
            },
          ),
          ListTile(
            leading: Icon(Icons.schedule),
            title: CustomText(data: 'Scheduler'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutesName.schedular_view_);
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: CustomText(data: 'Leave'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutesName.Leave_view_screen);
            },
          ),
          ListTile(
            leading: Icon(Icons.location_history),
            title: CustomText(data: 'Expense'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutesName.clientvisit_screen);
            },
          ),

          /*ListTile(
            leading: Image.asset(ImageConstants.all_visits,height: 25.h,),
            title: CustomText(data: 'All Visits'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutesName.all_visit_screen);
            },
          ),*/
          /*ListTile(
            leading: Image.asset(ImageConstants.today_followup,height: 25.h,),
            title: CustomText(data: 'Today Followup'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutesName.today_followup_screen);
            },
          ),*/

          /*ListTile(
            leading: Image.asset(ImageConstants.all_visits,height: 25.h,),
            title: CustomText(data: 'Next Day Followup'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutesName.next_day_followuo_screen);
            },
          ),*/
          ListTile(
            leading: Icon(Icons.calendar_today_rounded),
            title: CustomText(data: 'Enquiry'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutesName.Enquiry_visit);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: CustomText(data: 'Logout'),
            onTap: () {
              PrefManager().clearPref();
              ShortMessage.toast(title: "Logged out");
              Get.offAllNamed(
                AppRoutesName.login_screen,
              );
            },
          ),
        ],
      ),
    );
  }
}
