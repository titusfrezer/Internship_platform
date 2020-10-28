

class User{
  String identity;
  String email;
  String fullName;
  String furtherInfo;



  User(this.identity,this.email,this.fullName,this.furtherInfo);

  User.map(dynamic obj){
    this.identity = obj['identity'];
    this.email =obj['email'];
    this.fullName = obj['fullName'];
    this.furtherInfo= obj['furtherInfo'];

  }
  String get Identity => identity;
  String get Email=>email;
  String get FullName => fullName;
  String get FurtherInfo => furtherInfo;


  Map<String,dynamic> toMap() {
    var map = new Map<String,dynamic>();
    map["identity"] = identity;
    map["email"]=email;
    map['fullName'] = fullName;
    map['furtherInfo'] = furtherInfo;

    return map;
  }
  User.fromMap(Map<String,dynamic> map){

    this.identity = map["identity"];
    this.email= map['email'];
    this.fullName = map["fullName"];

    this.furtherInfo = map["fullMonth"];



  }

}
