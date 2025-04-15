import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:sspl/controllers/location/location_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../infrastructure/local_storage/local_storage.dart';
import '../infrastructure/local_storage/pref_consts.dart';

class UserLocation {
  ReceivePort port = ReceivePort();

  // Stream<ReceivePort> receivePort = Stream();
  Stream<ReceivePort>? receivePort;
  StreamController<ReceivePort> streamController = StreamController();
  var isDeviceMocked = false.obs;
  String logStr = '';
  var long = 0.0.obs;
  var lat = 0.0.obs;
  var addres = ''.obs;

  RxBool isRunning = false.obs;

  // accessing location permission
  Future<bool> getLocationPermission() async {
    // print('location permission');
    var status = await Permission.locationWhenInUse.request().isGranted;
    // print("status ${status}");
    if (status == true) {
      getLatLng();
      return true;
    } else {
      await Permission.location.isDenied.then((value) {
        if (value) {
          print("permission status in else ===> $value");
          Permission.locationAlways.request();
          // openAppSettings();
        }
      });
      await Permission.location.isPermanentlyDenied.then((value) {
        if (value) {
          openAppSettings();
        }
      });
      return false;
    }
  }

  // get latitude and longitude form location
  getLatLng() async {
    var permission = await getLocationPermission();
    // print("permission value  ${permission}");

    if (permission == true) {
      // print("permission value 1  ${permission}");
      var res = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (res.longitude != null) {
        lat.value = res.latitude;
        long.value = res.longitude;
        PrefManager()
            .writeValue(key: PrefConst.clockInLat, value: res.latitude);
        // print(res.latitude);
        PrefManager()
            .writeValue(key: PrefConst.clockInLong, value: res.longitude);
        // print("permission value 2  ${permission}");
        getAddress(lat: res.latitude, lng: res.longitude);
      }
    } else {
      await Geolocator.requestPermission();
      await Permission.location.request();
    }
  }

  //  get address
  getAddress({required double lat, required double lng}) async {
    List<Placemark> addresses = await placemarkFromCoordinates(lat, lng);
    var decodedAddress = addresses[0];
    Placemark address = addresses[0];
    // print(/
    // "placemen tin init ===> $addresses"); // get only first and closest address
    String addresStr =
        "${address.street} ${address.subLocality} ${address.locality} ${address.administrativeArea} ${address.postalCode}";
    // print(addresStr);
    Get.put(LocationController()).changeCurrentLocation(
      decodedAddress.street!,
      decodedAddress.administrativeArea!,
      decodedAddress.subLocality!,
      decodedAddress.locality!,
      decodedAddress.postalCode!,
      lat.toString(),
      lng.toString(),
    );
    addres.value = decodedAddress.toString();
    PrefManager().writeValue(key: PrefConst.clockInLoc, value: addresStr);
    // getDistanceBetween();
  }
}
