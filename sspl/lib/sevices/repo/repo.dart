import 'package:sspl/sevices/api_sevices/api_services.dart';
import 'package:sspl/sevices/models/Leave/leave_view_model.dart';
import 'package:sspl/sevices/models/attendance/dateAttendanceModel.dart';
import 'package:sspl/sevices/models/complaint/complaint_view_model.dart';
import 'package:sspl/sevices/models/enquiry/enquiry_model.dart';
import 'package:sspl/sevices/models/followup_model/followup_detals.dart';
import 'package:sspl/sevices/models/followup_model/nextday_followup_model.dart';
import 'package:sspl/sevices/models/followup_model/nextweek_followup_model.dart';
import 'package:sspl/sevices/models/followup_model/today_complete_followup_model.dart';
import 'package:sspl/sevices/models/followup_model/today_followup_model.dart';
import 'package:sspl/sevices/models/visit_models/all_visit_model.dart';
import 'package:sspl/sevices/models/visit_models/today_visit_model.dart';
import 'package:sspl/sevices/models/visit_models/visit_type_model.dart';

import '../models/Scheduler/schedular_view_model.dart';
import '../models/attendance/view_attendance_model.dart';
import '../models/expense/expense_model.dart';
import '../models/expense/total_expense_model.dart';
import '../models/expense/viewExpense_modal.dart';
import '../models/expense/view_expenses.dart';

class AppUrl {
  static String base_url = "http://sarvaperp.eduagentapp.com/api/SarvapErp";
  static String login_url = "$base_url/EmpLogins";
  static String companyName_url = "$base_url/SalesCourse";
  static String add_visit = "$base_url/AddSalesLead";
  static String today_visit = "${base_url}/ViewSalesLeadToday";
  static String all_visits = "$base_url/ViewSalesLead";
  static String dateattendance = "$base_url/EmpDateAttdance";
  static String add_followup_url = "$base_url/UpdateSalesLead";
  static String followup_detail_url = "$base_url/GetCommunicateSales";
  static String today_followup_url = "$base_url/ViewEmpJobAssign";
  static String view_schedular_url = "$base_url/ViewSchedulerlist";
  static String today_complete_followup_url = "$base_url/TodayFollowSelesLeads";
  static String next_day_followuo_url = "$base_url/NextdayFollowSelesLeads";
  static String next_week_followup_url = "$base_url/NextweekFollowSelesLeads";

  static var add_expense_Url = "$base_url/AddExpense";
  static var view_expense_url = "$base_url/EmpExpense/";
  static var expense_invoice_download_url =
      "http://hindustana.eduagentapp.com/Upload/InvoiceImg/";
  static var viewExpenses = "$base_url/ViewCategory";
  static var ExpenseView_Url = "$base_url/ViewAppEmpMarktingExp";
  static var ExpenseViewTotal_Url = "$base_url/ViewAppExpPaidUnpaid";
  static var stateID = "$base_url/ViewState";
  static var viewAttendance = "$base_url/EmpTodayAttdance";
  static var viewMonthAttendance = "$base_url/EmpMonthsAttdance";
  static var viewAllAttendance = "$base_url/EmpAllDateAttdance";
  static var viewEnquiryList = "$base_url/ViewEMPEnquirylist";
  static var updatejobassign = "$base_url/UpdateJobAssign";
  static var leave_view = "$base_url/ViewAppEmpLeave";
  static var complaint_view = "$base_url/ViewComplaint";

// ClockINAttandance   post api clockin
// EmployeeId
// ClockINLatitude
// ClockINLongitude
// ClockINLocation
//
// EmpTodayAttdance(int EmployeeId) get api
//
// ClockOutAttandance   post
// EmployeeId
//  ClockOUTLatitude
// ClockOUTLongitude
// ClockOUTLocation
// {
// "EmployeeId": "1",
// "ClockINLatitude": "SSPL@sarv2",
// "ClockINLongitude": "SSPL@sarv2",
// "ClockINLocation": "SSPL@sarv2"
//
// }
}

class LoginRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> loginApi(
    var data,
  ) async {
    try {
      dynamic response = await _apiServices.postApi(data, AppUrl.login_url);
      // print(" login api response   ${response}");
      return response;
    } catch (e) {
      throw e;
    }
  }
}

class OrganizationDropdownValueRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<List<OrganizationData>> organizationrepodropdown(var cId) async {
    List<OrganizationData> dataList = <OrganizationData>[];
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.companyName_url}/$cId");
      print(" api of type  ${AppUrl.companyName_url}/$cId");
      print(
          " type api parsed data from model in get api   ${OrganizationData.fromJson(response)}");
      final data = response["data"];
      for (final ele in data) {
        dataList.add(OrganizationData.fromJson(ele));
      }
      return dataList;
    } catch (e) {
      print("this is error in type repo $e");
      throw e;
    }
  }
}

class AddVisitRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> addvisitApi(
    var data,
  ) async {
    try {
      dynamic response = await _apiServices.postApi(data, AppUrl.add_visit);
      print(" login api response   ${response}");
      return response;
    } catch (e) {
      throw e;
    }
  }
}

class ViewTodayVisitRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<TodayVisitModel> viewTodayVisitRepo(var cId) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.today_visit}/$cId");
      print(" api of view today visit ${AppUrl.today_visit}/$cId");
      print(
          " view today visit api parsed data from model in get api   ${TodayVisitModel.fromJson(response)}");
      return TodayVisitModel.fromJson(response);
    } catch (e) {
      print("this is error in view today visit repo $e");
      throw e;
    }
  }
}

class UpdateJobStatus {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<TodayVisitModel> updateJobStatusRepo(var data) async {
    try {
      dynamic response =
          await _apiServices.postApi(data, AppUrl.updatejobassign);
      print(" update job assign ${response}");
      return response;
    } catch (e) {
      throw e;
    }
  }
}

class ViewAllVisitRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<AllVisitModel> viewAllVisitRepo(var cId) async {
    try {
      dynamic response = await _apiServices.getApi("${AppUrl.all_visits}/$cId");
      print(" api of al today visit ${AppUrl.all_visits}/$cId");
      print(
          " all today visit api parsed data from model in get api   ${AllVisitModel.fromJson(response)}");
      return AllVisitModel.fromJson(response);
    } catch (e) {
      print("this is error in view all visit repo $e");
      throw e;
    }
  }
}

class DateAttendance {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<DateAttendanceModel> dateAttendanceRepo(var empId, var date) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.dateattendance}/$empId/$date");
      print(" api of al today visit ${AppUrl.dateattendance}/$empId/$date");
      print(
          " all today visit api parsed data from model in get api   ${DateAttendanceModel.fromJson(response)}");
      return DateAttendanceModel.fromJson(response);
    } catch (e) {
      print("this is error in view all visit repo $e");
      throw e;
    }
  }
}

class AddFollowupRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> addFollowupApi(
    var data,
  ) async {
    try {
      dynamic response =
          await _apiServices.postApi(data, AppUrl.add_followup_url);
      print(" add followup api response   ${response}");
      return response;
    } catch (e) {
      throw e;
    }
  }
}

class FollowupDetailsRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<FollowupDetailsModel> followupDetailRepo(var leadId) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.followup_detail_url}/$leadId");
      print(" api of view today visit ${AppUrl.followup_detail_url}/$leadId");
      print(
          " view today visit api parsed data from model in get api   ${FollowupDetailsModel.fromJson(response)}");
      return FollowupDetailsModel.fromJson(response);
    } catch (e) {
      print("this is error in view today visit repo $e");
      throw e;
    }
  }
}

class TodayFollowupRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<TodayFollowupModel> todayFollowupRepo(var cId) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.today_followup_url}/$cId");
      print(" api of view today followup ${AppUrl.today_followup_url}/$cId");
      print(
          "  Assigned job api parsed data from model in get api   ${TodayFollowupModel.fromJson(response)}");
      return TodayFollowupModel.fromJson(response);
    } catch (e) {
      print("this is error in view Assigned job repo $e");
      throw e;
    }
  }

  Future<Map<String, dynamic>> dateFollowupRepo(var cId) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.today_followup_url}/$cId");
      print(" api of view today followup ${AppUrl.today_followup_url}/$cId");
      print(
          " view today followup api parsed data from model in get api   ${TodayFollowupModel.fromJson(response)}");
      return response;
    } catch (e) {
      print("this is error in view today followup repo $e");
      throw e;
    }
  }
}

class ViewSchedularApi {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<SchedularViewModel> viewSchedularRepo(var empId) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.view_schedular_url}/$empId");
      print(" api of view Schedular ${AppUrl.view_schedular_url}/$empId");
      print(
          " view today followup api parsed data from model in get api   ${SchedularViewModel.fromJson(response)}");
      return SchedularViewModel.fromJson(response);
    } catch (e) {
      print("this is error in view today followup repo $e");
      throw e;
    }
  }

  Future<Map<String, dynamic>> datefilterSchedularRepo(var empId) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.view_schedular_url}/$empId");
      print(" api of view Schedular ${AppUrl.view_schedular_url}/$empId");
      print(
          " view today followup api parsed data from model in get api   ${SchedularViewModel.fromJson(response)}");
      return response;
    } catch (e) {
      print("this is error in view today followup repo $e");
      throw e;
    }
  }
}

class TodayCompleteFollowupRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<TodayCompleteFollowupModel> todayCompleteFollowupRepo(var cId) async {
    try {
      dynamic response = await _apiServices
          .getApi("${AppUrl.today_complete_followup_url}/$cId");
      print(
          " api of view today complete followup ${AppUrl.today_complete_followup_url}/$cId");
      print(
          " view today complete followup api parsed data from model in get api   ${TodayCompleteFollowupModel.fromJson(response)}");
      return TodayCompleteFollowupModel.fromJson(response);
    } catch (e) {
      print("this is error in view today complete followup repo $e");
      throw e;
    }
  }
}

class NextDayFollowupRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<NextDayFollowupModel> nextDayFollowupRepo(var cId) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.next_day_followuo_url}/$cId");
      print(
          " api of view next day followup ${AppUrl.next_day_followuo_url}/$cId");
      print(
          " view next day followup api parsed data from model in get api   ${NextDayFollowupModel.fromJson(response)}");
      return NextDayFollowupModel.fromJson(response);
    } catch (e) {
      print("this is error in view next day followup repo $e");
      throw e;
    }
  }
}

class NextWeekFollowupRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<NextWeekFollowupModel> nextWeekFollowupRepo(var cId) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.next_week_followup_url}/$cId");
      print(
          " api of view next week followup ${AppUrl.next_week_followup_url}/$cId");
      print(
          " view next week followup api parsed data from model in get api   ${NextWeekFollowupModel.fromJson(response)}");
      return NextWeekFollowupModel.fromJson(response);
    } catch (e) {
      print("this is error in view next week followup repo $e");
      throw e;
    }
  }
}

class AbsentRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> absentMarkRepo() async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.next_week_followup_url}");
      print(" api of view next week followup ${AppUrl.next_week_followup_url}");
      print(
          " view next week followup api parsed data from model in get api   ${NextWeekFollowupModel.fromJson(response)}");
      return NextWeekFollowupModel.fromJson(response);
    } catch (e) {
      print("this is error in view next week followup repo $e");
      throw e;
    }
  }
}

class PresentWFHRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> presentMarkWFHRepo() async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.next_week_followup_url}");
      print(" api of view next week followup ${AppUrl.next_week_followup_url}");
      print(
          " view next week followup api parsed data from model in get api   ${NextWeekFollowupModel.fromJson(response)}");
      return NextWeekFollowupModel.fromJson(response);
    } catch (e) {
      print("this is error in view next week followup repo $e");
      throw e;
    }
  }
}

class PresentONSRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> presentMarkONSRepo() async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.next_week_followup_url}");
      print(" api of view next week followup ${AppUrl.next_week_followup_url}");
      print(
          " view next week followup api parsed data from model in get api   ${NextWeekFollowupModel.fromJson(response)}");
      return NextWeekFollowupModel.fromJson(response);
    } catch (e) {
      print("this is error in view next week followup repo $e");
      throw e;
    }
  }
}

class ViewExpenseRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<ExpenseModel> viewExpenserepo(int userID) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.view_expense_url}$userID");
      print(" api of view expense ${AppUrl.view_expense_url}$userID");
      print(
          " view expense api parsed data from model in get api   ${ExpenseModel.fromJson(response)}");
      return ExpenseModel.fromJson(response);
    } catch (e) {
      print("this is error in view expense repo $e");
      throw e;
    }
  }

  Future<ViewExpenseModal> viewExpense(int empID) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.ExpenseView_Url}/$empID");
      print(" api of expense ${AppUrl.ExpenseView_Url}/$empID");
      print(
          " view expense api parsed data from model in get api   ${ViewExpenseModal.fromJson(response)}");
      return ViewExpenseModal.fromJson(response);
    } catch (e) {
      print("this is error in view expense repo $e");
      throw e;
    }
  }

  Future<TotalExpenseModel> viewExpenseTotal(int empID) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.ExpenseViewTotal_Url}/$empID");
      print(" api of expense ${AppUrl.ExpenseViewTotal_Url}/$empID");
      print(
          " view expense api parsed data from model in get api   ${TotalExpenseModel.fromJson(response)}");
      return TotalExpenseModel.fromJson(response);
    } catch (e) {
      print("this is error in view expense repo $e");
      throw e;
    }
  }

  Future<Map<String, dynamic>> dateExpense(int empID) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.ExpenseView_Url}/$empID");
      print(" api of expense ${AppUrl.ExpenseView_Url}/$empID");
      print(
          " view expense api parsed data from model in get api   ${ViewExpenseModal.fromJson(response)}");
      return response;
    } catch (e) {
      print("this is error in view expense repo $e");
      throw e;
    }
  }

  Future<List<ViewExpensesData>> expenseTypeRepo() async {
    List<ViewExpensesData> dataList = <ViewExpensesData>[];
    try {
      dynamic response = await _apiServices.getApi("${AppUrl.viewExpenses}");
      print(" api of teacher subject${AppUrl.stateID}");
      print(
          " teacher subject api parsed data from model in get api   ${ViewExpensesData.fromJson(response)}");
      final data = response["data"];
      for (final ele in data) {
        dataList.add(ViewExpensesData.fromJson(ele));
      }
      return dataList;
    } catch (e) {
      print("this is error in subject repo $e");
      throw e;
    }
  }

  Future<dynamic> addExpenserepo(var data) async {
    try {
      dynamic response =
          await _apiServices.postApi(data, AppUrl.add_expense_Url);
      print("add expense reponse ${response}");
      return response;
    } catch (e) {
      throw e;
    }
  }
}

