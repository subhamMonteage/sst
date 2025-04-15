import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';
import 'package:get/get.dart';

import '../../sevices/api_sevices/api_services.dart';
import '../../sevices/models/followup_model/nextday_followup_model.dart';
import '../../sevices/repo/repo.dart';

class NextDayFollowupController extends GetxController {
  final viewNextDayFollowupApi = NextDayFollowupRepo();
  final ImagePicker _picker = ImagePicker();

  var empName = ''.obs;
  var cId = ''.obs;
  var error = ''.obs;
  var selectedDate = ''.obs;
  var isLoading = false.obs;
  var rxRequestStatus = Status.Loading.obs;

  XFile? _imageFile;

  XFile? get imageFile => _imageFile;

  TextEditingController jobDetailsController = TextEditingController();
  final viewNextDayFollowupDataList = NextDayFollowupModel().obs;

  @override
  void onInit() async {
    super.onInit();
    cId.value = await PrefManager().readValue(key: PrefConst.cId);
    dataListApi();
  }

  void setError(String value) => error.value = value;

  void setDataList(NextDayFollowupModel value) =>
      viewNextDayFollowupDataList.value = value;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _imageFile = image;
        update(); // Update the state to reflect the new image
      }
    } catch (e) {
      setError(e.toString());
    }
  }

  void dataListApi() {
    setRxRequestStatus(Status.Loading);
    viewNextDayFollowupApi.nextDayFollowupRepo(cId.value).then((value) {
      setRxRequestStatus(Status.Complete);
      setDataList(value);
      print("view today visit page controller working ${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  Future<void> updateDataListApi() async {
    setRxRequestStatus(Status.Loading);
    await viewNextDayFollowupApi.nextDayFollowupRepo(cId.value).then((value) {
      setRxRequestStatus(Status.Complete);
      setDataList(value);
      print("visit today data Data ${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }
}
