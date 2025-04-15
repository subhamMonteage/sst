import 'package:sspl/controllers/auth/login_screen_controller.dart';
import 'package:sspl/infrastructure/image_constants/image_constants.dart';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';
import 'package:sspl/sevices/repo/login_view_model.dart';
import 'package:sspl/utilities/custom_text/custom_text.dart';
import 'package:sspl/utilities/custom_toast/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends GetView<LoginScreenController> {
  final loginViewModel = Provider.of<LoginViewModel>(Get.context!);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 200.h,
                  child: Image.asset(ImageConstants.logo),
                ),
                Container(
                  height: Get.height / 1.43,
                  width: Get.width,
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50.r),
                      topLeft: Radius.circular(50.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.h, vertical: 5.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                              width: 1.w, color: Colors.grey.shade300),
                          color: Colors.grey.shade100,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: controller.emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email",
                            hintStyle: GoogleFonts.roboto(
                              color: Colors.grey,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.h, vertical: 5.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                              width: 1.w, color: Colors.grey.shade300),
                          color: Colors.grey.shade100,
                        ),
                        child: TextFormField(
                          controller: controller.passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            hintStyle: GoogleFonts.roboto(
                              color: Colors.grey,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      InkWell(
                        onTap: () {
                          if (controller.emailController.value.text
                                  .toString()
                                  .isEmpty &&
                              controller.passwordController.value.text
                                  .toString()
                                  .isEmpty) {
                            ShortMessage.toast(
                                title: "Please fill the empty fields");
                          } else {
                            Map data = {
                              "EmailID": controller.emailController.value.text
                                  .toString(),
                              "Password": controller
                                  .passwordController.value.text
                                  .toString(),
                            };

                            PrefManager().writeValue(
                              key: PrefConst.username,
                              value: controller.emailController.value.text
                                  .toString(),
                            );
                            PrefManager().writeValue(
                              key: PrefConst.userpass,
                              value: controller.passwordController.value.text
                                  .toString(),
                            );
                            loginViewModel.loginApi(data);
                          }
                        },
                        child: Container(
                          width: Get.width,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.h,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              width: 1.w,
                              color: Colors.grey.shade300,
                            ),
                            color: Colors.amber,
                            gradient: const LinearGradient(
                              colors: [
                                Colors.indigo,
                                Colors.blue,
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: CustomText(
                            data: "Login",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    Path path = Path();
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
