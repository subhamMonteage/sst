class TypeDropDownModel {
  String? message;
  List<OrganizationData>? data;
  int? statuscode;
  int? totalCount;

  TypeDropDownModel(
      {this.message, this.data, this.statuscode, this.totalCount});

  TypeDropDownModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <OrganizationData>[];
      json['data'].forEach((v) {
        data!.add(new OrganizationData.fromJson(v));
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

class OrganizationData {
  int? courseId;
  String? courseName;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  OrganizationData(
      {this.courseId,
      this.courseName,
      this.isActive,
      this.createdDate,
      this.date,
      this.modifiedDate,
      this.createdby,
      this.updatedby});

  OrganizationData.fromJson(Map<String, dynamic> json) {
    courseId = json['CourseId'];
    courseName = json['CourseName'];
    isActive = json['IsActive'];
    createdDate = json['CreatedDate'];
    date = json['Date'];
    modifiedDate = json['ModifiedDate'];
    createdby = json['Createdby'];
    updatedby = json['Updatedby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CourseId'] = this.courseId;
    data['CourseName'] = this.courseName;
    data['IsActive'] = this.isActive;
    data['CreatedDate'] = this.createdDate;
    data['Date'] = this.date;
    data['ModifiedDate'] = this.modifiedDate;
    data['Createdby'] = this.createdby;
    data['Updatedby'] = this.updatedby;
    return data;
  }
}
