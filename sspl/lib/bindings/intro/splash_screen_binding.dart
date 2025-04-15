import 'package:sspl/controllers/intro/splash_screen_controller.dart';
import 'package:get/get.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SplashScreenController(),
    );
  }
}
