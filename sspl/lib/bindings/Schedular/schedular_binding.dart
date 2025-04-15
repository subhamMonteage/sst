import 'package:get/get.dart';
import 'package:sspl/controllers/schedular/schdeluar_controller.dart';

class SchedularBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SchedularController());
  }
}
