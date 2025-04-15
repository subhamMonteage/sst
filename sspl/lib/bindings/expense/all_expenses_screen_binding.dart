import 'package:get/get.dart';

import '../../controllers/expense/all_expenses_screen_controller.dart';

class AllExpenseScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllExpensesScreenController());
  }
}
