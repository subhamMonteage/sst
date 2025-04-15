class Employename {
  String? message;
  List<Datum>? data;
  int? statuscode;
  int? totalCount;

  Employename({this.message, this.data, this.statuscode, this.totalCount});

  Employename.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Datum>[];
      json['data'].forEach((v) {
        data!.add(new Datum.fromJson(v));
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

class Datum {
  int? jobAssignId;
  int? employeeId;
  String? firstName;
  String? lastName;
  String? jobDetails;
  Null? jobImage;
  Null? jobRemarks;
  String? jobStatus;
  String? createBy;
  String? createDate;
  String? completedate;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  Datum(
      {this.jobAssignId,
      this.employeeId,
      this.firstName,
      this.lastName,
      this.jobDetails,
      this.jobImage,
      this.jobRemarks,
      this.jobStatus,
      this.createBy,
      this.createDate,
      this.completedate,
      this.isActive,
      this.createdDate,
      this.date,
      this.modifiedDate,
      this.createdby,
      this.updatedby});

  Datum.fromJson(Map<String, dynamic> json) {
    jobAssignId = json['JobAssignId'];
    employeeId = json['EmployeeId'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    jobDetails = json['JobDetails'];
    jobImage = json['JobImage'];
    jobRemarks = json['JobRemarks'];
    jobStatus = json['JobStatus'];
    createBy = json['CreateBy'];
    createDate = json['CreateDate'];
    completedate = json['Completedate'];
    isActive = json['IsActive'];
    createdDate = json['CreatedDate'];
    date = json['Date'];
    modifiedDate = json['ModifiedDate'];
    createdby = json['Createdby'];
    updatedby = json['Updatedby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JobAssignId'] = this.jobAssignId;
    data['EmployeeId'] = this.employeeId;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['JobDetails'] = this.jobDetails;
    data['JobImage'] = this.jobImage;
    data['JobRemarks'] = this.jobRemarks;
    data['JobStatus'] = this.jobStatus;
    data['CreateBy'] = this.createBy;
    data['CreateDate'] = this.createDate;
    data['Completedate'] = this.completedate;
    data['IsActive'] = this.isActive;
    data['CreatedDate'] = this.createdDate;
    data['Date'] = this.date;
    data['ModifiedDate'] = this.modifiedDate;
    data['Createdby'] = this.createdby;
    data['Updatedby'] = this.updatedby;
    return data;
  }
}
