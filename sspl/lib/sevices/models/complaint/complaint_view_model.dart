class ComplaintViewModel {
  String? message;
  List<Data>? data;
  int? statuscode;
  int? totalCount;

  ComplaintViewModel(
      {this.message, this.data, this.statuscode, this.totalCount});

  ComplaintViewModel.fromJson(Map<String, dynamic> json) {
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
  int? complaintId;
  String? customerName;
  String? contactPerson;
  String? contactNo;
  String? complaintN;
  String? remakrs;
  String? action;
  String? createBy;
  String? updateBy;
  String? createDate;
  int? acceptId;
  String? acceptName;
  String? acceptRemarks;
  String? acceptStatus;
  String? acceptDate;
  int? cAcceptId;
  String? cName;
  String? cAcceptRemarks;
  String? cAcceptStatus;
  String? cDate;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  Data(
      {this.complaintId,
      this.customerName,
      this.contactPerson,
      this.contactNo,
      this.complaintN,
      this.remakrs,
      this.action,
      this.createBy,
      this.updateBy,
      this.createDate,
      this.acceptId,
      this.acceptName,
      this.acceptRemarks,
      this.acceptStatus,
      this.acceptDate,
      this.cAcceptId,
      this.cName,
      this.cAcceptRemarks,
      this.cAcceptStatus,
      this.cDate,
      this.isActive,
      this.createdDate,
      this.date,
      this.modifiedDate,
      this.createdby,
      this.updatedby});

  Data.fromJson(Map<String, dynamic> json) {
    complaintId = json['ComplaintId'];
    customerName = json['CustomerName'];
    contactPerson = json['ContactPerson'];
    contactNo = json['ContactNo'];
    complaintN = json['ComplaintN'];
    remakrs = json['Remakrs'];
    action = json['Action'];
    createBy = json['CreateBy'];
    updateBy = json['UpdateBy'];
    createDate = json['CreateDate'];
    acceptId = json['AcceptId'];
    acceptName = json['AcceptName'];
    acceptRemarks = json['AcceptRemarks'];
    acceptStatus = json['AcceptStatus'];
    acceptDate = json['AcceptDate'];
    cAcceptId = json['CAcceptId'];
    cName = json['CName'];
    cAcceptRemarks = json['CAcceptRemarks'];
    cAcceptStatus = json['CAcceptStatus'];
    cDate = json['CDate'];
    isActive = json['IsActive'];
    createdDate = json['CreatedDate'];
    date = json['Date'];
    modifiedDate = json['ModifiedDate'];
    createdby = json['Createdby'];
    updatedby = json['Updatedby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ComplaintId'] = this.complaintId;
    data['CustomerName'] = this.customerName;
    data['ContactPerson'] = this.contactPerson;
    data['ContactNo'] = this.contactNo;
    data['ComplaintN'] = this.complaintN;
    data['Remakrs'] = this.remakrs;
    data['Action'] = this.action;
    data['CreateBy'] = this.createBy;
    data['UpdateBy'] = this.updateBy;
    data['CreateDate'] = this.createDate;
    data['AcceptId'] = this.acceptId;
    data['AcceptName'] = this.acceptName;
    data['AcceptRemarks'] = this.acceptRemarks;
    data['AcceptStatus'] = this.acceptStatus;
    data['AcceptDate'] = this.acceptDate;
    data['CAcceptId'] = this.cAcceptId;
    data['CName'] = this.cName;
    data['CAcceptRemarks'] = this.cAcceptRemarks;
    data['CAcceptStatus'] = this.cAcceptStatus;
    data['CDate'] = this.cDate;
    data['IsActive'] = this.isActive;
    data['CreatedDate'] = this.createdDate;
    data['Date'] = this.date;
    data['ModifiedDate'] = this.modifiedDate;
    data['Createdby'] = this.createdby;
    data['Updatedby'] = this.updatedby;
    return data;
  }
}
