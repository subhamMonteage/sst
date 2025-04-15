import 'package:get/get.dart';
import 'package:sspl/controllers/expense/view_all_expense_controller.dart';

class ViewAllExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewAllExpenseController());
  }
}
