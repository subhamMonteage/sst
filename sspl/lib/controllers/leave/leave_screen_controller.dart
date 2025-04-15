import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:sspl/utilities/custom_toast/custom_toast.dart';

import '../../infrastructure/local_storage/connection_controller.dart';
import '../../infrastructure/local_storage/local_storage.dart';
import '../../infrastructure/local_storage/pref_consts.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../sevices/models/Leave/leave_view_model.dart';
import '../../sevices/models/Scheduler/SchedulerModel.dart';
import '../../sevices/models/expense/expense_model.dart';
import '../../sevices/models/expense/view_expenses.dart';
import '../../sevices/repo/repo.dart';

class LeaveScreenController extends GetxController {
  TextEditingController LeaveApplyFor = TextEditingController();
  TextEditingController LeaveType = TextEditingController();
  TextEditingController altContactnumber = TextEditingController();
  TextEditingController resumedate = TextEditingController();
  RxString leaveType = ''.obs;
  List<Datum> leavelist = [];
  var leaveemployees = <Datum>[].obs;
  var leaveempName = ''.obs;

  //var empId = 0.obs;
  var leaveemployeesId = 0.obs;

  //var LeaveemployeesId = 0.obs;
  RxString Backupname = ''.obs;
  TextEditingController tolocation = TextEditingController();
  TextEditingController LeaveFrom = TextEditingController();
  TextEditingController LeaveTo = TextEditingController();
  var status = "Pending".obs;

  var formKey = GlobalKey<FormState>().obs;
  var selectedImagePath = "".obs;
  String selectedImage = "";
  var empid = 0.obs;
  final isLoading = false.obs;
  Rx<DateTime> selectedFromDate = DateTime.now().obs;
  Rx<DateTime> selectedFromTime = DateTime.now().obs;
  RxString formattedFromDate = "".obs;

  var expenseapiService = ViewExpenseRepo();
  var leaveapirepo = LeaveRepo();

  final viewExpensedatalist = ExpenseModel().obs;
  final leaveviewlist = LeaveViewModal().obs;

  final expenseTypeVariable = ViewExpensesData().obs;
  final expenseTypeDataList = <ViewExpensesData>[].obs;
  var expenseTypeId = 0.obs;

  final rxRequestStatus1 = Status.Loading.obs;

  void setRxRequestStatus1(Status _value) => rxRequestStatus1.value = _value;

  // final rxRequestStatus = Status.Loading.obs;
  final rxRequestStatus = Status.Complete.obs;
  RxString error = "".obs;
  var userID = 0.obs;
  RxString userName = "".obs;
  RxString categoryId = "".obs;
  RxString selectedTimeFrom = "".obs;
  RxString selectedTimeTo = "".obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value; //

  void setDataList(ExpenseModel _value) =>
      viewExpensedatalist.value = _value; //
  void setleaveList(LeaveViewModal _value) => leaveviewlist.value = _value; //
  void setError(String _value) => error.value = _value; //
  Rx<DateTime> targetDateTime = DateTime.now().obs;
  RxString currentMonth = DateFormat.yMMM().format(DateTime.now()).obs;
  Rx<DateTime> currentDate2 = DateTime.now().obs;

  final connectionController = Get.find<ConnectionManagerController>();
  var userId = 0.obs;
  static final Widget eventIcon = Container(
    decoration: BoxDecoration(
      color: Colors.green.withOpacity(0.5),
      borderRadius: BorderRadius.all(Radius.circular(1000.r)),
    ),
  );
  static final Widget eventIcon1 = Container(
    decoration: BoxDecoration(
      color: Colors.red.withOpacity(0.5),
      borderRadius: BorderRadius.all(Radius.circular(1000.r)),
    ),
  );
  RxString formattedDateToday = "".obs;
  RxString todayDate = "".obs;
  var employeeID = 0.obs;
  var markedDateMap = EventList<Event>(
    events: {
      DateTime(2023, 11, 12): [
        Event(
          date: DateTime(0000, 00, 00),
          title: "Please! Try again",
          icon: eventIcon,
        ),
      ],
    },
  ).obs;
  var markedDateMap1 = EventList<Event>(
    events: {
      DateTime(2023, 11, 12): [
        Event(
          date: DateTime(0000, 00, 00),
          title: "Please! Try again",
          icon: eventIcon,
        ),
      ],
    },
  ).obs;

  // Rx<DateTime> selectedFromDate = DateTime.now().obs;
  Rx<DateTime> selectedToDate = DateTime.now().obs;
  RxString formattedToDate = ''.obs;

