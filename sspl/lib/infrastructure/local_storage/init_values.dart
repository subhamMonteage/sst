import 'package:sspl/infrastructure/local_storage/connection_controller.dart';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:get/get.dart';

class InitVariables {
  onInit() {
    PrefManager().initlizedStorage();
    Get.put(ConnectionManagerController());
  }
}
