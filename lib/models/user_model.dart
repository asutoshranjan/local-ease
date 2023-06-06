class MyUserModel{
  String? name;
  List? following;
  List? notifications;
  String? email;
  String? photo;
  String? type;
  String? docId;

  MyUserModel({this.name, this.following, this.notifications, this.email, this.photo, this.docId, this.type});
  MyUserModel.fromJson(Map<String,dynamic> json){
    name = json['name'];
    following = json['following'];
    notifications = json['notifications'];
    email = json['email'];
    photo = json['photo'];
    type = json['type'];
    docId = json['docid'];
  }

  Map<String, dynamic> toJson(){
    final data = <String, dynamic>{};
    data['name'] = name;
    data['following'] = following;
    data['notifications'] = notifications;
    data['email'] = email;
    data['photo'] = photo;
    data['type'] = type;
    data['docid'] = docId;
    return data;
  }
}
