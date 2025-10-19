class TotalModel {
  final double balance, expense;

  TotalModel({required this.balance, required this.expense});

  TotalModel.fromJson(Map json)
    : balance = double.parse(json["balance"].toString()),
      expense = double.parse(json["expense"].toString());

  Map<String,dynamic> toJson(){
    return {
      "balance": balance,
      "expense": expense
    };
  }
}
