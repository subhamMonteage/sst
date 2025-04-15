class TodayAttendaceModel {
  String? message;
  List<TodayAttendaceModelData>? data;
  int? statuscode;
  int? totalCount;

  TodayAttendaceModel(
      {this.message, this.data, this.statuscode, this.totalCount});

  TodayAttendaceModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <TodayAttendaceModelData>[];
      json['data'].forEach((v) {
        data!.add(TodayAttendaceModelData.fromJson(v));
      });
    }
    statuscode = json['statuscode'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['statuscode'] = statuscode;
    data['totalCount'] = totalCount;
    return data;
  }

  TodayAttendaceModel filterDataBetweenDates(String startDate, String endDate) {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);

    List<TodayAttendaceModelData> filteredData = data!.where((item) {
      DateTime clockInDate = DateTime.parse(item.clockIN!);
      return clockInDate.isAfter(start) && clockInDate.isBefore(end);
    }).toList();

    return TodayAttendaceModel(
      message: message,
      data: filteredData,
      statuscode: statuscode,
      totalCount: filteredData.length,
    );
  }
}

class TodayAttendaceModelData {
  int? employeeId;
  String? firstName;
  String? lastName;
  String? attendance;
  String? clockIN;
  String? clockINLatitude;
  String? clockINLongitude;
  String? clockINLocation;
  String? clockOUT;
  String? clockOUTLatitude;
  String? clockOUTLongitude;
  String? clockOUTLocation;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  TodayAttendaceModelData(
      {this.employeeId,
      this.firstName,
      this.lastName,
      this.attendance,
      this.clockIN,
      this.clockINLatitude,
      this.clockINLongitude,
      this.clockINLocation,
      this.clockOUT,
      this.clockOUTLatitude,
      this.clockOUTLongitude,
      this.clockOUTLocation,
      this.isActive,
      this.createdDate,
      this.date,
      this.modifiedDate,
      this.createdby,
      this.updatedby});

  TodayAttendaceModelData.fromJson(Map<String, dynamic> json) {
    employeeId = json['EmployeeId'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    attendance = json['Attendance'];
    clockIN = json['ClockIN'];
    clockINLatitude = json['ClockINLatitude'];
    clockINLongitude = json['ClockINLongitude'];
    clockINLocation = json['ClockINLocation'];
    clockOUT = json['ClockOUT'];
    clockOUTLatitude = json['ClockOUTLatitude'];
    clockOUTLongitude = json['ClockOUTLongitude'];
    clockOUTLocation = json['ClockOUTLocation'];
    isActive = json['IsActive'];
    createdDate = json['CreatedDate'];
    date = json['Date'];
    modifiedDate = json['ModifiedDate'];
    createdby = json['Createdby'];
    updatedby = json['Updatedby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['EmployeeId'] = employeeId;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['Attendance'] = attendance;
    data['ClockIN'] = clockIN;
    data['ClockINLatitude'] = clockINLatitude;
    data['ClockINLongitude'] = clockINLongitude;
    data['ClockINLocation'] = clockINLocation;
    data['ClockOUT'] = clockOUT;
    data['ClockOUTLatitude'] = clockOUTLatitude;
    data['ClockOUTLongitude'] = clockOUTLongitude;
    data['ClockOUTLocation'] = clockOUTLocation;
    data['IsActive'] = isActive;
    data['CreatedDate'] = createdDate;
    data['Date'] = date;
    data['ModifiedDate'] = modifiedDate;
    data['Createdby'] = createdby;
    data['Updatedby'] = updatedby;
    return data;
  }
}
