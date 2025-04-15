class AddFollowupModel {
  String? message;
  Data? data;
  int? statuscode;
  int? totalCount;

  AddFollowupModel({this.message, this.data, this.statuscode, this.totalCount});

  AddFollowupModel.fromJson(Map<String, dynamic> json) {
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
  int? leadsId;
  int? courseId;
  var courseName;
  var lFirstname;
  var lLastname;
  var lEmail;
  var lMobile;
  var lQueryy;
  var lLeadsfrom;
  String? lFollowupdate;
  var lRemarks;
  var lAction;
  var lSubstatus;
  var updateby;
  String? updatedate;
  String? createdate;
  var createBy;
  int? assigned;
  var firstName;
  var lastName;
  var email;
  var cRemarks;
  String? cUpdateDate;
  var alternateEmail;
  var alternateMobile;
  var courseType;
  int? deId;
  var createByname;
  var assignByname;
  var departmentName;
  var streamName;
  var lLeadsFroms;
  int? cId;
  String? updatedateeee;
  String? lFollowupdateeee;
  var stateName;
  var cityName;
  String? cFollowupdate;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  Data(
      {this.leadsId,
      this.courseId,
      this.courseName,
      this.lFirstname,
      this.lLastname,
      this.lEmail,
      this.lMobile,
      this.lQueryy,
      this.lLeadsfrom,
      this.lFollowupdate,
      this.lRemarks,
      this.lAction,
      this.lSubstatus,
      this.updateby,
      this.updatedate,
      this.createdate,
      this.createBy,
      this.assigned,
      this.firstName,
      this.lastName,
      this.email,
      this.cRemarks,
      this.cUpdateDate,
      this.alternateEmail,
      this.alternateMobile,
      this.courseType,
      this.deId,
      this.createByname,
      this.assignByname,
      this.departmentName,
      this.streamName,
      this.lLeadsFroms,
      this.cId,
      this.updatedateeee,
      this.lFollowupdateeee,
      this.stateName,
      this.cityName,
      this.cFollowupdate,
      this.isActive,
      this.createdDate,
      this.date,
      this.modifiedDate,
      this.createdby,
      this.updatedby});

  Data.fromJson(Map<String, dynamic> json) {
    leadsId = json['LeadsId'];
    courseId = json['CourseId'];
    courseName = json['CourseName'];
    lFirstname = json['LFirstname'];
    lLastname = json['LLastname'];
    lEmail = json['LEmail'];
    lMobile = json['LMobile'];
    lQueryy = json['LQueryy'];
    lLeadsfrom = json['LLeadsfrom'];
    lFollowupdate = json['LFollowupdate'];
    lRemarks = json['LRemarks'];
    lAction = json['LAction'];
    lSubstatus = json['LSubstatus'];
    updateby = json['Updateby'];
    updatedate = json['Updatedate'];
    createdate = json['Createdate'];
    createBy = json['CreateBy'];
    assigned = json['Assigned'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    email = json['Email'];
    cRemarks = json['CRemarks'];
    cUpdateDate = json['CUpdateDate'];
    alternateEmail = json['AlternateEmail'];
    alternateMobile = json['AlternateMobile'];
    courseType = json['CourseType'];
    deId = json['DeId'];
    createByname = json['CreateByname'];
    assignByname = json['AssignByname'];
    departmentName = json['DepartmentName'];
    streamName = json['StreamName'];
    lLeadsFroms = json['LLeadsFroms'];
    cId = json['CId'];
    updatedateeee = json['Updatedateeee'];
    lFollowupdateeee = json['LFollowupdateeee'];
    stateName = json['StateName'];
    cityName = json['CityName'];
    cFollowupdate = json['CFollowupdate'];
    isActive = json['IsActive'];
    createdDate = json['CreatedDate'];
    date = json['Date'];
    modifiedDate = json['ModifiedDate'];
    createdby = json['Createdby'];
    updatedby = json['Updatedby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LeadsId'] = this.leadsId;
    data['CourseId'] = this.courseId;
    data['CourseName'] = this.courseName;
    data['LFirstname'] = this.lFirstname;
    data['LLastname'] = this.lLastname;
    data['LEmail'] = this.lEmail;
    data['LMobile'] = this.lMobile;
    data['LQueryy'] = this.lQueryy;
    data['LLeadsfrom'] = this.lLeadsfrom;
    data['LFollowupdate'] = this.lFollowupdate;
    data['LRemarks'] = this.lRemarks;
    data['LAction'] = this.lAction;
    data['LSubstatus'] = this.lSubstatus;
    data['Updateby'] = this.updateby;
    data['Updatedate'] = this.updatedate;
    data['Createdate'] = this.createdate;
    data['CreateBy'] = this.createBy;
    data['Assigned'] = this.assigned;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Email'] = this.email;
    data['CRemarks'] = this.cRemarks;
    data['CUpdateDate'] = this.cUpdateDate;
    data['AlternateEmail'] = this.alternateEmail;
    data['AlternateMobile'] = this.alternateMobile;
    data['CourseType'] = this.courseType;
    data['DeId'] = this.deId;
    data['CreateByname'] = this.createByname;
    data['AssignByname'] = this.assignByname;
    data['DepartmentName'] = this.departmentName;
    data['StreamName'] = this.streamName;
    data['LLeadsFroms'] = this.lLeadsFroms;
    data['CId'] = this.cId;
    data['Updatedateeee'] = this.updatedateeee;
    data['LFollowupdateeee'] = this.lFollowupdateeee;
    data['StateName'] = this.stateName;
    data['CityName'] = this.cityName;
    data['CFollowupdate'] = this.cFollowupdate;
    data['IsActive'] = this.isActive;
    data['CreatedDate'] = this.createdDate;
    data['Date'] = this.date;
    data['ModifiedDate'] = this.modifiedDate;
    data['Createdby'] = this.createdby;
    data['Updatedby'] = this.updatedby;
    return data;
  }
}
