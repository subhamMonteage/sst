class NextWeekFollowupModel {
  String? message;
  List<Data>? data;
  int? statuscode;
  int? totalCount;

  NextWeekFollowupModel(
      {this.message, this.data, this.statuscode, this.totalCount});

  NextWeekFollowupModel.fromJson(Map<String, dynamic> json) {
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
  int? leadsId;
  int? courseId;
  String? courseName;
  String? organizationname;
  String? lEmail;
  String? lMobile;
  String? contactname;
  String? orgAddress;
  var leadlatitude;
  var leadlongitude;
  var curruntAddrs;
  String? lLeadsfrom;
  String? lFollowupdate;
  var lRemarks;
  String? lAction;
  var lSubstatus;
  String? updatedate;
  String? createdate;
  var createBy;
  var firstName;
  var lastName;
  var cRemarks;
  String? cUpdateDate;
  var alternateEmail;
  var alternateMobile;
  var stateName;
  var cityName;
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
      this.organizationname,
      this.lEmail,
      this.lMobile,
      this.contactname,
      this.orgAddress,
      this.leadlatitude,
      this.leadlongitude,
      this.curruntAddrs,
      this.lLeadsfrom,
      this.lFollowupdate,
      this.lRemarks,
      this.lAction,
      this.lSubstatus,
      this.updatedate,
      this.createdate,
      this.createBy,
      this.firstName,
      this.lastName,
      this.cRemarks,
      this.cUpdateDate,
      this.alternateEmail,
      this.alternateMobile,
      this.stateName,
      this.cityName,
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
    organizationname = json['Organizationname'];
    lEmail = json['LEmail'];
    lMobile = json['LMobile'];
    contactname = json['Contactname'];
    orgAddress = json['OrgAddress'];
    leadlatitude = json['Leadlatitude'];
    leadlongitude = json['Leadlongitude'];
    curruntAddrs = json['CurruntAddrs'];
    lLeadsfrom = json['LLeadsfrom'];
    lFollowupdate = json['LFollowupdate'];
    lRemarks = json['LRemarks'];
    lAction = json['LAction'];
    lSubstatus = json['LSubstatus'];
    updatedate = json['Updatedate'];
    createdate = json['Createdate'];
    createBy = json['CreateBy'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    cRemarks = json['CRemarks'];
    cUpdateDate = json['CUpdateDate'];
    alternateEmail = json['AlternateEmail'];
    alternateMobile = json['AlternateMobile'];
    stateName = json['StateName'];
    cityName = json['CityName'];
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
    data['Organizationname'] = this.organizationname;
    data['LEmail'] = this.lEmail;
    data['LMobile'] = this.lMobile;
    data['Contactname'] = this.contactname;
    data['OrgAddress'] = this.orgAddress;
    data['Leadlatitude'] = this.leadlatitude;
    data['Leadlongitude'] = this.leadlongitude;
    data['CurruntAddrs'] = this.curruntAddrs;
    data['LLeadsfrom'] = this.lLeadsfrom;
    data['LFollowupdate'] = this.lFollowupdate;
    data['LRemarks'] = this.lRemarks;
    data['LAction'] = this.lAction;
    data['LSubstatus'] = this.lSubstatus;
    data['Updatedate'] = this.updatedate;
    data['Createdate'] = this.createdate;
    data['CreateBy'] = this.createBy;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['CRemarks'] = this.cRemarks;
    data['CUpdateDate'] = this.cUpdateDate;
    data['AlternateEmail'] = this.alternateEmail;
    data['AlternateMobile'] = this.alternateMobile;
    data['StateName'] = this.stateName;
    data['CityName'] = this.cityName;
    data['IsActive'] = this.isActive;
    data['CreatedDate'] = this.createdDate;
    data['Date'] = this.date;
    data['ModifiedDate'] = this.modifiedDate;
    data['Createdby'] = this.createdby;
    data['Updatedby'] = this.updatedby;
    return data;
  }
}
