import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iqra/models/user_model.dart';
import 'package:iqra/utils/FirebaseHelper.dart';
import 'package:iqra/utils/global.dart';

class MembersController extends GetxController{
  final searchController = TextEditingController();
  final RxList<UserModel> tempList = <UserModel>[].obs;
  final RxList<UserModel> originalList = <UserModel>[].obs;
  final isLoading = true.obs;
  Timer? _debounce;

  @override
  void onReady() {
    fetchData();
  }


  @override
  void onClose() {
    _debounce?.cancel();
  }

  fetchData({bool isRefresh = false, String? query}) async {
    if(isLoading.isTrue) return;
    isLoading.value = true;
    final list = await FirebaseHelper.getMembers(isRefresh: isRefresh, searchText: query);
    if(isRefresh){
      if(query != null){
        originalList.assignAll(list);
      }
      tempList.assignAll(list);
    }else{
      if(query != null){
        tempList.addAll(list);
      }else{
        originalList.addAll(list);
        tempList.assignAll(originalList);
      }
    }
    debugPrint("Members: ${list}");
    isLoading.value = false;
  }

  searchMembers(String query) async {
    if(query.isEmpty){
      tempList.value = originalList;
      return;
    }
    if(_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 500), (){
      fetchData(query: query, isRefresh: true);
    });
  }

  Future<void> addMember(String name, String email, String phone) async {
    debugPrint("Name - $name, Email - $email, Phone - $phone");
    if(name.length < 3){
      EasyLoading.showToast("Enter a valid name");
      return;
    }

    if(email.isNotEmpty && !GetUtils.isEmail(email)){
      EasyLoading.showToast("Enter a valid email");
      return;
    }

    if(phone.isNotEmpty && phone.length != 10){
      EasyLoading.showToast("Enter a valid phone");
      return;
    }

    Global.hideKeyboard();

    if(email.isNotEmpty){
      final isEmailRegistered = await FirebaseHelper.isEmailRegistered(email);
      if(isEmailRegistered){
        EasyLoading.showToast("Email is already registered");
        return;
      }
    }

    final result = await FirebaseHelper.addMember(name, email, phone);
    if(result) {
      fetchData(isRefresh: true);
      Get.back();
      EasyLoading.showToast("Member added successfully");
    }
  }
}