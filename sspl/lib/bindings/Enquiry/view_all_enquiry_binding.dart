import 'package:get/get.dart';
import 'package:sspl/controllers/EnquiryScreenController/view_all_enquiry_controller.dart';

class ViewAllEnquiryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewAllEnquiryController());
  }
}
