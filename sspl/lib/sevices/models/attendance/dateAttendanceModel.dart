class DateAttendanceModel {
  String? message;
  List<Data>? data;
  int? statuscode;
  int? totalCount;

  DateAttendanceModel(
      {this.message, this.data, this.statuscode, this.totalCount});

  DateAttendanceModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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
}

class Data {
  int? employeeId;
  Null? firstName;
  Null? lastName;
  String? attandance;
  String? clockIN;
  String? clockINLatitude;
  String? clockINLongitude;
  String? clockINLocation;
  String? clockOUT;
  Null? clockOUTLatitude;
  Null? clockOUTLongitude;
  Null? clockOUTLocation;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  Data(
      {this.employeeId,
      this.firstName,
      this.lastName,
      this.attandance,
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

  Data.fromJson(Map<String, dynamic> json) {
    employeeId = json['EmployeeId'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    attandance = json['Attandance'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmployeeId'] = this.employeeId;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Attandance'] = this.attandance;
    data['ClockIN'] = this.clockIN;
    data['ClockINLatitude'] = this.clockINLatitude;
    data['ClockINLongitude'] = this.clockINLongitude;
    data['ClockINLocation'] = this.clockINLocation;
    data['ClockOUT'] = this.clockOUT;
    data['ClockOUTLatitude'] = this.clockOUTLatitude;
    data['ClockOUTLongitude'] = this.clockOUTLongitude;
    data['ClockOUTLocation'] = this.clockOUTLocation;
    data['IsActive'] = this.isActive;
    data['CreatedDate'] = this.createdDate;
    data['Date'] = this.date;
    data['ModifiedDate'] = this.modifiedDate;
    data['Createdby'] = this.createdby;
    data['Updatedby'] = this.updatedby;
    return data;
  }
}
