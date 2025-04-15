import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';

import '../../sevices/models/Scheduler/SchedulerModel.dart';
import '../../utilities/custom_color/custom_color.dart';
import '../../utilities/custom_text/custom_text.dart';

class NextDayFollowupScreen extends StatefulWidget {
  const NextDayFollowupScreen({super.key});

  @override
  State<NextDayFollowupScreen> createState() => _NextDayFollowupScreenState();
}

class _NextDayFollowupScreen extends StatefulWidget {
  const _NextDayFollowupScreen({super.key});

  @override
  State<NextDayFollowupScreen> createState() => _NextDayFollowupScreenState();
}

class _NextDayFollowupScreenState extends State<NextDayFollowupScreen> {
  String? _imagePath;
  TextEditingController jobDetailsController = TextEditingController();
  var empName = ''.obs;
  final ImagePicker _picker = ImagePicker();
  var employees = <Datum>[].obs;
  List<Datum> datalist = [];
  var empId = 0.obs;
  var employeesId = 0.obs;
  var SelectedemployeesId = 0.obs;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    await fetchEmployees();
    empId.value = await PrefManager().readValue(key: PrefConst.addEmployeeId);
  }

  //fetch Employees....
  Future<void> fetchEmployees() async {
    try {
      final response = await http.get(Uri.parse(
          'http://sarvaperp.eduagentapp.com/api/SarvapErp/BindEmployeelist'));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        // print(data);
        if (data != null) {
          for (var item in data['data']) {
            // Parse each item into a Datum object and add it to the list
            Datum datum = Datum.fromJson(item);
            datalist.add(datum);
          }
          Employename employename = Employename.fromJson(data);
          print(employename.data);
          employees.value = employename.data!;
        } else {
          throw Exception('Received null data from the server');
        }
      } else {
        throw Exception('Failed to load employees: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching employees: $e');
    }
  }

  //add details
  Future<void> addJob(jobdetails, id, empid) async {
    const String url =
        'http://sarvaperp.eduagentapp.com/api/SarvapErp/AddJobAssign';

    // Create the request body
    Map<dynamic, dynamic> body = {
      "JobDetails": jobdetails.toString(),
      "EmployeeId": id.toString(),
      "JobImage": 'Image',
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
        print(response.body);
        print(url);
        print('Job added successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Submit Successfully")),
        );
      } else {
        // Print error message if the request was not successful
        print('Failed to add Job. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to Submit")),
        );
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print('Error occurred while adding enquiry: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _saveJob() {
    print('Employee: ${empName.value}');
    print('Job Details: ${jobDetailsController.text}');
    print('Image Path: $_imagePath');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.amber,
        title: CustomText(
          data: "Add Assign Job",
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
                      data: "Select Employee",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Obx(
                    () {
                      if (employees.isEmpty) {
                        // You can add a message or additional logic to handle the empty state
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return MultiSelectDialogField(
                          title: const Text(
                            "Select Any One Employee",
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          ),
                          items: employees
                              .map((employee) => MultiSelectItem(
                                  '${employee.employeeId}',
                                  '${employee.employeeId} - ${employee.firstName} ${employee.lastName ?? ''}'))
                              .toList(),
                          initialValue: empName.value.isNotEmpty
                              ? empName.value.split(',')
                              : [],
                          onConfirm: (values) {
                            if (values.isNotEmpty) {
                              var selectedValue = values.first;
                              int selectedId = int.parse(selectedValue);
                              empName.value = selectedValue;
                              SelectedemployeesId.value = selectedId;
                            } else {
                              empName.value = '';
                              SelectedemployeesId.value = 0;
                            }
                          },
                          chipDisplay: MultiSelectChipDisplay(
                            items: employees
                                .where((employee) =>
                                    SelectedemployeesId.value ==
                                    employee.employeeId)
                                .map((employee) => MultiSelectItem(
                                    '${employee.employeeId}',
                                    '${employee.firstName} ${employee.lastName ?? ''}'))
                                .toList(),
                            onTap: (value) {
                              empName.value = '';
                              SelectedemployeesId.value = 0;
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.only(left: 13),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      data: "Job Details",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: jobDetailsController,
                    decoration: InputDecoration(
                      hintText: "Enter Job Details",
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
                      data: "Job Document",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.only(left: 13),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 30.h,
                      width: 130.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey,
                      ),
                      child: InkWell(
                        onTap: _pickImage,
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Text(
                            "Choose File",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Padding(
                  padding: EdgeInsets.only(left: 13),
                  child: Text(
                    _imagePath != null ? 'File chosen' : 'No file chosen',
                    style: GoogleFonts.roboto(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      addJob(
                        jobDetailsController.text,
                        SelectedemployeesId,
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
