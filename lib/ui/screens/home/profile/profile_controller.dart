import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iqra/models/user_model.dart';
import 'package:iqra/ui/navigation/routes.dart';
import 'package:iqra/utils/FirebaseHelper.dart';

import '../../../../models/transaction_model.dart';

class ProfileController extends GetxController{
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final transactions = <TransactionModel>[].obs;


  @override
  void onReady() {
    fetchData();
    getTransactions(isLoading: isLoadingMore);
  }

  fetchData() async {
    isLoading.value = true;
    user.value = await FirebaseHelper.getUserModel();
    isLoading.value = false;
  }

  getTransactions({RxBool? isLoading, bool isRefresh = false}) async {
    isLoading ??= this.isLoading;

    if(isLoading.isTrue){
      return;
    }
    isLoading.value = true;

    final result = await FirebaseHelper.getUserTransactions(isRefresh: isRefresh);
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

  signOut(){
    FirebaseHelper.auth.signOut();
    Get.offAllNamed(Routes.splash);
  }
}