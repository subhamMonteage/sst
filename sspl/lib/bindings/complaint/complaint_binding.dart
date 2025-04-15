import 'package:get/get.dart';
import 'package:sspl/controllers/complaint/complaint_controller.dart';

class ComplaintBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => ComplaintController());
  }
}
