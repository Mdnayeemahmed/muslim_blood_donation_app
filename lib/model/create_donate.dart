class Donate {
  String? title;
  String? link;

  Donate({this.title, this.link});

  Donate.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    link = json['link']; // Convert Timestamp to DateTime
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['link'] = link;
    return data;
  }
}