class ViewDateWiseAttendance {
  BaseApiServices _apiServices = NetworkApiServices();

// Future<void>
  Future<Map<String, dynamic>> viewAllAttendanceRepo(var userId) async {
    try {
      // Fetch the response from the API
      dynamic response =
          await _apiServices.getApi("${AppUrl.viewAllAttendance}/$userId");

      print("API of view attendance: ${AppUrl.viewAllAttendance}/$userId");
      print("Response from API: $response");

      // Ensure response is a Map<String, dynamic>
      if (response is Map<String, dynamic>) {
        return response;
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      print("This is an error in view schedule repo: $e");
      throw e;
    }
  }
}

class ViewAttendance {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<TodayAttendaceModel> viewAttendanceRepo(var userId) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.viewAttendance}/$userId");
      print(" api of view attendance ${AppUrl.viewAttendance}/$userId");
      print(
          " view attendance api parsed data from model in get api   ${TodayAttendaceModel.fromJson(response)}");
      return TodayAttendaceModel.fromJson(response);
    } catch (e) {
      print("this is error in view schdeule repo $e");
      throw e;
    }
  }
}

class ViewMonthAttendance {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<TodayAttendaceModel> viewMonthAttendanceRepo(
      var userId, var month) async {
    try {
      dynamic response = await _apiServices
          .getApi("${AppUrl.viewMonthAttendance}/$userId/$month");
      print(
          " api of view attendance ${AppUrl.viewMonthAttendance}/$userId/$month");
      print(
          " view attendance api parsed data from model in get api   ${TodayAttendaceModel.fromJson(response)}");
      return TodayAttendaceModel.fromJson(response);
    } catch (e) {
      print("this is error in view schdeule repo $e");
      throw e;
    }
  }
}

class ViewEnquiry {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<ViewEnquiryModel> viewEnquiryListRepo(var empid) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.viewEnquiryList}/$empid");
      print(" api of view attendance ${AppUrl.viewEnquiryList}/$empid");
      print(
          " view attendance api parsed data from model in get api   ${ViewEnquiryModel.fromJson(response)}");
      return ViewEnquiryModel.fromJson(response);
    } catch (e) {
      print("this is error in view schdeule repo $e");
      throw e;
    }
  }

  Future<Map<String, dynamic>> datefilterEnquiry(var empid) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.viewEnquiryList}/$empid");
      print(" api of view attendance ${AppUrl.viewEnquiryList}/$empid");
      print(
          " view attendance api parsed data from model in get api   ${ViewEnquiryModel.fromJson(response)}");
      return response;
    } catch (e) {
      print("this is error in view schdeule repo $e");
      throw e;
    }
  }
}

class LeaveRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<LeaveViewModal> leaveapi(var empid) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.leave_view}/$empid");
      print(" api of view leave ${AppUrl.leave_view}/$empid");
      print(
          " view leave api parsed data from model in get api   ${LeaveViewModal.fromJson(response)}");
      return LeaveViewModal.fromJson(response);
    } catch (e) {
      print("this is error in view leave repo $e");
      throw e;
    }
  }

  Future<Map<String, dynamic>> dateFilterLeaveApi(var empid) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.leave_view}/$empid");
      print(" api of view leave ${AppUrl.leave_view}/$empid");
      print(
          " view leave api parsed data from model in get api   ${LeaveViewModal.fromJson(response)}");
      return response;
    } catch (e) {
      print("this is error in view leave repo $e");
      throw e;
    }
  }
}

class ViewComplaint {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<ComplaintViewModel> viewComplaintRepo(var empId) async {
    try {
      dynamic response =
          await _apiServices.getApi("${AppUrl.complaint_view}/$empId");
      print(" api of view attendance ${AppUrl.complaint_view}/$empId");
      print(
          " view attendance api parsed data from model in get api   ${ComplaintViewModel.fromJson(response)}");
      return ComplaintViewModel.fromJson(response);
    } catch (e) {
      print("this is error in view schdeule repo $e");
      throw e;
    }
  }
}
