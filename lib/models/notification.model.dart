class NotificationModel{
  String? shopid;
  String? title;
  String? description;
  String? photo;
  List? users;
  String? notificationId;

  NotificationModel({this.title, this.users, this.shopid, this.photo, this.notificationId, this.description});
  NotificationModel.fromJson(Map<String,dynamic> json){
    title = json['title'];
    users = json['users'];
    shopid = json['shopid'];
    photo = json['photo'];
    description = json['description'];
    notificationId = json['id'];
  }

  Map<String, dynamic> toJson(){
    final data = <String, dynamic>{};
    data['title'] = title;
    data['users'] = users;
    data['shopid'] = shopid;
    data['photo'] = photo;
    data['description'] = description;
    data['id'] = notificationId;
    return data;
  }
}
