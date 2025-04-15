import 'package:get/get.dart';
import 'package:sspl/controllers/AddNewController/AddNewCoustomer.dart';
import 'package:sspl/controllers/EnquiryScreenController/EnquiryScreenController.dart';
import '../../controllers/dashboard/existing_sclient_screen_controller.dart';

class ClientsiteVisitScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExistingClientController());
    Get.lazyPut(() => EnquiryController());
  }
}
