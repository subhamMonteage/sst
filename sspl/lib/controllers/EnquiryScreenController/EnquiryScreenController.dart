import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:sspl/sevices/models/enquiry/enquiry_model.dart';

import '../../infrastructure/local_storage/connection_controller.dart';
import '../../infrastructure/local_storage/local_storage.dart';
import '../../infrastructure/local_storage/pref_consts.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../sevices/models/expense/expense_model.dart';
import '../../sevices/models/expense/view_expenses.dart';
import '../../sevices/repo/repo.dart';

class EnquiryController extends GetxController {
  TextEditingController Cityname = TextEditingController();
  TextEditingController Contactperson = TextEditingController();
  TextEditingController ContactNo = TextEditingController();
  TextEditingController VisitDetails = TextEditingController();
  TextEditingController Amount = TextEditingController();
  TextEditingController publiccon = TextEditingController();
  TextEditingController Amount2 = TextEditingController();
  TextEditingController travel = TextEditingController();
  TextEditingController travelamount = TextEditingController();
  TextEditingController EnquiryDetails = TextEditingController();
  var empid = 0.obs;
  final viewEnquiryList = ViewEnquiryModel().obs;

  void setEnquiryList(ViewEnquiryModel value) =>
      viewEnquiryList.value = value; //
  var viewenquiryApi = ViewEnquiry();
  RxString purpose = ''.obs;
  RxString status = 'Pending'.obs;
  RxString updatestatus = ''.obs;
  TextEditingController updateEnquiryDetails = TextEditingController();

  TextEditingController tolocation = TextEditingController();
  TextEditingController Customername = TextEditingController();
  TextEditingController Emailid = TextEditingController();
  final rxRequestStatus = Status.Loading.obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;

  void setError(String _value) => error.value = _value;
  RxString error = "".obs;
  var formKey = GlobalKey<FormState>().obs;
  var formKeys = GlobalKey<FormState>().obs;

  Rx<DateTime> selectedFromDate = DateTime.now().obs;
  Rx<DateTime> selectedToDate = DateTime.now().obs;
  RxString formattedFromDate = ''.obs;
  RxString formattedToDate = ''.obs;

  get homeworkFile => null;

  //data for fetch customer field...

  var fetchcustomer = "".obs;
  var fetchcontactperson = "".obs;
  var fetchcontactno = "".obs;
  var fetchEmailid = "".obs;
  var fetchcityname = "".obs;

  var customernamefetch = TextEditingController();
  var contactpersonNfetch = TextEditingController();
  var contactNOfetch = TextEditingController();
  var EmailiDfetch = TextEditingController();
  var cityNamEfetch = TextEditingController();
  var VisitDetailSfetch = TextEditingController();

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
      lastDate: DateTime.now(),
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
  void onInit() async {
    super.onInit();

    empid.value = await PrefManager().readValue(key: PrefConst.addEmployeeId);
    viewEnquiry();
    fetchcustomer.value = Get.arguments[0];
    fetchcontactperson.value = Get.arguments[1];
    fetchcontactno.value = Get.arguments[2];
    fetchEmailid.value = Get.arguments[3];
    fetchcityname.value = Get.arguments[4];
    customernamefetch.text = fetchcustomer.value;
    contactpersonNfetch.text = fetchcontactperson.value;
    contactNOfetch.text = fetchcontactno.value;
    EmailiDfetch.text = fetchEmailid.value;
    cityNamEfetch.text = fetchcityname.value;
    travel.addListener(_updateAmount);
  }

  Future<void> viewEnquiry() async {
    await viewenquiryApi.viewEnquiryListRepo(empid.value).then((value) {
      setRxRequestStatus(Status.Complete);
      setEnquiryList(value);
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  Future<void> datefilterEnquiry() async {
    await viewenquiryApi.datefilterEnquiry(empid.value).then((value) {
      setRxRequestStatus(Status.Complete);
      ViewEnquiryModel modal = ViewEnquiryModel.fromJson(value);
      String startDate = formattedFromDate.value;
      String endDate = formattedToDate.value;
      viewEnquiryList.value = modal.filterDataBetweenDates(startDate, endDate);
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  // Future<void> monthdataListApi() async {
  //   await monthAttdenceApi.viewMonthAttendanceRepo(employeeID.value,formattedDateToday.value).then((value) {
  //     setRxRequestStatus(Status.Complete);
  //     setMonthDataList(value);
  //     formattedDateToday.value = '';
  //     print("Attendance page controller working ${value.message}");

  //   }).onError((error, stackTrace) {
  //     setError(error.toString());
  //     setRxRequestStatus(Status.Error);
  //   });
  // }

  void _updateAmount() {
    double travelKm = double.tryParse(travel.text) ?? 0;
    travelamount.text = (travelKm * 3).toString();
  }

  @override
  void onClose() {
    travel.removeListener(_updateAmount);
    travel.dispose();
    travelamount.dispose();
    super.onClose();
  }
}

var selectedImagePath = "".obs;
String selectedImage = "";
final isLoading = false.obs;
Rx<DateTime> selectedFromDate = DateTime.now().obs;
Rx<DateTime> selectedFromTime = DateTime.now().obs;
RxString formattedFromDate = "".obs;

var expenseapiService = ViewExpenseRepo().obs;

final viewExpensedatalist = ExpenseModel().obs;

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

void setDataList(ExpenseModel _value) => viewExpensedatalist.value = _value; //

void setError(String _value) => error.value = _value; //

final connectionController = Get.find<ConnectionManagerController>();
var userId = 0.obs;
/*  @override
  void onReady() async {
    super.onReady();
    userId.value = await PrefManager().readValue(
      key: PrefConst.addUserId,
    );

    setUserData();
    await clientTypeApi();
    expenseTypeVariable.value = expenseTypeDataList.first;
    userName.value = await PrefManager().readValue(key: PrefConst.userName);
    userID.value = await PrefManager().readValue(key: PrefConst.addUserId);
    print("username  ${userName.value}");
  }


  setUserData() async {
    var data = await PrefManager().getUserDetails();

    final ab = await connectionController.checkConnectivity();
    print(" ab is connection ${ab}");
    if (ab == true) {
      expenseapiService.value.viewExpenserepo( userId.value).then((value) async {
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
  }*/
/*
  Future<void> clientTypeApi() async {
    expenseTypeDataList.value = await expenseapiService.value.expenseTypeRepo();
    expenseTypeDataList.insert(
        0, ViewExpensesData(category: "Expense Type"));
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
    expenseapiService.value.viewExpenserepo( userId.value).then((value) {
      setRxRequestStatus(Status.Complete);
      setDataList(value);
      print("syllabus page controler working${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  Future<void> updateDataListApi() async {
    setRxRequestStatus(Status.Loading);

    expenseapiService.value.viewExpenserepo( userId.value).then((value) {
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
*/

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
    print(
        "date Time  =====>${picked.hour.toString() + ':' + picked.minute.toString()}");
}
