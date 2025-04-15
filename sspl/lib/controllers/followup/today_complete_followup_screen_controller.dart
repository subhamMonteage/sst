import 'package:sspl/infrastructure/local_storage/local_storage.dart';
import 'package:sspl/infrastructure/local_storage/pref_consts.dart';
import 'package:sspl/sevices/api_sevices/api_services.dart';
import 'package:sspl/sevices/models/followup_model/today_complete_followup_model.dart';
import 'package:sspl/sevices/repo/repo.dart';
import 'package:get/get.dart';

class TodayCompleteFollowupController extends GetxController {
  final todayconplateFollowupdetailsApi = TodayCompleteFollowupRepo();
  final todayconplateFollowupdetailsDataList = TodayCompleteFollowupModel().obs;

  void setError(String _value) => error.value = _value;

  void setDataList(TodayCompleteFollowupModel _value) =>
      todayconplateFollowupdetailsDataList.value = _value; //
  final rxRequestStatus = Status.Loading.obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  var cId = "".obs;
  RxString error = "".obs;
  RxString selectedDate = "".obs;
  final isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    cId.value = await PrefManager().readValue(key: PrefConst.cId);
    dataListApi();
  }

  void dataListApi() {
    todayconplateFollowupdetailsApi
        .todayCompleteFollowupRepo(cId.value)
        .then((value) {
      setRxRequestStatus(Status.Complete);
      setDataList(value);
      print("view today visit page controller working${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }

  Future<void> updateDataListApi() async {
    setRxRequestStatus(Status.Loading);

    await todayconplateFollowupdetailsApi
        .todayCompleteFollowupRepo(cId.value)
        .then((value) {
      setRxRequestStatus(Status.Complete);
      setDataList(value);
      print("visit today data Data ${value.message}");
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.Error);
    });
  }
}
