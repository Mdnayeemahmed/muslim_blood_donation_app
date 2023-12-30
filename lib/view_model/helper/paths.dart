class Paths{
  static var database = const _Database();
}

class _Database {
  const _Database();

  String get collectionUser => "user_data_collection";
  String get collectionReq => "req_data_collection";
  String get collectionDonation => "donation_data_collection";

  String get collectionAppConstants => "app_const_collection";

  String get docCounts => "counts_data_docs";
  String get docAppData => "app_data_docs";
}


