class ForgotPassModal {
  List<String>? errors;
  String? message;
  bool? success;

  ForgotPassModal({this.errors, this.message, this.success});

  ForgotPassModal.fromJson(Map<String, dynamic> json) {
    errors = json['errors'].cast<String>();
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errors'] = this.errors;
    data['message'] = this.message;
    data['success'] = this.success;
    return data;
  }
}
