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
  bool?
      approve_status; // Rename approve_status to follow Dart naming conventions
  String? reference;
  String? condition;
  String? socialMediaLink;
  String? counter;
  String? dateofbirth;
  bool? isAvailable;

  UserModel({
    this.userId,
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
    this.lastDonateDate,
    this.approve_status,
    this.reference,
    this.condition,
    this.socialMediaLink,
    this.counter,
    this.dateofbirth,
    this.isAvailable
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
    approve_status = json[
        'approve_status']; // Rename approve_status to follow Dart naming conventions
    reference = json['reference'];
    condition = json['condition'];
    socialMediaLink = json['socialMediaLink'];
    counter = json['blood_count'];
    dateofbirth = json['date_of_birth'];
    isAvailable = json['isAvailable'];




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
    data['approve_status'] =
        approve_status; // Rename approve_status to follow Dart naming conventions
    data['reference'] = reference;
    data['condition'] = condition;
    data['socialMediaLink'] = socialMediaLink;
    data['blood_count']=counter;
    data['date_of_birth']=dateofbirth;
    data['isAvailable']=isAvailable;




    return data;
  }
}
