import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iqra/utils/FirebaseHelper.dart';
import 'package:iqra/utils/global.dart';

import '../../../../models/transaction_model.dart';
import '../../../../models/user_model.dart';

class DashboardController extends GetxController{
  final transactions = <TransactionModel>[].obs;
  final balance = "---".obs;
  final expense = "---".obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isAdmin = false.obs;
  Timer? debounce;

  @override
  Future<void> onReady() async {
    // deposit();
    getTransactions();
    getTotal();

    final result = await FirebaseHelper.isAdmin();
    isAdmin.value = result;

    super.onReady();
  }

  @override
  void onClose() {
    debounce?.cancel();
    super.onClose();
  }

  getTotal() async {
    final result = await FirebaseHelper.getTotal();
    debugPrint("getTotal - $result");
    if(result != null){
      balance.value = result.balance.toInt().toString();
      expense.value = result.expense.toInt().toString();
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

  Future<void> deposit({required String amount, required String desc, required UserModel? by}) async{
    Global.hideKeyboard();

    if(by == null){
      EasyLoading.showToast("Select a member");
      return;
    }

    if(amount.isEmpty){
      EasyLoading.showToast("Enter amount");
      return;
    }

    if(double.tryParse(amount) == null){
      EasyLoading.showToast("Enter valid amount");
      return;
    }

    // if(desc.isEmpty){
    //   EasyLoading.showToast("Enter description");
    //   return;
    // }

    try{
      final time = DateTime.now().millisecondsSinceEpoch;
      final userModel = await FirebaseHelper.getUserModel();
      debugPrint("User - $userModel");
      final model = TransactionModel(
          id: time,
          time: time,
          amount: double.tryParse(amount) ?? 0.0,
          type: TransactionType.DEPOSIT,
          by: by,
          admin: userModel!,
          description: desc
      );
      final result = await FirebaseHelper.deposit(model);
      debugPrint("Deposit - $result");
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

  Future<void> addExpense({required String amount, required String desc}) async{
    Global.hideKeyboard();
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