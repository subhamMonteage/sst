import 'dart:io';

import 'package:sspl/controllers/auth/login_screen_controller.dart';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';
import 'package:sspl/infrastructure/routes/page_constants.dart';
import 'package:sspl/sevices/models/auth/login_model.dart';
import 'package:sspl/sevices/repo/repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utilities/custom_toast/custom_toast.dart';

class LoginViewModel with ChangeNotifier {
  final myRepo = LoginRepo();
  late RxString isactive = "".obs;
  final controller = Get.find<LoginScreenController>();

  Future<void> loginApi(dynamic data) async {
    controller.isLoading.value = true;
    myRepo.loginApi(data).then((value) async {
      var data = LoginModel.fromJson(value);

      print("data is in post method and in loign api ${data.data!.action} ");

      if (data.data == null) {
        ShortMessage.toast(
          title: data.message.toString(),
        );
        controller.isLoading.value = false;
      } else if (data.data != null) {
        ShortMessage.toast(
          title: data.message.toString(),
        );
        Get.offAllNamed(
          AppRoutesName.dashboard_screen,
        );
        controller.isLoading.value = false;
        isactive.value = data.data!.action!;
        PrefManager().writeValue(key: PrefConst.isLoggedIn, value: "Yes");
        // print(data.data!.employeeId);
        PrefManager().writeValue(
            key: PrefConst.addEmployeeId, value: data.data!.employeeId);
        if (isactive.value == "De-Active") {
          print("User status is De-active");
          exit(0);
        }
        PrefManager()
            .writeValue(key: PrefConst.cId, value: data.data!.uRId.toString());
        PrefManager().setUserData(userData: data);

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
      print("error data ===>${error}");
      ShortMessage.toast(title: "Something went wrong");
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
