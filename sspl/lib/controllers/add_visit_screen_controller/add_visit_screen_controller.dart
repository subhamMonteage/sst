import 'dart:io';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';
import 'package:sspl/sevices/api_sevices/api_services.dart';
import 'package:sspl/sevices/models/visit_models/visit_type_model.dart';
import 'package:sspl/sevices/repo/repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddVisitScreenController extends GetxController {
  var organizationController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var personNameController = TextEditingController().obs;
  var phoneController = TextEditingController().obs;
  var alternatePhoneController = TextEditingController().obs;
  var addressController = TextEditingController().obs;
  var remarksController = TextEditingController().obs;
  RxString selectedDate = "".obs;
  var selectedImagePath = "".obs;
  var selectedTime = "".obs;
  var selectedDatePost = "".obs;
  var cId = "".obs;
  var courseId = "".obs;
  var courseName = "".obs;
  RxString draggedAddress = "".obs;
  var loaderValue = 0.0.obs;
  var lat = 0.0.obs;
  var lng = 0.0.obs;
  RxString locality = "".obs;
  final isLoading = false.obs;
  final organizationDataDropdown = <OrganizationData>[].obs;
  var organizationdropdownapi = OrganizationDropdownValueRepo();
  final organizationVariable = OrganizationData().obs;
  final rxRequestStatus = Status.Loading.obs;
  RxString error = "".obs;
  RxString selectedAction = "".obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;

  String? validateEmail(String? value) {
    const pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    final regex = RegExp(pattern);

    return value!.isEmpty || !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  @override
  void onInit() async {
    super.onInit();
    cId.value = await PrefManager().readValue(
      key: PrefConst.cId,
    );

    await organizationTypeListApi();
    organizationVariable.value = organizationDataDropdown.first;
    await gotoUserCurrentPosition();
  }

  Future<void> organizationTypeListApi() async {
    organizationDataDropdown.value =
        (await organizationdropdownapi.organizationrepodropdown(cId.value))
            .cast<OrganizationData>();
    organizationDataDropdown.insert(0, OrganizationData(date: "Select Type"));

    setRxRequestStatus(Status.Complete);
  }

  Future gotoUserCurrentPosition() async {
    print(1);
    loaderValue.value = 1;
    Position currentPosition = await determinePosition();
    print(2);
    lat.value = currentPosition.latitude;
    lng.value = currentPosition.longitude;
    print(" lat long ${lat.value}");
    print(" lat long ${lng.value}");
    gotoSpecificPosition(
        LatLng(currentPosition.latitude, currentPosition.longitude));
    print(3);
  }

  Future gotoSpecificPosition(LatLng position) async {
    // GoogleMapController mapController = await googleMapController.future;
    // mapController.animateCamera(CameraUpdate.newCameraPosition(
    //     CameraPosition(target: position, zoom: 17.5)));
    print(4);
    //every time that we dragged pin , it will list down the address here

    await getAddress(position);
    print(5);
  }

  Future getAddress(LatLng position) async {
    print(6);
    //this will list down all address around the position
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark address = placemarks[0];
    // print(
    //     "placemen tin init ===> $placemarks"); // get only first and closest address
    String addresStr =
        "${address.name} ,${address.street}, ${address.subLocality}, ${address.locality}, ${address.subAdministrativeArea} ,${address.administrativeArea}";
    // " ${address.postalCode}, ${address.country},  ${address.isoCountryCode}";
    print("address in init ===> $addresStr");
    locality.value = address.subLocality!;
    print(7);
    draggedAddress.value = addresStr;
    loaderValue.value = 0;
    print("dragged location is ===> ${draggedAddress.value}");
    print(8);
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    return position;
  }

  final lAction = 'Select Action'.obs;
  final lActionValue = <String>[
    "Select Action",
    "Next Session",
    "Not eligible",
    "Registered",
    "In Progress",
    "Invalid",
    "Contacted",
    "Not Reachable",
    "Not Interested",
    "Duplicate",
    "Closed",
  ];
}
