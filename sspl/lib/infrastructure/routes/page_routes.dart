import 'package:sspl/bindings/Enquiry/view_all_enquiry_binding.dart';
import 'package:sspl/bindings/Schedular/schedular_binding.dart';
import 'package:sspl/bindings/auth/login_screen_binding.dart';
import 'package:sspl/bindings/complaint/complaint_binding.dart';
import 'package:sspl/bindings/dashboard/dhashboard_binding.dart';
import 'package:sspl/bindings/expense/view_all_expense_binding.dart';
import 'package:sspl/bindings/followup_screen_binding/all_followup_screen_binding.dart';
import 'package:sspl/bindings/followup_screen_binding/all_followups_of_client_binding.dart';
import 'package:sspl/bindings/followup_screen_binding/followup_details_screen_binding.dart';
import 'package:sspl/bindings/followup_screen_binding/next_day-followup_screen_binding.dart';
import 'package:sspl/bindings/followup_screen_binding/next_week_followup_screen_binding.dart';
import 'package:sspl/bindings/followup_screen_binding/today_complete_followup_binidng.dart';
import 'package:sspl/bindings/intro/splash_screen_binding.dart';
import 'package:sspl/bindings/visit_binding/all_visits_screen_binding.dart';
import 'package:sspl/bindings/visit_binding/today_visit_screen_binding.dart';
import 'package:sspl/infrastructure/routes/page_constants.dart';
import 'package:sspl/view/Enquiry/EnquiryScreen.dart';
import 'package:sspl/view/Enquiry/Update_Enquiry_screen.dart';
import 'package:sspl/view/Enquiry/view_all_enquiry.dart';
import 'package:sspl/view/Enquiry/view_enquiry_screen.dart';
import 'package:sspl/view/Leave/leave_view_screen.dart';
import 'package:sspl/view/attendance/monthly_attendance_screen.dart';
import 'package:sspl/view/auth/login_screen.dart';
import 'package:sspl/view/complaint/complaint_add.dart';
import 'package:sspl/view/complaint/complaint_view.dart';
import 'package:sspl/view/dashboard/check_in_screen.dart';
import 'package:sspl/view/dashboard/dashboard.dart';
import 'package:sspl/view/Enquiry/Enquiry_visit_screen.dart';
import 'package:sspl/view/dashboard/Schedularscreen.dart';
import 'package:sspl/view/dashboard/view_schedular.dart';
import 'package:sspl/view/expense/view_all_expense.dart';
import 'package:sspl/view/followup_screen/all_followup_screen.dart';
import 'package:sspl/view/followup_screen/all_followups_of_client_screen.dart';
import 'package:sspl/view/followup_screen/followup_details_screen.dart';
import 'package:sspl/view/job_assignedBy/next_day_followup_screen.dart';
import 'package:sspl/view/followup_screen/today_complete_followup_screen.dart';
import 'package:sspl/view/intro/splash_screen.dart';
import 'package:sspl/view/job_assignedBy/job_assignedby.dart';
import 'package:sspl/view/expense/add_visit_screen.dart';
import 'package:sspl/view/visit_screen/all_visits_screen.dart';
import 'package:sspl/view/visit_screen/today_visits.dart';
import 'package:get/get.dart';
import '../../bindings/Enquiry/updateenquirybinding.dart';
import '../../bindings/attendance/attendance_binding.dart';
import '../../bindings/dashboard/clientsite_visit_screen_binding.dart';
import '../../bindings/expense/all_expenses_screen_binding.dart';
import '../../bindings/expense/expense_screen_binding.dart';
import '../../bindings/expense/new_expense_binding.dart';
import '../../view/Leave/leave_view_all.dart';
import '../../view/attendance/attendance_screen.dart';
import '../../view/expense/clientsite_visit_screen.dart';
import '../../view/expense/all_expenses_screen.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
          name: AppRoutesName.splash_screen,
          page: () => SplashScreen(),
          binding: SplashScreenBinding(),
          transition: Transition.fade,
        ),
        GetPage(
          name: AppRoutesName.login_screen,
          page: () => LoginScreen(),
          binding: LoginScreenBinding(),
          transition: Transition.fade,
        ),
        GetPage(
          name: AppRoutesName.dashboard_screen,
          page: () => DashboardScreen(),
          binding: DashboardBinding(),
          transition: Transition.fade,
        ),
        GetPage(
          name: AppRoutesName.assigned_job_screen,
          page: () => const Job_AssignedBy(),
          binding: DashboardBinding(),
          transition: Transition.fade,
        ),
        /*GetPage(
          name: AppRoutesName.addvisit_screen,
          page: () => AddNewScreen(),
          binding: AddVisitScreenBinding(),
          transition: Transition.fade,
        ),*/
        GetPage(
          name: AppRoutesName.all_followup_screen,
          page: () => AllFollowUpScreen(),
          binding: AllFollowUpScreenBinding(),
          transition: Transition.fade,
        ),
        // GetPage(
        //   name: AppRoutesName.today_followup_screen,
        //   page: () => TodayFollowUpScreen(),
        //   binding: TodayFollowUpScreenBinding(),
        //   transition: Transition.fade,
        // ),
        GetPage(
          name: AppRoutesName.all_visit_screen,
          page: () => AllVisitScreen(),
          binding: AllVisitScreenBinding(),
          transition: Transition.fade,
        ),
        GetPage(
          name: AppRoutesName.today_visit_screen,
          page: () => TodayVisitScreen(),
          binding: TodayVisitScreenBinding(),
          transition: Transition.fade,
        ),
        GetPage(
          name: AppRoutesName.all_followups_of_client_screen,
          page: () => AllFollowupofClientScreen(),
          binding: AllFollowupsofClientBinding(),
          transition: Transition.fade,
        ),
        GetPage(
          name: AppRoutesName.followup_Screen_Details,
          page: () => FollowupDetailsScreen(),
          binding: FollowupDetailsScreenBinding(),
          transition: Transition.fade,
        ),
        GetPage(
          name: AppRoutesName.today_complete_followup_screen,
          page: () => TodayCompleteFollowupScreen(),
          binding: TodayCompleteFollowupScreenBinding(),
          transition: Transition.fade,
        ),
        GetPage(
          name: AppRoutesName.next_day_followuo_screen,
          page: () => NextDayFollowupScreen(),
          binding: NextDayFollowupSreenBinding(),
          transition: Transition.fade,
        ),
        GetPage(
          name: AppRoutesName.Scheduler_screen,
          page: () => Schedulerscreen(),
          binding: NextDayFollowupSreenBinding(),
          transition: Transition.fade,
        ),
        GetPage(
          name: AppRoutesName.schedular_view_,
          page: () => ViewSchedular(),
          binding: SchedularBinding(),
          transition: Transition.fade,
        ),
        GetPage(
          name: AppRoutesName.Enquiry_visit,
          page: () => EnquiryVisitScreen(),
          binding: ClientsiteVisitScreenBinding(),
          transition: Transition.fade,
        ),
        GetPage(
          name: AppRoutesName.UpdateEnquiry_visit,
          page: () => updateEnquiryScreen(),
          binding: UpdateEnquiryBinding(),
          transition: Transition.fade,
        ),
        GetPage(
          name: AppRoutesName.Enquiry_day,
          page: () => EnquiryScreen(),
          binding: NextWeekFollowupScreenBinding(),
          transition: Transition.fade,
        ),
        GetPage(
          name: AppRoutesName.View_Enquiry_Screen,
          page: () => ViewEnquiryScreen(),
          binding: NextWeekFollowupScreenBinding(),
          transition: Transition.fade,
        ),
        GetPage(
          name: AppRoutesName.all_expenses_screen,
          page: () => AllExpensesScreen(),
          transition: Transition.rightToLeft,
          binding: AllExpenseScreenBinding(),
        ),
        /*GetPage(
          name: AppRoutesName.Leave_screen,
          page: () => LeaveScreen(),
          transition: Transition.rightToLeft,
          binding: ExpenseScreenBinding(),
        ),*/
        GetPage(
          name: AppRoutesName.Leave_view_screen,
          page: () => LeaveViewScreen(),
          transition: Transition.rightToLeft,
          binding: ExpenseScreenBinding(),
        ),
        GetPage(
          name: AppRoutesName.check_in_screen,
          page: () => CheckInScreen(),
          transition: Transition.rightToLeft,
          binding: DashboardBinding(),
        ),
        GetPage(
          name: AppRoutesName.attendance_screen,
          page: () => AttendanceScreen(),
          transition: Transition.rightToLeft,
          binding: AttendanceScreenBinding(),
        ),
        GetPage(
          name: AppRoutesName.monthly_attendance_screen,
          page: () => MonthlyAttendanceScreen(),
          transition: Transition.rightToLeft,
          binding: AttendanceScreenBinding(),
        ),
        GetPage(
          name: AppRoutesName.clientvisit_screen,
          page: () => ClientSiteVisitScreen(),
          transition: Transition.rightToLeft,
          binding: ClientsiteVisitScreenBinding(),
        ),
        GetPage(
          name: AppRoutesName.leave_view_all,
          page: () => AllLeaveView(),
          transition: Transition.rightToLeft,
          binding: ExpenseScreenBinding(),
        ),
        GetPage(
          name: AppRoutesName.enquiry_view_all,
          page: () => ViewAllEnquiry(),
          transition: Transition.rightToLeft,
          binding: ViewAllEnquiryBinding(),
        ),
        GetPage(
          name: AppRoutesName.view_all_expense,
          page: () => ViewAllExpense(),
          transition: Transition.rightToLeft,
          binding: ViewAllExpenseBinding(),
        ),
        GetPage(
          name: AppRoutesName.update_expense,
          page: () => AddNewScreen(),
          transition: Transition.rightToLeft,
          binding: ViewExpenseScreenBinding(),
        ),
        GetPage(
          name: AppRoutesName.complaint_view,
          page: () => ComplaintView(),
          transition: Transition.rightToLeft,
          binding: ComplaintBinding(),
        ),
        GetPage(
          name: AppRoutesName.complaint_add,
          page: () => AddComplaint(),
          transition: Transition.rightToLeft,
          binding: ComplaintBinding(),
        ),
      ];
}
