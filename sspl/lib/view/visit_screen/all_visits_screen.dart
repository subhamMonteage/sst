import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:sspl/controllers/add_visit_screen_controller/all_visit_screen_controller.dart';
import 'package:sspl/infrastructure/routes/page_constants.dart';
import 'package:sspl/sevices/api_sevices/api_services.dart';
import 'package:sspl/sevices/models/visit_models/all_visit_model.dart';
import 'package:sspl/sevices/repo/add_followup_view_model.dart';
import 'package:sspl/utilities/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utilities/custom_color/custom_color.dart';

class AllVisitScreen extends GetView<AllVisitScreenController> {
  final addfollowupModel = Provider.of<AddFollowUpViewModel>(Get.context!);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: CustomText(
          data: "All Visit",
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchPage<Data>(
                    items: controller.viewallVisitDataList.value.data!,
                    searchLabel: 'Search Visit',
                    suggestion: Center(
                      child: AutoSizeText(
                        'Search by Organization & Name',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    failure: Center(
                      child: AutoSizeText(
                        'Data not found :(',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    filter: (person) =>
                        [person.organizationname, person.contactname],
                    builder: (person) {
                      String apiDate = "${person.lFollowupdate}";

                      DateTime dateString = DateTime.parse(apiDate);
                      String visitDate =
                          DateFormat("dd MMM yyyy hh:mm a").format(dateString);
                      return InkWell(
                        onTap: () {
                          Get.toNamed(
                              AppRoutesName.all_followups_of_client_screen,
                              arguments: [
                                person.contactname == null
                                    ? ""
                                    : person.contactname.toString(),
                                person.courseName == null
                                    ? ""
                                    : person.courseName.toString(),
                                person.organizationname == null
                                    ? ""
                                    : person.organizationname.toString(),
                                person.lMobile == null
                                    ? ""
                                    : person.lMobile.toString(),
                                person.lEmail == null
                                    ? ""
                                    : person.lEmail.toString(),
                                person.curruntAddrs == null
                                    ? ""
                                    : person.curruntAddrs.toString(),
                                person.orgAddress == null
                                    ? ""
                                    : person.orgAddress.toString(),
                                person.alternateMobile == null
                                    ? ""
                                    : person.alternateMobile.toString(),
                                person.alternateEmail == null
                                    ? ""
                                    : person.alternateEmail.toString(),
                                person.updatedate == null
                                    ? ""
                                    : person.updatedate.toString(),
                                person.lRemarks == null
                                    ? ""
                                    : person.lRemarks.toString(),
                                person.lSubstatus == null
                                    ? ""
                                    : person.lSubstatus.toString(),
                                person.leadsId == null
                                    ? ""
                                    : person.leadsId.toString(),
                                person.lAction == null
                                    ? ""
                                    : person.lAction.toString(),
                              ]);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 8.h),
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 8.h),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    data: "Action Type:   ",
                                    fontSize: 15.sp,
                                    color: Colors.green,
                                  ),
                                  CustomText(
                                    data: person.lAction == null
                                        ? ""
                                        : person.lAction.toString(),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      // color: Colors.indigo,
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: CustomColor.blueColor,
                                    ),
                                    child: CustomText(
                                      data: person.contactname == null
                                          ? ""
                                          : person.contactname.toString(),
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomText(
                                    data: "Visit Date",
                                    fontSize: 16.sp,
                                  ),
                                  CustomText(
                                    data: visitDate,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    data: "Organization:",
                                    fontSize: 15.sp,
                                  ),
                                  CustomText(
                                    data: person.organizationname == null
                                        ? ""
                                        : person.organizationname.toString(),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    data: "Mobile Number:",
                                    fontSize: 16.sp,
                                  ),
                                  SizedBox(
                                    width: 100.w,
                                  ),
                                  Row(
                                    children: [
                                      CustomText(
                                        data: person.lMobile == null
                                            ? ""
                                            : person.lMobile.toString(),
                                        textAlign: TextAlign.right,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          launch(
                                              "tel://${person.lMobile == null ? "" : person.lMobile.toString()}");
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
                              SizedBox(
                                height: 5.h,
                              ),
                              person.alternateMobile == null
                                  ? SizedBox()
                                  : person.alternateMobile == ""
                                      ? SizedBox()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              data: "Alternate Number:",
                                              fontSize: 16.sp,
                                            ),
                                            SizedBox(
                                              width: 100.w,
                                            ),
                                            Row(
                                              children: [
                                                CustomText(
                                                  data:
                                                      person.alternateMobile ==
                                                              null
                                                          ? ""
                                                          : person
                                                              .alternateMobile
                                                              .toString(),
                                                  textAlign: TextAlign.right,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    launch(
                                                        "tel://${person.alternateMobile == null ? "" : person.alternateMobile.toString()}");
                                                  },
                                                  child: Container(
                                                    height: 25.h,
                                                    width: 34.w,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.only(
                                                        left: 10.w),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.w,
                                                            vertical: 5.h),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          CustomColor.blueColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r),
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
                              person.lEmail == null
                                  ? SizedBox()
                                  : person.lEmail == ""
                                      ? SizedBox()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              data: "Email:",
                                              fontSize: 16.sp,
                                            ),
                                            SizedBox(
                                              width: 50.w,
                                            ),
                                            Expanded(
                                              child: CustomText(
                                                data: person.lEmail == null
                                                    ? ""
                                                    : person.lEmail.toString(),
                                                textAlign: TextAlign.right,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    data: "Visit Address:",
                                    fontSize: 16.sp,
                                  ),
                                  SizedBox(
                                    width: 50.w,
                                  ),
                                  Expanded(
                                    child: CustomText(
                                      data: person.orgAddress == null
                                          ? ""
                                          : person.orgAddress.toString(),
                                      textAlign: TextAlign.right,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.defaultDialog(
                                        title: "Add Followup",
                                        backgroundColor: Colors.white,
                                        content: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Center(
                                              child: Container(
                                                height: 300.h,
                                                width: Get.width,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 20.w,
                                                  vertical: 10.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    20.r,
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Obx(
                                                      () => Container(
                                                        height: 40.h,
                                                        width: Get.width,
                                                        alignment:
                                                            Alignment.center,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20.w,
                                                                vertical: 8.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset: Offset(
                                                                    00, 7),
                                                                color: Colors
                                                                    .indigo
                                                                    .shade100,
                                                                blurRadius:
                                                                    5.r),
                                                            BoxShadow(
                                                                offset: Offset(
                                                                    00, -1),
                                                                color: Colors
                                                                    .indigo
                                                                    .shade100,
                                                                blurRadius: 5.r)
                                                          ],
                                                        ),
                                                        child: DropdownButton<
                                                            String>(
                                                          underline: SizedBox(),
                                                          isExpanded: true,
                                                          value: controller
                                                              .lAction.value,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.r),
                                                          onChanged: (String?
                                                              newValue) {
                                                            controller.lAction
                                                                    .value =
                                                                newValue!;
                                                            controller
                                                                    .selectedAction
                                                                    .value =
                                                                newValue
                                                                    .toString();
                                                            print(
                                                                "action===> ${controller.selectedAction.value}");
                                                          },
                                                          items: controller
                                                              .lActionValue
                                                              .map<
                                                                  DropdownMenuItem<
                                                                      String>>((String
                                                                  value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child: CustomText(
                                                                data: value,
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Obx(
                                                      () {
                                                        return InkWell(
                                                          child: Container(
                                                              width: Get.width,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          20.w,
                                                                      vertical:
                                                                          8.h),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.r),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      offset:
                                                                          Offset(
                                                                              00,
                                                                              7),
                                                                      color: Colors
                                                                          .indigo
                                                                          .shade100,
                                                                      blurRadius:
                                                                          5.r),
                                                                  BoxShadow(
                                                                      offset:
                                                                          Offset(
                                                                              00,
                                                                              -1),
                                                                      color: Colors
                                                                          .indigo
                                                                          .shade100,
                                                                      blurRadius:
                                                                          5.r)
                                                                ],
                                                              ),
                                                              child: controller
                                                                          .selectedDate
                                                                          .value ==
                                                                      ""
                                                                  ? CustomText(
                                                                      data:
                                                                          "Date & Time",
                                                                      color: Colors
                                                                          .grey,
                                                                    )
                                                                  : CustomText(
                                                                      data:
                                                                          "${controller.selectedDate.value.toString()} ${controller.selectedTime.value.toString()}",
                                                                    )),
                                                          onTap: () async {
                                                            DateTime?
                                                                pickedDate =
                                                                await showDatePicker(
                                                              context: context,
                                                              lastDate:
                                                                  DateTime(
                                                                      2080),
                                                              firstDate:
                                                                  DateTime
                                                                      .now(),
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                            );
                                                            final TimeOfDay?
                                                                picked =
                                                                await showTimePicker(
                                                              context: context,
                                                              initialTime:
                                                                  TimeOfDay
                                                                      .now(),
                                                            );
                                                            if (picked !=
                                                                null) {
                                                              controller
                                                                      .selectedTime
                                                                      .value =
                                                                  '${picked.hour}:${picked.minute}';
                                                            }
                                                            if (pickedDate ==
                                                                null) return;
                                                            controller
                                                                .selectedDate
                                                                .value = DateFormat(
                                                                    'dd MMM yyyy')
                                                                .format(
                                                                    pickedDate);

                                                            if (pickedDate ==
                                                                null) return;
                                                            controller
                                                                .selectedDatePost
                                                                .value = DateFormat(
                                                                    'yyyy/MM/dd')
                                                                .format(
                                                                    pickedDate);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Container(
                                                      width: Get.width,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20.w,
                                                              vertical: 6.h),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              offset:
                                                                  Offset(00, 7),
                                                              color: Colors
                                                                  .indigo
                                                                  .shade100,
                                                              blurRadius: 5.r),
                                                          BoxShadow(
                                                              offset: Offset(
                                                                  00, -1),
                                                              color: Colors
                                                                  .indigo
                                                                  .shade100,
                                                              blurRadius: 5.r)
                                                        ],
                                                      ),
                                                      child: TextFormField(
                                                        controller: controller
                                                            .remarksController,
                                                        maxLines: 3,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText: "Remarks",
                                                          hintStyle: GoogleFonts
                                                              .roboto(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Map data = {
                                                              "LeadsId": person
                                                                          .leadsId ==
                                                                      null
                                                                  ? ""
                                                                  : person
                                                                      .leadsId
                                                                      .toString(),
                                                              "LSubstatus": person
                                                                          .lSubstatus ==
                                                                      null
                                                                  ? ""
                                                                  : person
                                                                      .lSubstatus
                                                                      .toString(),
                                                              "LAction": controller
                                                                  .selectedAction
                                                                  .value
                                                                  .toString(),
                                                              "LFollowupdate":
                                                                  "${controller.selectedDatePost.value} ${controller.selectedTime.value}",
                                                              "LRemarks": controller
                                                                  .remarksController
                                                                  .value
                                                                  .text
                                                                  .toString(),
                                                              "Updateby":
                                                                  controller.cId
                                                                      .value,
                                                            };
                                                            addfollowupModel
                                                                .addvisitApi(
                                                                    data,
                                                                    Get.context!);
                                                            print(
                                                                "this is data value $data");
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 20.w,
                                                              vertical: 6.h,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: CustomColor
                                                                  .blueColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r),
                                                            ),
                                                            child: CustomText(
                                                              data: "Save",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: CustomColor.blueColor,
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: CustomText(
                                        data: "Add followup",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: CustomColor.blueColor,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () {
              switch (controller.rxRequestStatus.value) {
                case Status.Loading:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case Status.Complete:
                  return Expanded(
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
                      child:
                          controller.viewallVisitDataList.value.data?.length ==
                                  null
                              ? ListView.builder(
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    return Center(
                                        child:
                                            CustomText(data: "Data not found"));
                                  })
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: controller
                                      .viewallVisitDataList.value.data?.length,
                                  itemBuilder: (context, index) {
                                    String apiDate =
                                        "${controller.viewallVisitDataList.value.data![index].lFollowupdate}";

                                    DateTime dateString =
                                        DateTime.parse(apiDate);
                                    String visitDate =
                                        DateFormat("dd MMM yyyy hh:mm a")
                                            .format(dateString);
                                    return InkWell(
                                      onTap: () {
                                        Get.toNamed(
                                            AppRoutesName
                                                .all_followups_of_client_screen,
                                            arguments: [
                                              controller
                                                          .viewallVisitDataList
                                                          .value
                                                          .data?[index]
                                                          .contactname ==
                                                      null
                                                  ? ""
                                                  : controller
                                                      .viewallVisitDataList
                                                      .value
                                                      .data![index]
                                                      .contactname
                                                      .toString(),
                                              controller
                                                          .viewallVisitDataList
                                                          .value
                                                          .data?[index]
                                                          .courseName ==
                                                      null
                                                  ? ""
                                                  : controller
                                                      .viewallVisitDataList
                                                      .value
                                                      .data![index]
                                                      .courseName
                                                      .toString(),
                                              controller
                                                          .viewallVisitDataList
                                                          .value
                                                          .data?[index]
                                                          .organizationname ==
                                                      null
                                                  ? ""
                                                  : controller
                                                      .viewallVisitDataList
                                                      .value
                                                      .data![index]
                                                      .organizationname
                                                      .toString(),
                                              controller
                                                          .viewallVisitDataList
                                                          .value
                                                          .data?[index]
                                                          .lMobile ==
                                                      null
                                                  ? ""
                                                  : controller
                                                      .viewallVisitDataList
                                                      .value
                                                      .data![index]
                                                      .lMobile
                                                      .toString(),
                                              controller
                                                          .viewallVisitDataList
                                                          .value
                                                          .data?[index]
                                                          .lEmail ==
                                                      null
                                                  ? ""
                                                  : controller
                                                      .viewallVisitDataList
                                                      .value
                                                      .data![index]
                                                      .lEmail
                                                      .toString(),
                                              controller
                                                          .viewallVisitDataList
                                                          .value
                                                          .data?[index]
                                                          .curruntAddrs ==
                                                      null
                                                  ? ""
                                                  : controller
                                                      .viewallVisitDataList
                                                      .value
                                                      .data![index]
                                                      .curruntAddrs
                                                      .toString(),
                                              controller
                                                          .viewallVisitDataList
                                                          .value
                                                          .data?[index]
                                                          .orgAddress ==
                                                      null
                                                  ? ""
                                                  : controller
                                                      .viewallVisitDataList
                                                      .value
                                                      .data![index]
                                                      .orgAddress
                                                      .toString(),
                                              controller
                                                          .viewallVisitDataList
                                                          .value
                                                          .data?[index]
                                                          .alternateMobile ==
                                                      null
                                                  ? ""
                                                  : controller
                                                      .viewallVisitDataList
                                                      .value
                                                      .data![index]
                                                      .alternateMobile
                                                      .toString(),
                                              controller
                                                          .viewallVisitDataList
                                                          .value
                                                          .data?[index]
                                                          .alternateEmail ==
                                                      null
                                                  ? ""
                                                  : controller
                                                      .viewallVisitDataList
                                                      .value
                                                      .data![index]
                                                      .alternateEmail
                                                      .toString(),
                                              controller
                                                          .viewallVisitDataList
                                                          .value
                                                          .data?[index]
                                                          .updatedate ==
                                                      null
                                                  ? ""
                                                  : controller
                                                      .viewallVisitDataList
                                                      .value
                                                      .data![index]
                                                      .updatedate
                                                      .toString(),
                                              controller
                                                          .viewallVisitDataList
                                                          .value
                                                          .data?[index]
                                                          .lRemarks ==
                                                      null
                                                  ? ""
                                                  : controller
                                                      .viewallVisitDataList
                                                      .value
                                                      .data![index]
                                                      .lRemarks
                                                      .toString(),
                                              controller
                                                          .viewallVisitDataList
                                                          .value
                                                          .data?[index]
                                                          .lSubstatus ==
                                                      null
                                                  ? ""
                                                  : controller
                                                      .viewallVisitDataList
                                                      .value
                                                      .data![index]
                                                      .lSubstatus
                                                      .toString(),
                                              controller
                                                  .leadid.value = controller
                                                          .viewallVisitDataList
                                                          .value
                                                          .data?[index]
                                                          .leadsId ==
                                                      null
                                                  ? ""
                                                  : controller
                                                      .viewallVisitDataList
                                                      .value
                                                      .data![index]
                                                      .leadsId
                                                      .toString(),
                                              controller
                                                          .viewallVisitDataList
                                                          .value
                                                          .data?[index]
                                                          .lAction ==
                                                      null
                                                  ? ""
                                                  : controller
                                                      .viewallVisitDataList
                                                      .value
                                                      .data![index]
                                                      .lAction
                                                      .toString(),
                                            ]);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 8.h),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 8.h),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20.r),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  data: "Action Type:   ",
                                                  fontSize: 15.sp,
                                                  color: Colors.green,
                                                ),
                                                CustomText(
                                                  data: controller
                                                              .viewallVisitDataList
                                                              .value
                                                              .data?[index]
                                                              .lAction ==
                                                          null
                                                      ? ""
                                                      : controller
                                                          .viewallVisitDataList
                                                          .value
                                                          .data![index]
                                                          .lAction
                                                          .toString(),
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.green,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w,
                                                    vertical: 3.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    // color: Colors.indigo,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    color:
                                                        CustomColor.blueColor,
                                                  ),
                                                  child: CustomText(
                                                    data: controller
                                                                .viewallVisitDataList
                                                                .value
                                                                .data?[index]
                                                                .contactname ==
                                                            null
                                                        ? ""
                                                        : controller
                                                            .viewallVisitDataList
                                                            .value
                                                            .data![index]
                                                            .contactname
                                                            .toString(),
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CustomText(
                                                  data: "Visit Date",
                                                  fontSize: 16.sp,
                                                ),
                                                CustomText(
                                                  data: visitDate,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  data: "Organization:",
                                                  fontSize: 15.sp,
                                                ),
                                                CustomText(
                                                  data: controller
                                                              .viewallVisitDataList
                                                              .value
                                                              .data?[index]
                                                              .organizationname ==
                                                          null
                                                      ? ""
                                                      : controller
                                                          .viewallVisitDataList
                                                          .value
                                                          .data![index]
                                                          .organizationname
                                                          .toString(),
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  data: "Mobile Number:",
                                                  fontSize: 16.sp,
                                                ),
                                                SizedBox(
                                                  width: 100.w,
                                                ),
                                                Row(
                                                  children: [
                                                    CustomText(
                                                      data: controller
                                                                  .viewallVisitDataList
                                                                  .value
                                                                  .data?[index]
                                                                  .lMobile ==
                                                              null
                                                          ? ""
                                                          : controller
                                                              .viewallVisitDataList
                                                              .value
                                                              .data![index]
                                                              .lMobile
                                                              .toString(),
                                                      textAlign:
                                                          TextAlign.right,
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        launch(
                                                            "tel://${controller.viewallVisitDataList.value.data?[index].lMobile == null ? "" : controller.viewallVisitDataList.value.data![index].lMobile.toString()}");
                                                      },
                                                      child: Container(
                                                        height: 25.h,
                                                        width: 34.w,
                                                        alignment:
                                                            Alignment.center,
                                                        margin: EdgeInsets.only(
                                                            left: 10.w),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5.w,
                                                                vertical: 5.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: CustomColor
                                                              .blueColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
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
                                              height: 4.h,
                                            ),
                                            controller
                                                        .viewallVisitDataList
                                                        .value
                                                        .data?[index]
                                                        .alternateMobile ==
                                                    null
                                                ? SizedBox()
                                                : controller
                                                            .viewallVisitDataList
                                                            .value
                                                            .data?[index]
                                                            .alternateMobile ==
                                                        ""
                                                    ? SizedBox()
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          CustomText(
                                                            data:
                                                                "Alternate Number:",
                                                            fontSize: 16.sp,
                                                          ),
                                                          SizedBox(
                                                            width: 100.w,
                                                          ),
                                                          Row(
                                                            children: [
                                                              CustomText(
                                                                data: controller
                                                                            .viewallVisitDataList
                                                                            .value
                                                                            .data?[
                                                                                index]
                                                                            .alternateMobile ==
                                                                        null
                                                                    ? ""
                                                                    : controller
                                                                        .viewallVisitDataList
                                                                        .value
                                                                        .data![
                                                                            index]
                                                                        .alternateMobile
                                                                        .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                fontSize: 18.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  launch(
                                                                      "tel://${controller.viewallVisitDataList.value.data?[index].alternateMobile == null ? "" : controller.viewallVisitDataList.value.data![index].alternateMobile.toString()}");
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 25.h,
                                                                  width: 34.w,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10.w),
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          5.w,
                                                                      vertical:
                                                                          5.h),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: CustomColor
                                                                        .blueColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.r),
                                                                  ),
                                                                  child: Icon(
                                                                    Icons.phone,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 20.r,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                            controller
                                                        .viewallVisitDataList
                                                        .value
                                                        .data?[index]
                                                        .lEmail ==
                                                    null
                                                ? SizedBox()
                                                : controller
                                                            .viewallVisitDataList
                                                            .value
                                                            .data?[index]
                                                            .lEmail ==
                                                        ""
                                                    ? SizedBox()
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          CustomText(
                                                            data: "Email:",
                                                            fontSize: 16.sp,
                                                          ),
                                                          SizedBox(
                                                            width: 50.w,
                                                          ),
                                                          Expanded(
                                                            child: CustomText(
                                                              data: controller
                                                                          .viewallVisitDataList
                                                                          .value
                                                                          .data?[
                                                                              index]
                                                                          .lEmail ==
                                                                      null
                                                                  ? ""
                                                                  : controller
                                                                      .viewallVisitDataList
                                                                      .value
                                                                      .data![
                                                                          index]
                                                                      .lEmail
                                                                      .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  data: "Visit Address:",
                                                  fontSize: 16.sp,
                                                ),
                                                SizedBox(
                                                  width: 50.w,
                                                ),
                                                Expanded(
                                                  child: CustomText(
                                                    data: controller
                                                                .viewallVisitDataList
                                                                .value
                                                                .data?[index]
                                                                .orgAddress ==
                                                            null
                                                        ? ""
                                                        : controller
                                                            .viewallVisitDataList
                                                            .value
                                                            .data![index]
                                                            .orgAddress
                                                            .toString(),
                                                    textAlign: TextAlign.right,
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Get.defaultDialog(
                                                      title: "Add Followup",
                                                      backgroundColor:
                                                          Colors.white,
                                                      content: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Center(
                                                            child: Container(
                                                              height: 300.h,
                                                              width: Get.width,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    20.w,
                                                                vertical: 10.h,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  20.r,
                                                                ),
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Obx(
                                                                    () =>
                                                                        Container(
                                                                      height:
                                                                          40.h,
                                                                      width: Get
                                                                          .width,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: 20
                                                                              .w,
                                                                          vertical:
                                                                              8.h),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.r),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                              offset: Offset(00, 7),
                                                                              color: Colors.indigo.shade100,
                                                                              blurRadius: 5.r),
                                                                          BoxShadow(
                                                                              offset: Offset(00, -1),
                                                                              color: Colors.indigo.shade100,
                                                                              blurRadius: 5.r)
                                                                        ],
                                                                      ),
                                                                      child: DropdownButton<
                                                                          String>(
                                                                        underline:
                                                                            SizedBox(),
                                                                        isExpanded:
                                                                            true,
                                                                        value: controller
                                                                            .lAction
                                                                            .value,
                                                                        borderRadius:
                                                                            BorderRadius.circular(20.r),
                                                                        onChanged:
                                                                            (String?
                                                                                newValue) {
                                                                          controller
                                                                              .lAction
                                                                              .value = newValue!;
                                                                          controller
                                                                              .selectedAction
                                                                              .value = newValue.toString();
                                                                          print(
                                                                              "action===> ${controller.selectedAction.value}");
                                                                        },
                                                                        items: controller
                                                                            .lActionValue
                                                                            .map<DropdownMenuItem<String>>((String
                                                                                value) {
                                                                          return DropdownMenuItem<
                                                                              String>(
                                                                            value:
                                                                                value,
                                                                            child:
                                                                                CustomText(
                                                                              data: value,
                                                                            ),
                                                                          );
                                                                        }).toList(),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        20.h,
                                                                  ),
                                                                  Obx(
                                                                    () {
                                                                      return InkWell(
                                                                        child: Container(
                                                                            width: Get.width,
                                                                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(10.r),
                                                                              boxShadow: [
                                                                                BoxShadow(offset: Offset(00, 7), color: Colors.indigo.shade100, blurRadius: 5.r),
                                                                                BoxShadow(offset: Offset(00, -1), color: Colors.indigo.shade100, blurRadius: 5.r)
                                                                              ],
                                                                            ),
                                                                            child: controller.selectedDate.value == ""
                                                                                ? CustomText(
                                                                                    data: "Date & Time",
                                                                                    color: Colors.grey,
                                                                                  )
                                                                                : CustomText(
                                                                                    data: "${controller.selectedDate.value.toString()} ${controller.selectedTime.value.toString()}",
                                                                                  )),
                                                                        onTap:
                                                                            () async {
                                                                          DateTime?
                                                                              pickedDate =
                                                                              await showDatePicker(
                                                                            context:
                                                                                context,
                                                                            lastDate:
                                                                                DateTime(2080),
                                                                            firstDate:
                                                                                DateTime.now(),
                                                                            initialDate:
                                                                                DateTime.now(),
                                                                          );
                                                                          final TimeOfDay?
                                                                              picked =
                                                                              await showTimePicker(
                                                                            context:
                                                                                context,
                                                                            initialTime:
                                                                                TimeOfDay.now(),
                                                                          );
                                                                          if (picked !=
                                                                              null) {
                                                                            controller.selectedTime.value =
                                                                                '${picked.hour}:${picked.minute}';
                                                                          }
                                                                          if (pickedDate ==
                                                                              null)
                                                                            return;
                                                                          controller
                                                                              .selectedDate
                                                                              .value = DateFormat('dd MMM yyyy').format(pickedDate);

                                                                          if (pickedDate ==
                                                                              null)
                                                                            return;
                                                                          controller
                                                                              .selectedDatePost
                                                                              .value = DateFormat('yyyy/MM/dd').format(pickedDate);
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        20.h,
                                                                  ),
                                                                  Container(
                                                                    width: Get
                                                                        .width,
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal: 20
                                                                            .w,
                                                                        vertical:
                                                                            6.h),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.r),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            offset: Offset(00,
                                                                                7),
                                                                            color:
                                                                                Colors.indigo.shade100,
                                                                            blurRadius: 5.r),
                                                                        BoxShadow(
                                                                            offset: Offset(00,
                                                                                -1),
                                                                            color:
                                                                                Colors.indigo.shade100,
                                                                            blurRadius: 5.r)
                                                                      ],
                                                                    ),
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          controller
                                                                              .remarksController,
                                                                      maxLines:
                                                                          3,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            InputBorder.none,
                                                                        hintText:
                                                                            "Remarks",
                                                                        hintStyle:
                                                                            GoogleFonts.roboto(
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        20.h,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Map data =
                                                                              {
                                                                            "LeadsId": controller.viewallVisitDataList.value.data?[index].leadsId == null
                                                                                ? ""
                                                                                : controller.viewallVisitDataList.value.data![index].leadsId.toString(),
                                                                            "LSubstatus": controller.viewallVisitDataList.value.data?[index].lSubstatus == null
                                                                                ? ""
                                                                                : controller.viewallVisitDataList.value.data![index].lSubstatus.toString(),
                                                                            "LAction":
                                                                                controller.selectedAction.value.toString(),
                                                                            "LFollowupdate":
                                                                                "${controller.selectedDatePost.value} ${controller.selectedTime.value}",
                                                                            "LRemarks":
                                                                                controller.remarksController.value.text.toString(),
                                                                            "Updateby":
                                                                                controller.cId.value,
                                                                          };
                                                                          addfollowupModel.addvisitApi(
                                                                              data,
                                                                              Get.context!);
                                                                          print(
                                                                              "this is data value $data");
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                20.w,
                                                                            vertical:
                                                                                6.h,
                                                                          ),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                CustomColor.blueColor,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.r),
                                                                          ),
                                                                          child:
                                                                              CustomText(
                                                                            data:
                                                                                "Save",
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 6.h,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          CustomColor.blueColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r),
                                                    ),
                                                    child: CustomText(
                                                      data: "Add followup",
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
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
          ),
        ],
      ),
    );
  }
}
