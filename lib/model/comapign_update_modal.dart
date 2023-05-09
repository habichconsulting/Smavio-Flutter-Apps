class CompaignUpdateModal {
  int? campaignId;
  String? campaignName;
  bool? updateAvailable;
  bool? success;
  String? msg;
  String? error;

  CompaignUpdateModal(
      {this.campaignId,
      this.campaignName,
      this.updateAvailable,
      this.success,
      this.msg,
      this.error});

  CompaignUpdateModal.fromJson(Map<String, dynamic> json) {
    campaignId = json['campaign_id'];
    campaignName = json['campaign_name'];
    updateAvailable = json['update_available'];
    success = json['success'];
    msg = json['msg'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['campaign_id'] = campaignId;
    data['campaign_name'] = campaignName;
    data['update_available'] = updateAvailable;
    data['success'] = success;
    data['msg'] = msg;
    data['error'] = error;
    return data;
  }
}
