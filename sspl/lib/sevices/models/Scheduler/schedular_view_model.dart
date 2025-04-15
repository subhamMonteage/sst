class SchedularViewModel {
  String? message;
  List<Data>? data;
  int? statuscode;
  int? totalCount;

  SchedularViewModel(
      {this.message, this.data, this.statuscode, this.totalCount});

  SchedularViewModel.fromJson(Map<String, dynamic> json) {
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

  SchedularViewModel filterDataBetweenDates(String startDate, String endDate) {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);

    List<Data> filteredData = data!.where((item) {
      DateTime clockInDate = DateTime.parse(item.createDate!);
      return clockInDate.isAfter(start) && clockInDate.isBefore(end);
    }).toList();

    return SchedularViewModel(
      message: this.message,
      data: filteredData,
      statuscode: this.statuscode,
      totalCount: filteredData.length,
    );
  }

  SchedularViewModel filterDataByDate(String date) {
    DateTime targetDate = DateTime.parse(date);
    List<Data> filteredData = data!.where((item) {
      DateTime schedulerDate = DateTime.parse(item.schedulerDate!);
      return schedulerDate.year == targetDate.year &&
          schedulerDate.month == targetDate.month &&
          schedulerDate.day == targetDate.day;
    }).toList();

    return SchedularViewModel(
      message: this.message,
      data: filteredData,
      statuscode: this.statuscode,
      totalCount: filteredData.length,
    );
  }
}

class Data {
  int? schedulerId;
  String? schedulerDate;
  String? description;
  String? status;
  String? createBy;
  String? createDate;
  String? namee;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  Data(
      {this.schedulerId,
      this.schedulerDate,
      this.description,
      this.status,
      this.createBy,
      this.createDate,
      this.namee,
      this.isActive,
      this.createdDate,
      this.date,
      this.modifiedDate,
      this.createdby,
      this.updatedby});

  Data.fromJson(Map<String, dynamic> json) {
    schedulerId = json['SchedulerId'];
    schedulerDate = json['SchedulerDate'];
    description = json['Description'];
    status = json['Status'];
    createBy = json['CreateBy'];
    createDate = json['CreateDate'];
    namee = json['Namee'];
    isActive = json['IsActive'];
    createdDate = json['CreatedDate'];
    date = json['Date'];
    modifiedDate = json['ModifiedDate'];
    createdby = json['Createdby'];
    updatedby = json['Updatedby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SchedulerId'] = this.schedulerId;
    data['SchedulerDate'] = this.schedulerDate;
    data['Description'] = this.description;
    data['Status'] = this.status;
    data['CreateBy'] = this.createBy;
    data['CreateDate'] = this.createDate;
    data['Namee'] = this.namee;
    data['IsActive'] = this.isActive;
    data['CreatedDate'] = this.createdDate;
    data['Date'] = this.date;
    data['ModifiedDate'] = this.modifiedDate;
    data['Createdby'] = this.createdby;
    data['Updatedby'] = this.updatedby;
    return data;
  }
}
