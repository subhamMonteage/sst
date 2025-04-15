class ViewExpenseModal {
  String? message;
  List<VieExpenseData>? data;
  int? statuscode;
  int? totalCount;

  ViewExpenseModal({this.message, this.data, this.statuscode, this.totalCount});

  ViewExpenseModal.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <VieExpenseData>[];
      json['data'].forEach((v) {
        data!.add(new VieExpenseData.fromJson(v));
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

  ViewExpenseModal filterDataBetweenDates(String startDate, String endDate) {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);

    List<VieExpenseData> filteredData = data!.where((item) {
      DateTime clockInDate = DateTime.parse(item.visitDate!);
      return clockInDate.isAfter(start) && clockInDate.isBefore(end);
    }).toList();

    return ViewExpenseModal(
      message: this.message,
      data: filteredData,
      statuscode: this.statuscode,
      totalCount: filteredData.length,
    );
  }
}

class VieExpenseData {
  int? empMarktingExpId;
  String? visitDate;
  String? purpose;
  String? customerName;
  String? cityName;
  String? contactPersonName;
  String? contactNo;
  String? emailId;
  String? visitDetails;
  String? eXPPurpose;
  String? eXPAmount;
  String? eXPPublicConveDetails;
  String? eXPAmount2;
  String? eXPTravelKmVehicle;
  String? eXPAmount3;
  String? eXPExpensedetails;
  String? createBy;
  String? eXPStatus;
  Null? totalAmount;
  String? createDate;
  String? firstName;
  String? lastName;
  String? statusUpdate;
  String? statusUpdateDate;
  int? allTotalAmount;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  VieExpenseData(
      {this.empMarktingExpId,
      this.visitDate,
      this.purpose,
      this.customerName,
      this.cityName,
      this.contactPersonName,
      this.contactNo,
      this.emailId,
      this.visitDetails,
      this.eXPPurpose,
      this.eXPAmount,
      this.eXPPublicConveDetails,
      this.eXPAmount2,
      this.eXPTravelKmVehicle,
      this.eXPAmount3,
      this.eXPExpensedetails,
      this.createBy,
      this.eXPStatus,
      this.totalAmount,
      this.createDate,
      this.firstName,
      this.lastName,
      this.statusUpdate,
      this.statusUpdateDate,
      this.allTotalAmount,
      this.isActive,
      this.createdDate,
      this.date,
      this.modifiedDate,
      this.createdby,
      this.updatedby});

  VieExpenseData.fromJson(Map<String, dynamic> json) {
    empMarktingExpId = json['EmpMarktingExpId'];
    visitDate = json['VisitDate'];
    purpose = json['Purpose'];
    customerName = json['CustomerName'];
    cityName = json['CityName'];
    contactPersonName = json['ContactPersonName'];
    contactNo = json['ContactNo'];
    emailId = json['EmailId'];
    visitDetails = json['VisitDetails'];
    eXPPurpose = json['EXPPurpose'];
    eXPAmount = json['EXPAmount'];
    eXPPublicConveDetails = json['EXPPublicConveDetails'];
    eXPAmount2 = json['EXPAmount2'];
    eXPTravelKmVehicle = json['EXPTravelKmVehicle'];
    eXPAmount3 = json['EXPAmount3'];
    eXPExpensedetails = json['EXPExpensedetails'];
    createBy = json['CreateBy'];
    eXPStatus = json['EXPStatus'];
    totalAmount = json['TotalAmount'];
    createDate = json['CreateDate'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    statusUpdate = json['StatusUpdate'];
    statusUpdateDate = json['StatusUpdateDate'];
    allTotalAmount = json['AllTotalAmount'];
    isActive = json['IsActive'];
    createdDate = json['CreatedDate'];
    date = json['Date'];
    modifiedDate = json['ModifiedDate'];
    createdby = json['Createdby'];
    updatedby = json['Updatedby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmpMarktingExpId'] = this.empMarktingExpId;
    data['VisitDate'] = this.visitDate;
    data['Purpose'] = this.purpose;
    data['CustomerName'] = this.customerName;
    data['CityName'] = this.cityName;
    data['ContactPersonName'] = this.contactPersonName;
    data['ContactNo'] = this.contactNo;
    data['EmailId'] = this.emailId;
    data['VisitDetails'] = this.visitDetails;
    data['EXPPurpose'] = this.eXPPurpose;
    data['EXPAmount'] = this.eXPAmount;
    data['EXPPublicConveDetails'] = this.eXPPublicConveDetails;
    data['EXPAmount2'] = this.eXPAmount2;
    data['EXPTravelKmVehicle'] = this.eXPTravelKmVehicle;
    data['EXPAmount3'] = this.eXPAmount3;
    data['EXPExpensedetails'] = this.eXPExpensedetails;
    data['CreateBy'] = this.createBy;
    data['EXPStatus'] = this.eXPStatus;
    data['TotalAmount'] = this.totalAmount;
    data['CreateDate'] = this.createDate;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['StatusUpdate'] = this.statusUpdate;
    data['StatusUpdateDate'] = this.statusUpdateDate;
    data['AllTotalAmount'] = this.allTotalAmount;
    data['IsActive'] = this.isActive;
    data['CreatedDate'] = this.createdDate;
    data['Date'] = this.date;
    data['ModifiedDate'] = this.modifiedDate;
    data['Createdby'] = this.createdby;
    data['Updatedby'] = this.updatedby;
    return data;
  }
}
