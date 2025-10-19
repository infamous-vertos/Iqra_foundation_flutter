import 'dart:math';

import 'package:iqra/models/total_model.dart';
import 'package:iqra/models/user_model.dart';

class TransactionModel{
  late int id, time;
  late TransactionType type;
  late double amount;
  late TotalModel? totalBefore;
  late UserModel by, admin;

  TransactionModel({
    required this.id,
    required this.time,
    required this.type,
    required this.amount,
    required this.by,
    required this.admin,
    this.totalBefore
  });

  TransactionModel.fromJson(Map json){
    id = json["id"];
    time = json["time"];
    type = getTransactionInstance(json["type"]);
    amount = json["amount"];
    by = UserModel.fromJson(json["by"]);
    admin = UserModel.fromJson(json["from"]);
    totalBefore = json["totalBefore"] != null ? TotalModel.fromJson(json["totalBefore"]) : null;
  }

  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "time": time,
      "type": getTransactionString(type),
      "amount": amount.toDouble(),
      "by": by.toJson(),
      "admin": admin.toJson(),
      "totalBefore": totalBefore?.toJson()
    };
  }
}

enum TransactionType{
  DEPOSITE,
  WITHDRAWAL
}

getTransactionString(TransactionType type){
  switch(type){
    case TransactionType.DEPOSITE:
      return "Deposit";
    case TransactionType.WITHDRAWAL:
      return "Withdrawal";
  }
}

getTransactionInstance(String type){
  switch(type){
    case "Deposit":
      return TransactionType.DEPOSITE;
    case "Withdrawal":
      return TransactionType.WITHDRAWAL;
  }
}