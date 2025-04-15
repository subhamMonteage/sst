class LeaveViewModal {
  String? message;
  List<LeaveViewData>? data;
  int? statuscode;
  int? totalCount;

  LeaveViewModal({this.message, this.data, this.statuscode, this.totalCount});

  LeaveViewModal.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <LeaveViewData>[];
      json['data'].forEach((v) {
        data!.add(new LeaveViewData.fromJson(v));
      });
    }
    statuscode = json['statuscode'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['statuscode'] = this.statuscode;
    data['totalCount'] = this.totalCount;
    return data;
  }

  LeaveViewModal filterDataBetweenDates(String startDate, String endDate) {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);

    List<LeaveViewData> filteredData = data!.where((item) {
      DateTime clockInDate = DateTime.parse(item.leaveFromDate!);
      return clockInDate.isAfter(start) && clockInDate.isBefore(end);
    }).toList();

    return LeaveViewModal(
      message: this.message,
      data: filteredData,
      statuscode: this.statuscode,
      totalCount: filteredData.length,
    );
  }
}

class LeaveViewData {
  String? leaveFromDate;
  String? leaveToDate;
  String? leaveApplyfor;
  String? leaveType;
  String? alternateContactNo;
  String? resumedutyDate;
  int? employeeId;
  String? leaveStatus;
  String? namee;
  String? createBy;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  LeaveViewData(
      {this.leaveFromDate,
      this.leaveToDate,
      this.leaveApplyfor,
      this.leaveType,
      this.alternateContactNo,
      this.resumedutyDate,
      this.employeeId,
      this.leaveStatus,
      this.namee,
      this.createBy,
      this.isActive,
      this.createdDate,
      this.date,
      this.modifiedDate,
      this.createdby,
      this.updatedby});

  LeaveViewData.fromJson(Map<String, dynamic> json) {
    leaveFromDate = json['LeaveFromDate'];
    leaveToDate = json['LeaveToDate'];
    leaveApplyfor = json['LeaveApplyfor'];
    leaveType = json['LeaveType'];
    alternateContactNo = json['AlternateContactNo'];
    resumedutyDate = json['ResumedutyDate'];
    employeeId = json['EmployeeId'];
    leaveStatus = json['LeaveStatus'];
    namee = json['Namee'];
    createBy = json['CreateBy'];
    isActive = json['IsActive'];
    createdDate = json['CreatedDate'];
    date = json['Date'];
    modifiedDate = json['ModifiedDate'];
    createdby = json['Createdby'];
    updatedby = json['Updatedby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LeaveFromDate'] = this.leaveFromDate;
    data['LeaveToDate'] = this.leaveToDate;
    data['LeaveApplyfor'] = this.leaveApplyfor;
    data['LeaveType'] = this.leaveType;
    data['AlternateContactNo'] = this.alternateContactNo;
    data['ResumedutyDate'] = this.resumedutyDate;
    data['EmployeeId'] = this.employeeId;
    data['LeaveStatus'] = this.leaveStatus;
    data['Namee'] = this.namee;
    data['CreateBy'] = this.createBy;
    data['IsActive'] = this.isActive;
    data['CreatedDate'] = this.createdDate;
    data['Date'] = this.date;
    data['ModifiedDate'] = this.modifiedDate;
    data['Createdby'] = this.createdby;
    data['Updatedby'] = this.updatedby;
    return data;
  }
}
