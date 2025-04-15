import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sspl/controllers/expense/view_all_expense_controller.dart';

import '../../infrastructure/image_constants/image_constants.dart';
import '../../utilities/custom_color/custom_color.dart';
import '../../utilities/custom_text/custom_text.dart';

class ViewAllExpense extends GetView<ViewAllExpenseController> {
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
      body: SingleChildScrollView(
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
                        data: "Expense",
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                )),
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
                          fontSize: 16.sp,
                        ),
                        CustomText(
                          data: DateFormat("dd MMM yyy").format(
                              DateTime.parse(controller.visitDate.value)),
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
                          data: "Purpose :",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        CustomText(
                          data: controller.purpose.value,
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
                          data: "Customer Name :",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        CustomText(
                          data: controller.customerName.value,
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
                          data: "City Name :",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        CustomText(
                          data: controller.cityName.value,
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
                          data: "Contact Person Name :",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        CustomText(
                          data: controller.contactPersonName.value,
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
                          data: "Contact Number :",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        CustomText(
                          data: controller.contactNo.value,
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
                          data: "Email Id :",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        CustomText(
                          data: controller.emailId.value,
                          fontSize: 16.sp,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.all(5.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            data: "Visit Details :",
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        Divider(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            data: controller.visitDetails.value,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.all(5.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          data: "Expense Purpose :",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        CustomText(
                          data: controller.eXPPurpose.value,
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
                          data: "Expense Amount :",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        CustomText(
                          data: controller.eXPAmount.value,
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
                          data: "Expense Public Convenience :",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        CustomText(
                          data: controller.eXPPublicConveDetails.value,
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
                          data: "Expense Amount :",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        CustomText(
                          data: controller.eXPAmount2.value,
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
                          data: "Expense TravelKM Vehicle :",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        CustomText(
                          data: "${controller.eXPTravelKmVehicle.value} KM",
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
                          data: "Expense Amount :",
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        CustomText(
                          data: controller.eXPAmount3.value,
                          fontSize: 16.sp,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.all(5.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            data: "Expense Details :",
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        Divider(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            data: controller.eXPExpensedetails.value,
                            fontSize: 16.sp,
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.all(5.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                data: "Total Amount :",
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                              CustomText(
                                data: controller.total.value,
                                fontSize: 16.sp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
