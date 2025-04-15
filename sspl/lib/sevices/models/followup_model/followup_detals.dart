class FollowupDetailsModel {
  String? message;
  List<FollowUpDetailData>? data;
  int? statuscode;
  int? totalCount;

  FollowupDetailsModel(
      {this.message, this.data, this.statuscode, this.totalCount});

  FollowupDetailsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <FollowUpDetailData>[];
      json['data'].forEach((v) {
        data!.add(new FollowUpDetailData.fromJson(v));
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

class FollowUpDetailData {
  String? cRemarks;
  String? cSubstatus;
  String? cFollowupdate;
  String? cUpdateDate;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  FollowUpDetailData(
      {this.cRemarks,
      this.cSubstatus,
      this.cFollowupdate,
      this.cUpdateDate,
      this.isActive,
      this.createdDate,
      this.date,
      this.modifiedDate,
      this.createdby,
      this.updatedby});

  FollowUpDetailData.fromJson(Map<String, dynamic> json) {
    cRemarks = json['CRemarks'];
    cSubstatus = json['CSubstatus'];
    cFollowupdate = json['CFollowupdate'];
    cUpdateDate = json['CUpdateDate'];
    isActive = json['IsActive'];
    createdDate = json['CreatedDate'];
    date = json['Date'];
    modifiedDate = json['ModifiedDate'];
    createdby = json['Createdby'];
    updatedby = json['Updatedby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CRemarks'] = this.cRemarks;
    data['CSubstatus'] = this.cSubstatus;
    data['CFollowupdate'] = this.cFollowupdate;
    data['CUpdateDate'] = this.cUpdateDate;
    data['IsActive'] = this.isActive;
    data['CreatedDate'] = this.createdDate;
    data['Date'] = this.date;
    data['ModifiedDate'] = this.modifiedDate;
    data['Createdby'] = this.createdby;
    data['Updatedby'] = this.updatedby;
    return data;
  }
}
