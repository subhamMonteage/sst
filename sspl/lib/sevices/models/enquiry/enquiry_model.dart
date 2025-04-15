class ViewEnquiryModel {
  String? message;
  List<ViewEnquiryModelData>? data;
  int? statuscode;
  int? totalCount;

  ViewEnquiryModel({this.message, this.data, this.statuscode, this.totalCount});

  ViewEnquiryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <ViewEnquiryModelData>[];
      json['data'].forEach((v) {
        data!.add(new ViewEnquiryModelData.fromJson(v));
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

  ViewEnquiryModel filterDataBetweenDates(String startDate, String endDate) {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);

    List<ViewEnquiryModelData> filteredData = data!.where((item) {
      DateTime clockInDate = DateTime.parse(item.createDate!);
      return clockInDate.isAfter(start) && clockInDate.isBefore(end);
    }).toList();

    return ViewEnquiryModel(
      message: this.message,
      data: filteredData,
      statuscode: this.statuscode,
      totalCount: filteredData.length,
    );
  }
}

class ViewEnquiryModelData {
  int? enquiryId;
  String? customerName;
  String? cityName;
  String? contactPerson;
  String? contactNo;
  String? emailId;
  String? eStatus;
  String? enquiryDetails;
  var action;
  String? createBy;
  var updateBy;
  String? createDate;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  ViewEnquiryModelData(
      {this.enquiryId,
      this.customerName,
      this.cityName,
      this.contactPerson,
      this.contactNo,
      this.emailId,
      this.eStatus,
      this.enquiryDetails,
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

  ViewEnquiryModelData.fromJson(Map<String, dynamic> json) {
    enquiryId = json['EnquiryId'];
    customerName = json['CustomerName'];
    cityName = json['CityName'];
    contactPerson = json['ContactPerson'];
    contactNo = json['ContactNo'];
    emailId = json['EmailId'];
    eStatus = json['EStatus'];
    enquiryDetails = json['EnquiryDetails'];
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
    data['EnquiryId'] = this.enquiryId;
    data['CustomerName'] = this.customerName;
    data['CityName'] = this.cityName;
    data['ContactPerson'] = this.contactPerson;
    data['ContactNo'] = this.contactNo;
    data['EmailId'] = this.emailId;
    data['EStatus'] = this.eStatus;
    data['EnquiryDetails'] = this.enquiryDetails;
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
