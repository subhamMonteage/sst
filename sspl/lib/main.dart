import 'package:sspl/infrastructure/local_storage/init_values.dart';
import 'package:sspl/infrastructure/routes/page_constants.dart';
import 'package:sspl/infrastructure/routes/page_routes.dart';
import 'package:sspl/sevices/repo/add_followup_view_model.dart';
import 'package:sspl/sevices/repo/add_visit_view_model.dart';
import 'package:sspl/sevices/repo/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  InitVariables().onInit();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddVisitViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddFollowUpViewModel(),
        ),
      ],
      child: ScreenUtilInit(
          designSize: const Size(480, 800),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return GetMaterialApp(
              title: 'Employee',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
                useMaterial3: true,
              ),
              getPages: AppRoutes.appRoutes(),
              initialRoute: AppRoutesName.splash_screen,
              // home: MyApp1234(),
              // home:  DashboardScreen(),
            );
          }),
    );
  }
}
