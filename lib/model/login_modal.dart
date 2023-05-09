class LoginModal {
  int? id;
  String? firstName;
  String? lastName;
  String? profilePicture;
  int? newsletter;
  String? email;
  String? pucode;
  String? mobile;
  String? companyName;
  int? billingProfileId;
  int? otp;
  int? userId;
  int? planId;
  String? createdAt;
  String? updatedAt;
  String? stripeId;
  int? paypalId;
  String? pmType;
  String? pmLastFour;
  int? paypalSubscriptionId;
  String? token;
  String? type;
  String? name;
  String? currentSubscription;
  bool? cancelled;
  String? siteUrl;
  List<String>? errors;
  bool? success;
  dynamic campaignId;

  LoginModal(
      {this.id,
      this.firstName,
      this.lastName,
      this.profilePicture,
      this.newsletter,
      this.email,
      this.pucode,
      this.mobile,
      this.companyName,
      this.billingProfileId,
      this.otp,
      this.userId,
      this.planId,
      this.createdAt,
      this.updatedAt,
      this.stripeId,
      this.paypalId,
      this.pmType,
      this.pmLastFour,
      this.paypalSubscriptionId,
      this.token,
      this.type,
      this.name,
      this.currentSubscription,
      this.cancelled,
      this.siteUrl,
      this.errors,
      this.success,
      this.campaignId
      });

  LoginModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePicture = json['profile_picture'];
    newsletter = json['newsletter'];
    email = json['email'];
    pucode = json['pucode'];
    mobile = json['mobile'];
    companyName = json['company_name'];
    billingProfileId = json['billing_profile_id'];
    otp = json['otp'];
    userId = json['user_id'];
    planId = json['plan_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    stripeId = json['stripe_id'];
    paypalId = json['paypal_id'];
    pmType = json['pm_type'];
    pmLastFour = json['pm_last_four'];
    paypalSubscriptionId = json['paypal_subscription_id'];
    token = json['token'];
    type = json['type'];
    name = json['name'];
    currentSubscription = json['current_subscription'];
    cancelled = json['cancelled'];
    siteUrl = json['site_url'];
    errors = json['errors'].cast<String>();
     success = json['success'];
     campaignId=json['campaign_id'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_picture'] = profilePicture;
    data['newsletter'] = newsletter;
    data['email'] = email;
    data['pucode'] = pucode;
    data['mobile'] = mobile;
    data['company_name'] = companyName;
    data['billing_profile_id'] = billingProfileId;
    data['otp'] = otp;
    data['user_id'] = userId;
    data['plan_id'] = planId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['stripe_id'] = stripeId;
    data['paypal_id'] = paypalId;
    data['pm_type'] = pmType;
    data['pm_last_four'] = pmLastFour;
    data['paypal_subscription_id'] = paypalSubscriptionId;
    data['token'] = token;
    data['type'] = type;
    data['name'] = name;
    data['current_subscription'] = currentSubscription;
    data['cancelled'] = cancelled;
    data['site_url'] = siteUrl;
    return data;
  }
}
