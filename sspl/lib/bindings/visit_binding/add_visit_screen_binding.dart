import 'package:sspl/controllers/AddNewController/AddNewCoustomer.dart';
import 'package:sspl/controllers/add_visit_screen_controller/add_visit_screen_controller.dart';
import 'package:get/get.dart';
import 'package:sspl/view/expense/add_visit_screen.dart';

class AddVisitScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddVisitScreenController());
  }
}
