import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sspl/sevices/repo/repo.dart';
import '../../sevices/models/expense/add_expense_model.dart';
import '../../utilities/custom_toast/custom_toast.dart';
import '../leave/leave_screen_controller.dart';

class AddExpenseController extends GetxController {
  final myRepo = ViewExpenseRepo();
  final controller = Get.find<LeaveScreenController>();

  Future<void> addexpenseApi(dynamic data, BuildContext context) async {
    controller.isLoading.value = true;
    myRepo.addExpenserepo(data).then((value) async {
      var data = AddExpenseModel.fromJson(value);

      print("data is in post method and in expense api  ${data.data!.name} ");

      if (data.data == null) {
        ShortMessage.toast(
          title: data.message.toString(),
        );
        controller.isLoading.value = false;
      } else if (data.data != null) {
        ShortMessage.toast(
          title: "Expense added successfully",
        );
        Get.back();
        controller.isLoading.value = false;

        debugPrint("everything is fine here ");
        if (kDebugMode) {
          print(" no error this side");
        }
        controller.isLoading.value = false;
      } else if (data.statuscode == 400) {
        debugPrint("status 400 in expense ");
        ShortMessage.toast(
          title: data.message.toString(),
        );
      }

      if (kDebugMode) {
        print(" value in post method    ${value.toString()}");
      }
    }).onError((error, stackTrace) {
      ShortMessage.toast(title: "Something went wrong");
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
