import 'dart:convert';
import 'package:get/get.dart';
import 'package:sspl/sevices/api_sevices/api_services.dart';

import '../../infrastructure/local_storage/connection_controller.dart';
import '../../infrastructure/local_storage/local_storage.dart';
import '../../infrastructure/local_storage/pref_consts.dart';
import '../../sevices/models/expense/expense_model.dart';
import '../../sevices/repo/repo.dart';

class AllExpensesScreenController extends GetxController {
  var expenseapiService = ViewExpenseRepo();

  //q

  final viewExpensedatalist = ExpenseModel().obs;

  // final rxRequestStatus = Status.Loading.obs;
  final rxRequestStatus = Status.Complete.obs;
  RxString error = "".obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value; //

  void setDataList(ExpenseModel _value) =>
      viewExpensedatalist.value = _value; //
  void setError(String _value) => error.value = _value; //

  final connectionController = Get.find<ConnectionManagerController>();
  var userId = 0.obs;

  @override
  void onReady() async {
    super.onReady();
    userId.value = await PrefManager().readValue(
      key: PrefConst.addEmployeeId,
    );
    setUserData();
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
}
