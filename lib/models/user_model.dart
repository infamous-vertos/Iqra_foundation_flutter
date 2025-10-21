import 'package:get/get.dart';
import 'package:iqra/utils/global.dart';

class UserModel {
  final String uid, name;

  String? phone, email, photoUrl, oldUid;
  int? joinedOn;
  UserStatus? status;

  UserModel(this.uid, this.name, {
    this.email,
    this.photoUrl,
    this.phone,
    this.joinedOn,
    this.status,
    this.oldUid
  });

  factory UserModel.fromJson(Map json) {
    return UserModel(
      json['uid'],
      json['name'],
      oldUid: json['oldUid'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      phone: json['phone'],
      joinedOn: json['joinedOn'] ?? 0,
      status: getUserStatusInstance(json['status'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name.capitalize,
      'email': email,
      'photoUrl': photoUrl,
      'phone': phone,
      'joinedOn': joinedOn,
      'status': getUserStatusString(status),
      'oldUid': oldUid
    };
  }

  String getJoinedOn(){
    if(joinedOn == null) return "NA";
    return Global.dateFormatOnlyDate.format(DateTime.fromMillisecondsSinceEpoch(joinedOn!));
  }
}

enum UserStatus{
  VERIFIED,
  UNVERIFIED,
  ACTIVE,
  INACTIVE;
}

getUserStatusInstance(String? status){
  switch(status){
    case "VERIFIED":
      return UserStatus.VERIFIED;
    case "ACTIVE":
      return UserStatus.ACTIVE;
    case "INACTIVE":
      return UserStatus.INACTIVE;
    default:
      return UserStatus.UNVERIFIED;
  }
}

getUserStatusString(UserStatus? status){
  switch(status) {
    case UserStatus.VERIFIED:
      return "VERIFIED";
    case UserStatus.ACTIVE:
      return "ACTIVE";
    case UserStatus.INACTIVE:
      return "INACTIVE";
    default:
      return "UNVERIFIED";
  }
}
