// import 'dart:developer';
//
// import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
// import 'package:sspl/controllers/add_visit_screen_controller/add_visit_screen_controller.dart';
// import 'package:sspl/controllers/dashboard/bottomnavigation_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// class BottomNaviagationScreen
//     extends GetView<BottomnavigationScreenController> {
//   @override
//   Widget build(BuildContext context) {
//     Get.put(BottomnavigationScreenController());
//     Get.put(AddVisitScreenController());
//     return Scaffold(
// //  appBar: AppBar(
// //     flexibleSpace: Padding(
// //     padding: EdgeInsets.only(top: 40.h),
// //     child: Image.asset(ImageConstants.logo),
// //     ),
// //     backgroundColor: Color(0xFFf7bc20),
// //     ),
// // drawer: AppDrawer(),
//       body: PageView(
//         controller: controller.pageController,
//         physics: const NeverScrollableScrollPhysics(),
//         children: List.generate(controller.bottomBarPages.length,
//             (index) => controller.bottomBarPages[index]),
//       ),
//       extendBody: true,
//       bottomNavigationBar:
//           (controller.bottomBarPages.length <= controller.maxCount)
//               ? AnimatedNotchBottomBar(
//                   notchBottomBarController: controller.bottombarcontroller,
//                   color: Colors.white,
//                   showLabel: true,
//                   notchColor: Color(0xFFf7bc20),
//                   removeMargins: false,
//                   bottomBarWidth: 500,
//                   durationInMilliSeconds: 300,
//                   bottomBarItems: [
//                     BottomBarItem(
//                       inActiveItem: Icon(
//                         Icons.work_outline,
//                         color: Colors.black,
//                       ),
//                       activeItem: Icon(
//                         Icons.work_outline,
//                         color: Colors.black,
//                       ),
//                       itemLabel: "Add Visit",
//                     ),
//                     BottomBarItem(
//                         inActiveItem: Icon(
//                           CupertinoIcons.home,
//                           color: Colors.black,
//                         ),
//                         activeItem: Icon(
//                           CupertinoIcons.home,
//                           color: Colors.red.shade900,
//                         ),
//                         itemLabel: "Home"),
//                     BottomBarItem(
//                       inActiveItem: Icon(
//                         Icons.today_rounded,
//                         color: Colors.black,
//                       ),
//                       activeItem: Icon(
//                         Icons.add,
//                         color: Colors.amber,
//                       ),
//                       itemLabel: "Followup",
//                     ),
//                   ],
//                   onTap: (index) {
//                     log('current selected index $index');
//                     controller.pageController.jumpToPage(index);
//                   },
//                   kIconSize: 30.r,
//                   kBottomRadius: 10.r,
//                 )
//               : null,
//     );
//   }
// }
