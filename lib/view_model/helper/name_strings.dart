class NameStrings {
  static var adminModel = const _AdminModel();
  static String get data => "data";
}



class _AdminModel {
  const _AdminModel();

  String get id => "admin_id";

  String get name => "admin_name";

  String get email => "admin_email";

  String get pass => "admin_password";

  String get type => "admin_type";

  String get image => "admin_image_url";

  String get createdAt => "created_time";

  String get updatedAt => "last_update_time";

  String get lastLogin => "last_login_time";
}


