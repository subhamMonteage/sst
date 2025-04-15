import 'package:get/get.dart';

import '../../controllers/AddNewController/AddNewCoustomer.dart';
import '../../controllers/expense/all_expenses_screen_controller.dart';

class ViewExpenseScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddNewController());
  }
}
