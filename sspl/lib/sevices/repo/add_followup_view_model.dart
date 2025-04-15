import 'package:sspl/controllers/add_visit_screen_controller/add_visit_screen_controller.dart';
import 'package:sspl/controllers/dashboard/dashboard.dart';
import 'package:sspl/sevices/models/followup_model/add_followup_model.dart';
import 'package:sspl/sevices/models/visit_models/add_visit_model.dart';
import 'package:sspl/sevices/repo/repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utilities/custom_toast/custom_toast.dart';

class AddFollowUpViewModel with ChangeNotifier {
  final myRepo = AddFollowupRepo();
  final controller = Get.find<DashboardController>();

  Future<void> addvisitApi(dynamic data, BuildContext context) async {
    controller.isLoading.value = true;
    myRepo.addFollowupApi(data).then((value) async {
      var data = AddFollowupModel.fromJson(value);

      print(
          "data is in post method and in add followup api  ${data.data!.lFollowupdate} ");

      if (data.data == null) {
        ShortMessage.toast(
          title: data.message.toString(),
        );
        controller.isLoading.value = false;
      } else if (data.data != null) {
        ShortMessage.toast(
          title: "Followup Updated",
        );
        Get.back();
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
