import 'package:sspl/controllers/followup/all_followup_screen_controller.dart';
import 'package:sspl/utilities/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../utilities/custom_color/custom_color.dart';

class AllFollowUpScreen extends GetView<AllFollowUpScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: CustomText(
          data: "All Followup",
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: CustomColor.blueColor,
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
