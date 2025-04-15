import 'package:sspl/controllers/intro/splash_screen_controller.dart';
import 'package:sspl/infrastructure/image_constants/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends GetView<SplashScreenController> {
  @override
  Widget build(BuildContext context) {
    Get.put(SplashScreenController());
    return Scaffold(
      body: Container(
        height: Get.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              ImageConstants.background,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Image.asset(ImageConstants.logo),
        ),
      ),
    );
  }
}