  get homeworkFile => null;

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
            leavelist.add(datum);
          }
          Employename employename = Employename.fromJson(data);
          print(employename.data);
          leaveemployees.value = employename.data!;
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

  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedFromDate.value,
      currentDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.day,
    );

    if (picked != null && picked != selectedFromDate.value) {
      selectedFromDate.value = picked;
      formattedFromDate.value =
          DateFormat('yyyy-MM-dd').format(selectedFromDate.value);
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedToDate.value,
      currentDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2026),
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.day,
    );

    if (picked != null && picked != selectedToDate.value) {
      selectedToDate.value = picked;
      formattedToDate.value =
          DateFormat('yyyy-MM-dd').format(selectedToDate.value);
    }
  }

  @override
  void onReady() async {
    super.onReady();
    userId.value = await PrefManager().readValue(
      key: PrefConst.addUserId,
    );

    await setUserData();
    await clientTypeApi();
    expenseTypeVariable.value = expenseTypeDataList.first;
    userName.value = await PrefManager().readValue(key: PrefConst.userName);
    userID.value = await PrefManager().readValue(key: PrefConst.addUserId);
    //empId.value = await PrefManager().readValue(key: PrefConst.addEmployeeId);
    print("username  ${userName.value}");
  }

  setUserData() async {
    var data = await PrefManager().getUserDetails();

    final ab = await connectionController.checkConnectivity();
    print(" ab is connection ${ab}");
    if (ab == true) {
      expenseapiService.viewExpenserepo(userId.value).then((value) async {
        setRxRequestStatus(Status.Complete);
        setDataList(value);
        PrefManager().setViewExpense(viewExpenseData: value);
        await getviewExpense();
      }).onError((error, stackTrace) {
        print("error in teacher ${error.toString()}");
        setError(error.toString());
        setRxRequestStatus(Status.Error);
      });
    } else {
      setRxRequestStatus(Status.Complete);
      await getviewExpense();
    }
  }

  void onInit() async {
    super.onInit();
    empid.value = await PrefManager().readValue(key: PrefConst.addEmployeeId);
    await leaveApi();
    await fetchEmployees();
    await datefilterLeaveApi();
  }

  Future<void> clientTypeApi() async {
    expenseTypeDataList.value = await expenseapiService.expenseTypeRepo();
    expenseTypeDataList.insert(0, ViewExpensesData(category: "Expense Type"));
    if (kDebugMode) {
      print(" expense type ${expenseTypeDataList}  ");
    }
    setRxRequestStatus(Status.Complete);
  }

  Future<void> getviewExpense() async {
    var data = await PrefManager().getExpense();
    print("saved  syllabus  ${data}");
    viewExpensedatalist.value = ExpenseModel.fromJson(jsonDecode(data));
    print(" saved data syllabus ${viewExpensedatalist.value}");
  }

  void dataListApi() {
    expenseapiService.viewExpenserepo(userId.value).then((value) {
      setRxRequestStatus(Status.Complete);
      setDataList(value);
      print("syllabus page controler working${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  Future<void> leaveApi() async {
    await leaveapirepo.leaveapi(empid.value).then((value) {
      setRxRequestStatus(Status.Complete);
      setleaveList(value);
      print("syllabus page controler working${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  Future<void> datefilterLeaveApi() async {
    await leaveapirepo.dateFilterLeaveApi(empid.value).then((value) {
      setRxRequestStatus(Status.Complete);
      LeaveViewModal modal = LeaveViewModal.fromJson(value);
      var savedLeaveCalender = LeaveViewModal.fromJson(value);
      Map<DateTime, List<Event>> events = {};
      for (final d in savedLeaveCalender.data!) {
        if (kDebugMode) {
          print("printing leavetype in leave screen ${d.leaveType}");
        }
        DateTime leaveFromDate =
            DateTime.parse(d.leaveFromDate ?? "2023-12-25T00:00:00");
        DateTime leaveToDate =
            DateTime.parse(d.leaveToDate ?? "2023-12-25T00:00:00");
        for (DateTime date = leaveFromDate;
            date.isBefore(leaveToDate.add(Duration(days: 1)));
            date = date.add(Duration(days: 1))) {
          events[date] = [
            Event(
              date: date,
              title: "A",
              icon: eventIcon1,
              description:
                  "Leave Type: ${d.leaveType}\nLeave from: ${DateFormat("dd:MM:yyy").format(leaveFromDate)}\nLeave to: ${DateFormat("dd:MM:yyy").format(leaveToDate)}",
            ),
          ];
        }
      }
      if (kDebugMode) {
        print("Events Map: $events");
      }
      markedDateMap1.value = EventList<Event>(events: events);
      if (kDebugMode) {
        print("MarkedDateMap: ${markedDateMap1.value}");
      }
      String startDate = formattedFromDate.value;
      String endDate = formattedToDate.value;
      leaveviewlist.value = modal.filterDataBetweenDates(startDate, endDate);
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Complete);
    });
  }

  Future<void> updateDataListApi() async {
    setRxRequestStatus(Status.Loading);

    expenseapiService.viewExpenserepo(userId.value).then((value) {
      setRxRequestStatus(Status.Complete);
      setDataList(value);
      print("Class Data ${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    if (result != null) {
      selectedImage = result.files.first.toString();
    } else {
      if (kDebugMode) {
        print('No image selected');
      }
    }
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  void getImage(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
      // selectedImageSize.value = (File(selectedImagePath.value)).l

      print("file path ${selectedImagePath.value}");
    }
  }

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) {
      return null;
    }

    return File(pickedFile.path);
  }

  Future<String?> convertImageToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return base64Encode(bytes);
  }

  var selectedCategory = 'Petrol'.obs;

  List<String> categoryList = [
    'Petrol',
    'Expense',
  ];

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null)
    // selectedTime.value =
    //     picked.hour.toString() + ':' + picked.minute.toString();
    if (kDebugMode) {
      print(
          "date Time  =====>${picked.hour.toString() + ':' + picked.minute.toString()}");
    }
  }
}
