import 'package:sspl/controllers/location/location_controller.dart';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';
import 'package:sspl/infrastructure/routes/page_constants.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  var waitingTime = 2;

  @override
  void onInit() {
    Get.put(LocationController());
    nextPage();
    super.onInit();
  }

  nextPage() {
    Future.delayed(Duration(seconds: waitingTime), () async {
      var isLogged =
          await PrefManager().readValue(key: PrefConst.isLoggedIn) ?? "";
      var isFirst =
          await PrefManager().readValue(key: PrefConst.isIntroFirst) ?? "";

      if (isLogged == "Yes") {
        Get.offAllNamed(
          AppRoutesName.dashboard_screen,
        );
      } else {
        Get.offAllNamed(
          AppRoutesName.login_screen,
        );
      }
    });
  }
}
