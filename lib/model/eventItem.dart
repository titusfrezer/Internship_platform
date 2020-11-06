

class User{
  String identity;
  String email;
  String fullName;
  String furtherInfo;
  String image;


  User(this.identity,this.email,this.fullName,this.furtherInfo,this.image);

  User.map(dynamic obj){
    this.identity = obj['identity'];
    this.email =obj['email'];
    this.fullName = obj['fullName'];
    this.furtherInfo= obj['furtherInfo'];
    this.image = obj['image'];

  }
  String get Identity => identity;
  String get Email=>email;
  String get FullName => fullName;
  String get FurtherInfo => furtherInfo;
  String get Image => image;


  Map<String,dynamic> toMap() {
    var map = new Map<String,dynamic>();
    map["identity"] = identity;
    map["email"]=email;
    map['fullName'] = fullName;
    map['furtherInfo'] = furtherInfo;
    map['image'] = image;
    return map;
  }
  User.fromMap(Map<String,dynamic> map){

    this.identity = map["identity"];
    this.email= map['email'];
    this.fullName = map["fullName"];

    this.furtherInfo = map["fullMonth"];

    this.image = map ["image"];

  }

}
