import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';

import '../../infrastructure/local_storage/connection_controller.dart';
import '../../infrastructure/local_storage/local_storage.dart';
import '../../infrastructure/local_storage/pref_consts.dart';
import '../../sevices/api_sevices/api_services.dart';
import '../../sevices/models/expense/expense_model.dart';
import '../../sevices/models/expense/view_expenses.dart';
import '../../sevices/repo/repo.dart';
import 'package:http/http.dart' as https;

class AddNewController extends GetxController {
  TextEditingController updateCityName = TextEditingController();
  TextEditingController updateContactPerson = TextEditingController();
  TextEditingController updateEmailId = TextEditingController();
  TextEditingController updateCustomerName = TextEditingController();
  TextEditingController updateVisit = TextEditingController();
  RxString updateexpensepurpose = ''.obs;
  RxString updatepurpose = ''.obs;
  TextEditingController updateExpenseDetails = TextEditingController();
  TextEditingController updatetravelamount = TextEditingController();
  TextEditingController updatetravel = TextEditingController();
  TextEditingController updateAmount2 = TextEditingController();
  TextEditingController updatepubliccon = TextEditingController();
  TextEditingController updateAmount = TextEditingController();
  TextEditingController updateVisitDetails = TextEditingController();
  TextEditingController updateContactNO = TextEditingController();
  TextEditingController CustomerName = TextEditingController();
  TextEditingController ContactNO = TextEditingController();
  TextEditingController travel = TextEditingController();
  TextEditingController travelamount = TextEditingController();
  TextEditingController Visit = TextEditingController();

  var customer = "".obs;
  var contactpersonna = "".obs;
  var contactno = "".obs;
  var Emailid = "".obs;
  var cityname = "".obs;
  var visitdetails = "".obs;

  var empid = 0.obs;
  var customername = TextEditingController();
  var contactpersonN = TextEditingController();
  var contactNO = TextEditingController();
  var EmailiD = TextEditingController();
  var cityNamE = TextEditingController();
  var VisitDetailS = TextEditingController();
  var formKey = GlobalKey<FormState>().obs;

  @override
  void onInit() async {
    super.onInit();
    empid.value = await PrefManager().readValue(key: PrefConst.addEmployeeId);
    customer.value = Get.arguments[0];
    contactpersonna.value = Get.arguments[1];
    contactno.value = Get.arguments[2];
    Emailid.value = Get.arguments[3];
    cityname.value = Get.arguments[4];
    visitdetails.value = Get.arguments[5];
    customername.text = customer.value;
    contactpersonN.text = contactpersonna.value;
    contactNO.text = contactno.value;
    EmailiD.text = Emailid.value;
    cityNamE.text = cityname.value;
    VisitDetailS.text = visitdetails.value;

    /*addExpense(empid.value,
        Visit.value.text,
        purpose.value,
        CustomerName.value.text,
        CityName.value.text,
        ContactPerson.value.text,
        ContactNO.value.text,
        EmailId.value.text,
        VisitDetails.value.text,
        expensepurpose.value,
        Amount.value.text,
        publiccon.value.text,
        Amount2.value.text,
        travel.value.text,
        travelamount.value.text,
        ExpenseDetails.value.text);*/
    travel.addListener(_updateAmount);
  }

  Future<void> addExpense(
    empId,
    vDate,
    vPurpose,
    vcustomerName,
    vcityName,
    vcontactPersonName,
    vContactNO,
    vEmailId,
    vVisitdetails,
    EPurpose,
    EAmount,
    EPublicConveyance,
    Eamount,
    EtravelKm,
    EAmount2,
    EexpenseDetiails,
  ) async {
    const String url =
        'http://sarvaperp.eduagentapp.com/api/SarvapErp/AddEmpMarktingExp';

    // Create the request body
    Map<dynamic, dynamic> body = {
      "VisitDate": vDate.toString(),
      "Purpose": vPurpose.toString(),
      "CustomerName": vcustomerName.toString(),
      "CityName": vcityName.toString(),
      "ContactPersonName": vcontactPersonName.toString(),
      "ContactNo": vContactNO.toString(),
      "emailid": vEmailId.toString(),
      "VisitDetails": vVisitdetails.toString(),
      "EXPPurpose": EPurpose.toString(),
      "EXPAmount ": EAmount.toString(),
      "EXPPublicConveDetails": EPublicConveyance.toString(),
      "EXPAmount2": Eamount.toString(),
      "EXPTravelKmVehicle": EtravelKm.toString(),
      "EXPAmount3": EAmount2.toString(),
      "EXPExpensedetails": EexpenseDetiails.toString(),
      "CreateBy": empId.value.toString(),
    };

    try {
      // Make the HTTP POST request
      final response = await https.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Log success message and response body
        print('Expense added successfully');
        // ScaffoldMessenger
        //     .of(context).showSnackBar(
        //     const SnackBar(content: Text("Submit Sucessfully"))
        // );
        //print('Response body: ${response.body}');
      } else {
        // Print error message if the request was not successful
        print('Failed to add expense. Status code: ${response.statusCode}');
        // ScaffoldMessenger
        //     .of(context).showSnackBar(
        //     const SnackBar(content: Text("Failed to Submit"))
        // );
        //print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print('Error occurred while adding expense: $e');
    }
  }

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
int empid = 0;
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
