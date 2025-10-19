import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iqra/utils/FirebaseHelper.dart';
import 'package:iqra/utils/global.dart';

import '../../../../models/transaction_model.dart';

class DashboardController extends GetxController{
  final transactions = <TransactionModel>[].obs;
  final balance = "---".obs;
  final expense = "---".obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  @override
  void onReady() {
    // deposit();
    getTransactions();
    getTotal();
    super.onReady();
  }

  getTotal() async {
    final result = await FirebaseHelper.getTotal();
    debugPrint("getTotal - $result");
    if(result != null){
      balance.value = result.balance.toString();
      expense.value = result.expense.toString();
    }else{
      balance.value = "Error";
      expense.value = "Error";
    }
  }

  getTransactions({RxBool? isLoading, bool isRefresh = false}) async {
    isLoading ??= this.isLoading;

    if(isLoading.isTrue){
      return;
    }
    isLoading.value = true;

    final result = await FirebaseHelper.getTransactions(isRefresh: isRefresh);
    debugPrint("getTransactions - ${result?.map((e) => e.time).toList()}");
    if(result != null){
      if(isRefresh){
        transactions.assignAll(result);
      }else{
        transactions.addAll(result);
      }
    }
    isLoading.value = false;
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

  Future<void> addExpense({required String amount, required String desc}) async{
    if(amount.isEmpty){
      EasyLoading.showToast("Enter amount");
      return;
    }

    if(double.tryParse(amount) == null){
      EasyLoading.showToast("Enter valid amount");
      return;
    }

    if(desc.isEmpty){
      EasyLoading.showToast("Enter description");
      return;
    }

    try{
      final time = DateTime.now().millisecondsSinceEpoch;
      final userModel = await FirebaseHelper.getUserModel();
      debugPrint("User - $userModel");
      final model = TransactionModel(
          id: time,
          time: time,
          amount: double.tryParse(amount) ?? 0.0,
          type: TransactionType.WITHDRAWAL,
          by: userModel!,
          admin: userModel,
          description: desc
      );
      final result = await FirebaseHelper.expense(model);
      debugPrint("Expense - $result");
      if(result){
        getTransactions(isRefresh: true);
        getTotal();
        Get.back();
      }else{
        EasyLoading.showToast("Something went wrong");
      }
    }catch(e,s){
      debugPrintStack(stackTrace: s);
    }
  }

}