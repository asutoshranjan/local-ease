class MyUserModel{
  String? title;
  String? description;
  bool? isDone;
  String? userId;
  String? docId;

  MyUserModel({this.title, this.description, this.isDone, this.userId, this.docId});
  MyUserModel.fromJson(Map<String,dynamic> json){
    title = json['title'];
    description = json['description'];
    isDone = json['isDone'];
    userId = json['userId'];
    docId = json['docId'];
  }

  Map<String, dynamic> toJson(){
    final data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['isDone'] = isDone;
    data['userId'] = userId;
    data['docId'] = docId;
    return data;
  }
}
