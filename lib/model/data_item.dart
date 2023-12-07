class DataItem {
  String? id;
  String? name;
  String? postOffice;

  String? division_id;
  String? district_id;


  DataItem({this.id, this.name,this.division_id,this.district_id,this.postOffice});

  DataItem.fromJson(Map<String, dynamic> json) {
    id = json['id']??'';
    name = json['name']??'';
    division_id = json['division_id']??'';
    district_id = json['district_id']??'';
    postOffice = json['postOffice']??'';
  }

  String toString() {
    return 'Data(id: $id, name: $name,division_id:$division_id,district_id:$district_id)';
  }
}
