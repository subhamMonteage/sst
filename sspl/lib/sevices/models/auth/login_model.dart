class LoginModel {
  String? message;
  Data? data;
  int? statuscode;
  int? totalCount;

  LoginModel({this.message, this.data, this.statuscode, this.totalCount});

  LoginModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    statuscode = json['statuscode'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['statuscode'] = this.statuscode;
    data['totalCount'] = this.totalCount;
    return data;
  }
}

class Data {
  int? employeeId;
  int? uRId;
  String? userRole;
  int? bUId;
  String? bUName;
  String? employeeCode;
  String? firstName;
  String? lastName;
  String? emailID;
  String? password;
  String? mobileNo;
  String? alternateMobile;
  String? gender;
  String? address;
  String? action;
  String? createBy;
  String? updateBy;
  String? createDate;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  Data(
      {this.employeeId,
      this.uRId,
      this.userRole,
      this.bUId,
      this.bUName,
      this.employeeCode,
      this.firstName,
      this.lastName,
      this.emailID,
      this.password,
      this.mobileNo,
      this.alternateMobile,
      this.gender,
      this.address,
      this.action,
      this.createBy,
      this.updateBy,
      this.createDate,
      this.isActive,
      this.createdDate,
      this.date,
      this.modifiedDate,
      this.createdby,
      this.updatedby});

  Data.fromJson(Map<String, dynamic> json) {
    employeeId = json['EmployeeId'];
    uRId = json['URId'];
    userRole = json['UserRole'];
    bUId = json['BUId'];
    bUName = json['BUName'];
    employeeCode = json['EmployeeCode'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    emailID = json['EmailID'];
    password = json['Password'];
    mobileNo = json['MobileNo'];
    alternateMobile = json['AlternateMobile'];
    gender = json['Gender'];
    address = json['Address'];
    action = json['Action'];
    createBy = json['CreateBy'];
    updateBy = json['UpdateBy'];
    createDate = json['CreateDate'];
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
    data['URId'] = this.uRId;
    data['UserRole'] = this.userRole;
    data['BUId'] = this.bUId;
    data['BUName'] = this.bUName;
    data['EmployeeCode'] = this.employeeCode;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['EmailID'] = this.emailID;
    data['Password'] = this.password;
    data['MobileNo'] = this.mobileNo;
    data['AlternateMobile'] = this.alternateMobile;
    data['Gender'] = this.gender;
    data['Address'] = this.address;
    data['Action'] = this.action;
    data['CreateBy'] = this.createBy;
    data['UpdateBy'] = this.updateBy;
    data['CreateDate'] = this.createDate;
    data['IsActive'] = this.isActive;
    data['CreatedDate'] = this.createdDate;
    data['Date'] = this.date;
    data['ModifiedDate'] = this.modifiedDate;
    data['Createdby'] = this.createdby;
    data['Updatedby'] = this.updatedby;
    return data;
  }
}
