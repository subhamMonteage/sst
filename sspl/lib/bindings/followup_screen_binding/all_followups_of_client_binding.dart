import 'package:sspl/controllers/followup/all_followups_of_client_controller.dart';
import 'package:get/get.dart';

class AllFollowupsofClientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllFollowupsofClientController());
  }
}
