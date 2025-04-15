import 'package:get/get.dart';

import '../../controllers/EnquiryScreenController/updateController.dart';

class UpdateEnquiryBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => UpdateController());
  }
}
