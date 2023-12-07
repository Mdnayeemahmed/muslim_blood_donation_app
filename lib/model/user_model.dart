class UserModel {
  String? userId;
  String? userEmail;
  String? userName;
  String? userPhone;
  String? userPhotoUrl;
  String? userDeviceTokens;
  String? createdTime;
  String? lastUpdateTime;
  String? userDivison;
  String? userDistrict;
  String? userArea;
  String? userBloodType;
  bool? admin;
  String? lastDonateDate;

  UserModel({this.userId,
    this.userEmail,
    this.userName,
    this.userPhone,
    this.userPhotoUrl,
    this.userDeviceTokens,
    this.createdTime,
    this.lastUpdateTime,
    this.userArea,
    this.userBloodType,
    this.userDistrict,
    this.userDivison,
    this.admin,
    this.lastDonateDate
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    admin = json['admin_type'];
    userId = json['user_id'];
    userEmail = json['user_email'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
    userPhotoUrl = json['user_photo_url'];
    userDeviceTokens = json['user_device_tokens'];
    createdTime = json['created_time'];
    lastUpdateTime = json['last_update_time'];
    userDistrict = json['user_district'];
    userDivison = json['user_divison'];
    userArea = json['user_area'];
    userBloodType = json['user_bloodtype'];
    lastDonateDate = json['last_donate_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['admin_type'] = admin;
    data['user_name'] = userName;
    data['user_id'] = userId;
    data['user_email'] = userEmail;
    data['user_phone'] = userPhone;
    data['user_photo_url'] = userPhotoUrl;
    data['user_device_tokens'] = userDeviceTokens;
    data['created_time'] = createdTime;
    data['last_update_time'] = lastUpdateTime;
    data['user_district'] = userDistrict;
    data['user_divison'] = userDivison;
    data['user_area'] = userArea;
    data['user_bloodtype'] = userBloodType;
    data['last_donate_date'] = lastDonateDate;


    return data;
  }
}
