import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iqra/models/total_model.dart';
import 'package:iqra/models/user_model.dart';

import '../gen/assets.gen.dart';
import '../utils/global.dart';

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
    amount = double.tryParse(json["amount"].toString()) ?? 0.0;
    by = UserModel.fromJson(json["by"]);
    admin = UserModel.fromJson(json["admin"]);
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

  String getTransactionSubtitle(){
    final date = Global.dateFormatOnlyDate.format(DateTime.fromMicrosecondsSinceEpoch(time));
    if(type == TransactionType.DEPOSIT){
      return "₹$amount deposited on $date";
    }else if(type == TransactionType.WITHDRAWAL){
      return "₹$amount withdrawn on $date";
    }else{
      return "₹$amount";
    }
  }

  String getImagePath(){
    if(type == TransactionType.DEPOSIT){
      return Assets.images.deposite.path;
    }else if(type == TransactionType.WITHDRAWAL){
      return Assets.images.expense.path;
    }else{
      return Assets.images.deposite.path;
    }
  }

  Color getColor(){
    if(type == TransactionType.DEPOSIT){
      return Colors.green;
    }else if(type == TransactionType.WITHDRAWAL){
      return Colors.red;
    }else{
      return Colors.red;
    }
  }
}

enum TransactionType{
  DEPOSIT,
  WITHDRAWAL
}

getTransactionString(TransactionType type){
  switch(type){
    case TransactionType.DEPOSIT:
      return "Deposit";
    case TransactionType.WITHDRAWAL:
      return "Withdrawal";
  }
}

getTransactionInstance(String type){
  switch(type){
    case "Deposit":
      return TransactionType.DEPOSIT;
    case "Withdrawal":
      return TransactionType.WITHDRAWAL;
  }
}