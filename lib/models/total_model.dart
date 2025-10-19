import 'package:get/get.dart';

class TotalModel {
  final double balance, expense;

  TotalModel({required this.balance, required this.expense});

  TotalModel.fromJson(Map json)
    : balance = double.parse(json["balance"].toString()).toPrecision(1),
      expense = double.parse(json["expense"].toString()).toPrecision(1);

  Map<String,dynamic> toJson(){
    return {
      "balance": balance,
      "expense": expense
    };
  }
}
