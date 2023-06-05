class ShopModel {
  String? name;
  String? about;
  bool? isOpen;
  List? items;
  List? outStock;
  String? country;
  String? pincode;
  String? district;
  String? phone;
  String? email;
  String? opens;
  String? closes;
  String? ownerId;
  List? subscribers;
  String? lat;
  String? long;
  String? address;
  String? photo;

  ShopModel(
      {this.name,
      this.about,
      this.isOpen,
      this.items,
      this.outStock,
      this.subscribers,
      this.country,
      this.pincode,
      this.district,
      this.email,
      this.photo,
      this.lat,
      this.long,
      this.phone,
      this.address,
      this.closes,
      this.opens,
      this.ownerId});
  ShopModel.fromJson(Map<String, dynamic> json) {
    name  = json['name'];
    about = json['about'];
    isOpen = json['isopen'];
    items = json['items'];
    outStock = json['outstock'];
    country = json['country'];
    pincode = json['pincode'];
    district = json['district'];
    phone = json['phone'];
    email = json['email'];
    opens = json['opens'];
    closes = json['closes'];
    ownerId = json['ownerid'];
    subscribers = json['subscribers'];
    lat = json['lat'];
    long = json['long'];
    address = json['address'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name ;
    data['about'] = about;
    data['isopen'] = isOpen;
    data['items'] = items;
    data['outstock'] = outStock;
    data['country'] = country;
    data['pincode'] = pincode;
    data['district'] = district;
    data['phone'] = phone;
    data['email'] = email;
    data['opens'] = opens;
    data['closes'] = closes;
    data['ownerid'] = ownerId;
    data['subscribers'] = subscribers;
    data['lat'] = lat;
    data['long'] = long;
    data['address'] = address;
    data['photo'] = photo;

    return data;
  }
}
