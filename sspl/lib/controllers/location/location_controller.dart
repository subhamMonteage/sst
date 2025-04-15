import 'package:permission_handler/permission_handler.dart';
import 'package:sspl/infrastructure/local_storage/connection_controller.dart';
import 'package:sspl/utilities/get_user_loaction.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  final geolocator = Geolocator();
  RxDouble lat = 0.0.obs;
  RxDouble lng = 0.0.obs;
  var street = "".obs;
  var subLocality = "".obs;
  var locality = "".obs;
  var state = "".obs;
  var portalCode = "".obs;
  var updateLocation = false.obs;

  @override
  void onInit() async {
    Get.put(ConnectionManagerController());

    // UserLocation().getLatLng();

    // else {
    //   await Permission.location.isDenied.then((value) {
    //     if (value) {
    //       print("permission status in else ===> $value");
    //       Permission.locationAlways.request();
    //     }
    //   });
    //   // await UserLocation().getLocationPermission();
    //   super.onInit();
    // }
  }

  void changeCurrentLocation(String street, String state, String subLocality,
      String locality, String portalCode, var lat, var lng) {
    this.street.value = street;
    this.state.value = state;
    this.subLocality.value = subLocality;
    this.locality.value = locality;
    this.portalCode.value = portalCode;
    this.lat.value = double.parse(lat);
    this.lng.value = double.parse(lng);
  }

  String getFullAddress() {
    String addressLine =
        '${street.value} ${subLocality.value} ${locality.value} ${state.value} ${portalCode.value}';
    print(" address line $addressLine");
    return addressLine;
  }

  void updateLatLong({required String lat, required String long}) {
    this.lat.value = double.parse(lat);
    lng.value = double.parse(long);
    // getUserDetails();
    print("Location Updated  :==>${lat},${long}");
    print("Location Updated  :==>${this.lat},${lng}");
  }
}
