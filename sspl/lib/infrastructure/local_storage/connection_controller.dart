import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sspl/utilities/custom_toast/custom_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ConnectionManagerController extends GetxController {
  RxBool connectionType = false.obs;
  var connectedVia = "".obs;
  ConnectivityResult? connectivityResult;

  final Connectivity _connectivity = Connectivity();

  late StreamSubscription _streamSubscription;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print("object in internet checker");
    }
    checkConnectivity();
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen(updateState);
  }

  Future<bool> checkConnectivity() async {
    final connectivityResult = await (_connectivity.checkConnectivity());
    return updateState(connectivityResult);
  }

  Future<void> getConnectivityType() async {
    late ConnectivityResult connectivityResult;
    try {
      connectivityResult = await (_connectivity.checkConnectivity());
    } catch (e) {
      Logger().e("Internet connectivity error:==>$e");
    }
    return updateState(connectivityResult);
  }

  updateState(ConnectivityResult result) {
    connectivityResult = result;
    switch (result) {
      case ConnectivityResult.wifi:
        connectedVia.value = "Wifi";
        connectionType.value = true;
        return true;
      case ConnectivityResult.mobile:
        connectedVia.value = "Mobile";
        connectionType.value = true;
        return true;
      case ConnectivityResult.none:
        connectedVia.value = "None";
        connectionType.value = false;
        // Get.to(NoInternetScreen());
        // Get.snackbar(
        //   "No Internet",
        //   "The data will not sync with the server in real time.",
        //   duration: Duration(
        //     seconds: 10,
        //   ),
        //   backgroundColor: Colors.yellow.shade600,
        // );

        return false;
      default:
        ShortMessage.snackBar(
            title: 'Failed to get connection type', message: "");
        return false;
    }
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
  }
}
