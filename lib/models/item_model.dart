class ItemModel {
  String? itemId;
  String? name;
  String? description;
  String? photo;

  ItemModel({this.itemId, this.name, this.photo, this.description});
  ItemModel.fromJson(Map<String,dynamic> json){
    itemId = json['id'];
    name = json['name'];
    photo = json['photo'];
    description = json['description'];
  }

  Map<String, dynamic> toJson(){
    final data = <String, dynamic>{};
    data['id'] = itemId;
    data['name'] = name;
    data['photo'] = photo;
    data['description'] = description;
    return data;
  }
}