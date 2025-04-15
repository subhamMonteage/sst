import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../infrastructure/local_storage/local_storage.dart';
import '../../infrastructure/local_storage/pref_consts.dart';
import '../../utilities/custom_color/custom_color.dart';
import '../../utilities/custom_text/custom_text.dart';

class Schedulerscreen extends StatefulWidget {
  const Schedulerscreen({super.key});

  @override
  State<Schedulerscreen> createState() => _SchedulerScreen();
}

class _SchedulerScreen extends State<Schedulerscreen> {
  TextEditingController jobDesc = TextEditingController();
  TextEditingController scheduelvisit = TextEditingController();
  RxString status = "Pending".obs;
  var empId = 0.obs;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    empId.value = await PrefManager().readValue(key: PrefConst.addEmployeeId);
  }

  @override
  Widget build(BuildContext context) {
    //post api...
    Future<void> addScheduler(jobdesc, date, status, empid) async {
      const String url =
          'http://sarvaperp.eduagentapp.com/api/SarvapErp/AddScheduler';

      // Create the request body
      Map<dynamic, dynamic> body = {
        "Description": jobdesc.toString(),
        "SchedulerDate": date.toString(),
        "Status": status.toString(),
        "CreateBy": empid.toString(),
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
          print('Schedule added successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Submit Successfully")),
          );
        } else {
          // Print error message if the request was not successful
          print('Failed to add Schedule. Status code: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to Submit")),
          );
        }
      } catch (e) {
        // Handle any exceptions that occur during the request
        print('Error occurred while adding enquiry: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.amber,
        title: CustomText(
          data: "Add Scheduler",
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 13),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      data: "Date",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 50.h,
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: TextFormField(
                    controller: scheduelvisit,
                    readOnly: true,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.calendar_month),
                      border: InputBorder.none,
                      hintText: "Date",
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
                      scheduelvisit.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);

                      // Automatically update Leave To Date (one day after Leave From Date)
                      //controller.LeaveTo.text = DateFormat('yyyy-MM-dd').format(pickedDate.add(Duration(days: 1)));

                      print("Time ${scheduelvisit.text}");
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required Field';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.only(left: 13),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      data: "Description",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: jobDesc,
                    decoration: InputDecoration(
                      hintText: "Enter Description",
                      hintStyle: GoogleFonts.roboto(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.only(left: 13),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      data: "Status",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
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
                      value: status.value.isEmpty ? null : status.value,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          status.value = newValue; // Update the RxString value
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: "",
                        border: InputBorder.none,
                      ),
                      /*hint: Text(
                        "Status",
                        style: GoogleFonts.roboto(color: Colors.grey),
                      ),*/
                      items: [
                        "Completed",
                        "Pending",
                      ]
                          .map((leaveType) => DropdownMenuItem<String>(
                                value: leaveType,
                                child: Text(leaveType),
                              ))
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      addScheduler(
                        jobDesc.text,
                        scheduelvisit.text,
                        status,
                        empId.value,
                      );
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
                        data: "Save",
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
