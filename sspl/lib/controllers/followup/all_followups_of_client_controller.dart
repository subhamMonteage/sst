import 'package:sspl/sevices/api_sevices/api_services.dart';
import 'package:sspl/sevices/models/followup_model/followup_detals.dart';
import 'package:sspl/sevices/repo/repo.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AllFollowupsofClientController extends GetxController {
  final followupdetailsApi = FollowupDetailsRepo();
  final followupdetailsModel = FollowupDetailsModel().obs;
  RxList<FollowUpDetailData> followupDataList = <FollowUpDetailData>[].obs;

  var cId = "".obs;
  var contactname = "".obs;
  var courseName = "".obs;
  var organizationname = "".obs;
  var lMobile = "".obs;
  var lEmail = "".obs;
  var curruntAddrs = "".obs;
  var orgaddress = "".obs;
  var alternateEmail = "".obs;
  var alternateMobile = "".obs;
  var lFollowupdate = "".obs;
  var lRemarks = "".obs;
  var lSubstatus = "".obs;
  var followupDate = "".obs;
  var lastAcyivityDate = "".obs;
  var leadid = "".obs;
  var action = "".obs;
  var followupDate2 = "".obs;

  @override
  void onInit() async {
    super.onInit();
    contactname.value = Get.arguments[0];
    courseName.value = Get.arguments[1];
    organizationname.value = Get.arguments[2];
    lMobile.value = Get.arguments[3];
    lEmail.value = Get.arguments[4];
    curruntAddrs.value = Get.arguments[5];
    orgaddress.value = Get.arguments[6];
    alternateMobile.value = Get.arguments[7];
    alternateEmail.value = Get.arguments[8];
    lFollowupdate.value = Get.arguments[9];
    lRemarks.value = Get.arguments[10];
    lSubstatus.value = Get.arguments[11];
    leadid.value = Get.arguments[12];
    action.value = Get.arguments[13];

    followupdetailsModel.value =
        await followupdetailsApi.followupDetailRepo(leadid.value);
    if (followupdetailsModel.value.data != null) {
      for (var c in followupdetailsModel.value.data!) {
        followupDataList.add(c);
      }
    }

    print("leadid ==> ${leadid.value}");
    String apiDate = "${lFollowupdate.value}";
    DateTime dateString = DateTime.parse(apiDate);
    lastAcyivityDate.value =
        DateFormat("dd MMM yyyy HH:mm a").format(dateString);
  }
}
