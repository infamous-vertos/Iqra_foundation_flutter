import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iqra/utils/FirebaseHelper.dart';

import '../../../../models/transaction_model.dart';

class DashboardController extends GetxController{

  @override
  void onReady() {
    // deposit();
    super.onReady();
  }

  deposit() async{
    final time = DateTime.now().millisecondsSinceEpoch;
    final userModel = await FirebaseHelper.getUserModel();
    debugPrint("User - $userModel");
    final model = TransactionModel(
      id: time,
      time: time,
      amount: 10,
      type: TransactionType.WITHDRAWAL,
      by: userModel!,
      admin: userModel
    );
    FirebaseHelper.expense(model);
  }

}