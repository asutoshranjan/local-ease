class MyUserModel{
  String? name;
  List? following;
  List? notifications;
  String? email;
  String? photo;
  String? type;
  String? docId;
  String? createdAt;
  String? address;
  String? lat;
  String? long;
  String? country;
  String? pincode;
  String? district;

  MyUserModel({this.name, this.following, this.notifications, this.email, this.photo, this.docId, this.type, this.createdAt, this.address, this.lat, this.long, this.district, this.pincode, this.country});
  MyUserModel.fromJson(Map<String,dynamic> json){
    name = json['name'];
    following = json['following'];
    notifications = json['notifications'];
    email = json['email'];
    photo = json['photo'];
    type = json['type'];
    docId = json['docid'];
    createdAt = json['\$createdAt'];
    country = json['country'];
    pincode = json['pincode'];
    district = json['district'];
    lat = json['lat'];
    long = json['long'];
    address = json['address'];
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
    data['country'] = country;
    data['pincode'] = pincode;
    data['district'] = district;
    data['lat'] = lat;
    data['long'] = long;
    data['address'] = address;
    return data;
  }
}
