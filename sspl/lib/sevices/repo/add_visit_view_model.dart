import 'package:sspl/controllers/add_visit_screen_controller/add_visit_screen_controller.dart';
import 'package:sspl/infrastructure/routes/page_constants.dart';
import 'package:sspl/sevices/models/visit_models/add_visit_model.dart';
import 'package:sspl/sevices/repo/repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utilities/custom_toast/custom_toast.dart';

class AddVisitViewModel with ChangeNotifier {
  final myRepo = AddVisitRepo();
  final controller = Get.find<AddVisitScreenController>();

  Future<void> addvisitApi(dynamic data, BuildContext context) async {
    controller.isLoading.value = true;
    myRepo.addvisitApi(data).then((value) async {
      var data = AddVisitModel.fromJson(value);

      print(
          "data is in post method and in add schedule api  ${data.data!.organizationname} ");

      if (data.data == null) {
        ShortMessage.toast(
          title: data.message.toString(),
        );
        controller.isLoading.value = false;
      } else if (data.data != null) {
        ShortMessage.toast(
          title: "Visit added successfully",
        );
        Get.back();
        Get.toNamed(AppRoutesName.today_visit_screen);
        controller.isLoading.value = false;

        debugPrint("everything is fine here ");
        if (kDebugMode) {
          print(" no error this side");
        }
        controller.isLoading.value = false;
      } else if (data.statuscode == 400) {
        debugPrint("chakkar hai yahi pr re ");
        ShortMessage.toast(
          title: data.message.toString(),
        );
      }

      if (kDebugMode) {
        print(" value in post method    ${value.toString()}");
      }
    }).onError((error, stackTrace) {
      ShortMessage.toast(title: "Something went wrong");
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
