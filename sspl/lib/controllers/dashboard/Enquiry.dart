import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import '../../sevices/api_sevices/api_services.dart';

class ExistingEnquirytController extends GetxController {
  TextEditingController textFormController = TextEditingController();

  // final updateClientModel = Get.find<UpdateClientController>();
  // final journeyUpdateModel = Get.find<UpdateJourneyController>();
  // final endMeetingModel = Get.find<EndMeetingController>();
  // final addMeetingModel = Get.find<AddMeetingController>();
  // final addScheduleModel = Get.find<AddExistingClientScheduleController>();
  // var apiService = AllApiServices();
  // final viewMeetingDataList = ViewMeetingModel().obs;
  // void setDataListMeeting(ViewMeetingModel _value) =>
  //     viewMeetingDataList.value = _value;
  var isListening = false.obs;
  var speechText = "Speak".obs;

  // SpeechToText? speechToText;
  RxBool isNoMeetingRunning = true.obs;
  RxString draggedAddress = "".obs;
  final rxRequestStatus = Status.Loading.obs;
  RxString error = "".obs;
  final rxRequestStatus1 = Status.Loading.obs;
  RxString error1 = "".obs;
  var loaderValue = 0.0.obs;

  // final viewClientdatalist = ViewClientModel().obs;
  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;

  // void setDataList(ViewClientModel _value) => viewClientdatalist.value = _value;
  // void setError(String _value) => error.value = _value;

  // final userLocationDataList = GetUserLocationModel().obs;
  void setRxRequestStatus1(Status _value) => rxRequestStatus1.value = _value;

  // void setDataList1(GetUserLocationModel _value) =>
  //     userLocationDataList.value = _value;
  void setError1(String _value) => error1.value = _value;

  var lat = 0.0.obs;
  var lng = 0.0.obs;

  // final connectionController = Get.find<ConnectionManagerController>();
  TextEditingController clientremarksController = TextEditingController();

  final isLoading = false.obs;
  var count = 0.obs;
  RxString selectedDate = "".obs;
  RxString selectedTime = "".obs;
  var startMeetingUID = "".obs;
  var meetingStatus = 0.obs;
// final homeController = Get.find<HomeMainScreenController>();
/*  @override
  void onInit() async {
    super.onInit();
    // setUserData();
    // homeController.userId.value =
    //     await PrefManager().readValue(key: PrefConst.addUserId);
    // print("user id existin m ==>${homeController.userId.value}");
    // homeController.getJID.value = await homeController.apiService.getJID(
    //   homeController.userId.value,
    // );
    dataListApi();
    userLocationApi();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ShortMessage.toast(title: "Location Not enabled");
      await showAdaptiveDialog<bool>(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog.adaptive(
            content: const Text(
                'Your Location is not enabled, Please enable it and restart the app again'),
            actions: [
              TextButton(
                onPressed: () async{
                  await Geolocator.openLocationSettings();
                  exit(0);
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      return Future.error('Location services are disabled.');
    }
    await gotoUserCurrentPosition();
    viewMeetingDataApi();

    homeController.userId.value =
        await PrefManager().readValue(key: PrefConst.addUserId);

    print("user id in 2:32 ${homeController.userId.value}");
    print(
        "unique id in existing client controller ===> ${homeController.uniqueValue.value}");
    print("usid value is ===> ${homeController.usid.value}");

    incrementCounter();
  }

  void incrementCounter() {
    count.value++;
    print(count.value);
  }


  setUserData() async {
    homeController.userId.value =
    await PrefManager().readValue(key: PrefConst.addUserId);
    print("user id existing m ==>${homeController.userId.value}");
    homeController.getJID.value = await homeController.apiService.getJID(
      homeController.userId.value,
    );
    dataListApi();
    var data = await PrefManager().getUserDetails();
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
    print("date month ${DateFormat('MMMM').format(DateTime.now())}");
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
    print(
        "placemen tin init ===> $placemarks"); // get only first and closest address
    String addresStr =
        "${address.name} ,${address.street}, ${address.subLocality}, ${address.locality}, ${address.subAdministrativeArea} ,${address.administrativeArea}, ${address.postalCode}, ${address.country},  ${address.isoCountryCode}";
    print("address in init ===> $addresStr");
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
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

   void dataListApi() async{
    homeController.userId.value =
        await PrefManager().readValue(key: PrefConst.addUserId);
    print("user id data api method m ==>${homeController.userId.value}");
    homeController.getJID.value = await homeController.apiService.getJID(
      homeController.userId.value,
    );
    apiService.viewClientrepo(homeController.userId.value).then((value) {
      setRxRequestStatus(Status.Complete);
      setDataList(value);
      print("syllabus page controler working${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  void userLocationApi() {
    apiService.userLocationRepo(homeController.userId.value).then((value) {
      setRxRequestStatus1(Status.Complete);
      setDataList1(value);
      print("user location  ${value.message}");
      print(
          "user long ${userLocationDataList.value.data![0].sLongitude.toString()}");
    }).onError((error, stackTrace) {
      setError1(error.toString());
      setRxRequestStatus1(Status.Error);
    });
  }

  Future<void> updateDataListApi() async {
    setRxRequestStatus(Status.Loading);

    apiService.viewClientrepo(homeController.userId.value).then((value) {
      setRxRequestStatus(Status.Complete);
      setDataList(value);

      print("Class Data ${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  Future<void> updateUserLocationApi() async {
    setRxRequestStatus1(Status.Loading);
    apiService.userLocationRepo(homeController.userId.value).then((value) {
      setRxRequestStatus1(Status.Complete);
      setDataList1(value);
      print("syllabus page controler working${value.message}");
    }).onError((error, stackTrace) {
      setError1(error.toString());
      setRxRequestStatus1(Status.Error);
    });
  }

  void viewMeetingDataApi() {
    setRxRequestStatus(Status.Loading);
    apiService.viewMeetingRepo(homeController.userId.value).then((value) {
      setRxRequestStatus(Status.Complete);
      setDataListMeeting(value);
      print(
          "view meeting Api working  ${viewMeetingDataList.value.data![0].meetingId}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  Future<void> updateViewMeetingDataApi() async {
    setRxRequestStatus(Status.Loading);
    apiService.viewMeetingRepo(homeController.userId.value).then((value) {
      setRxRequestStatus(Status.Complete);
      setDataListMeeting(value);
      print(
          "view meeting Api working  ${viewMeetingDataList.value.data![0].meetingId}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }*/
}
