class ViewExpenses {
  String? message;
  List<ViewExpensesData>? data;
  int? statuscode;
  int? totalCount;

  ViewExpenses({this.message, this.data, this.statuscode, this.totalCount});

  ViewExpenses.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <ViewExpensesData>[];
      json['data'].forEach((v) {
        data!.add(new ViewExpensesData.fromJson(v));
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

class ViewExpensesData {
  int? catId;
  int? expId;
  String? category;
  var name;
  var invoice;
  var description;
  var expenseDate1;
  int? action;
  int? amount;
  int? status;
  String? createBy;
  String? updateBy;
  String? createDate;
  String? expenseDate;
  String? updateDate;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  ViewExpensesData(
      {this.catId,
      this.expId,
      this.category,
      this.name,
      this.invoice,
      this.description,
      this.expenseDate1,
      this.action,
      this.amount,
      this.status,
      this.createBy,
      this.updateBy,
      this.createDate,
      this.expenseDate,
      this.updateDate,
      this.isActive,
      this.createdDate,
      this.date,
      this.modifiedDate,
      this.createdby,
      this.updatedby});

  ViewExpensesData.fromJson(Map<String, dynamic> json) {
    catId = json['CatId'];
    expId = json['ExpId'];
    category = json['Category'];
    name = json['Name'];
    invoice = json['Invoice'];
    description = json['Description'];
    expenseDate1 = json['ExpenseDate1'];
    action = json['Action'];
    amount = json['Amount'];
    status = json['Status'];
    createBy = json['CreateBy'];
    updateBy = json['UpdateBy'];
    createDate = json['CreateDate'];
    expenseDate = json['ExpenseDate'];
    updateDate = json['UpdateDate'];
    isActive = json['IsActive'];
    createdDate = json['CreatedDate'];
    date = json['Date'];
    modifiedDate = json['ModifiedDate'];
    createdby = json['Createdby'];
    updatedby = json['Updatedby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CatId'] = this.catId;
    data['ExpId'] = this.expId;
    data['Category'] = this.category;
    data['Name'] = this.name;
    data['Invoice'] = this.invoice;
    data['Description'] = this.description;
    data['ExpenseDate1'] = this.expenseDate1;
    data['Action'] = this.action;
    data['Amount'] = this.amount;
    data['Status'] = this.status;
    data['CreateBy'] = this.createBy;
    data['UpdateBy'] = this.updateBy;
    data['CreateDate'] = this.createDate;
    data['ExpenseDate'] = this.expenseDate;
    data['UpdateDate'] = this.updateDate;
    data['IsActive'] = this.isActive;
    data['CreatedDate'] = this.createdDate;
    data['Date'] = this.date;
    data['ModifiedDate'] = this.modifiedDate;
    data['Createdby'] = this.createdby;
    data['Updatedby'] = this.updatedby;
    return data;
  }
}
