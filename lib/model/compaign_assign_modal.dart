class CompaignAssignModal {
  String? campaignId;
  History? history;
  String? campaignName;
  bool? updateAvailable;
  bool? success;
  String? error;

  CompaignAssignModal(
      {this.campaignId,
      this.history,
      this.campaignName,
      this.updateAvailable,
      this.success,
      this.error});

  CompaignAssignModal.fromJson(Map<String, dynamic> json) {
    campaignId = json['campaign_id'];
    history =
        json['history'] != null ? History.fromJson(json['history']) : null;
    campaignName = json['campaign_name'];
    updateAvailable = json['update_available'];
    success = json['success'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['campaign_id'] = campaignId;
    if (history != null) {
      data['history'] = history!.toJson();
    }
    data['campaign_name'] = campaignName;
    data['update_available'] = updateAvailable;
    data['success'] = success;
    data['error'] = error;
    return data;
  }
}

class History {
  int? id;
  int? userId;
  int? deviceId;
  dynamic campaignId;
  String? loginTime;
  String? logoutTime;
  String? createdAt;
  String? updatedAt;

  History(
      {this.id,
      this.userId,
      this.deviceId,
      this.campaignId,
      this.loginTime,
      this.logoutTime,
      this.createdAt,
      this.updatedAt});

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    deviceId = json['device_id'];
    campaignId = json['campaign_id'];
    loginTime = json['login_time'];
    logoutTime = json['logout_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['device_id'] = deviceId;
    data['campaign_id'] = campaignId;
    data['login_time'] = loginTime;
    data['logout_time'] = logoutTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
