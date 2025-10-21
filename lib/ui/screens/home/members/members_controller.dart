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
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  Timer? _debounce;
  final isAdmin = false.obs;

  @override
  Future<void> onReady() async {
    debugPrint("OnReady");
    fetchData(isRefresh: true);
    final result = await FirebaseHelper.isAdmin();
    isAdmin.value = result;
    super.onReady();
  }


  @override
  void onClose() {
    _debounce?.cancel();
  }

  fetchData({bool isRefresh = false, String? query, RxBool? isLoading}) async {
    query = (query != null && query.isEmpty) ? null : query;

    if(!isRefresh && query == null && originalList.isNotEmpty){
      debugPrint("Original - ${originalList.length}");
      tempList.assignAll(originalList);
      return;
    }

    isLoading ??= this.isLoading;

    if(isLoading.isTrue) return;
    isLoading.value = true;
    final list = await FirebaseHelper.getMembers(isRefresh: isRefresh, searchText: query);
    if(query == null){
      if(isRefresh) {
        originalList.assignAll(list);
      } else {
        originalList.addAll(list);
      }
      tempList.assignAll(originalList);
    }else{
      tempList.assignAll(list);
    }
    debugPrint("Members: ${list.map((e) => e.name).toList()}");
    isLoading.value = false;
  }

  searchMembers(String query) async {
    // if(query.isEmpty){
    //   tempList.value = originalList;
    //   return;
    // }

    if(_debounce?.isActive ?? false) _debounce?.cancel();
    if(query.isEmpty){
      fetchData();
    }else{
      _debounce = Timer(Duration(milliseconds: 700), (){
        fetchData(query: query, isRefresh: true);
      });
    }
  }

  Future<void> addMember(String name, String email, String phone, { UserModel? user }) async {
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

    if(user?.status != UserStatus.VERIFIED && email.isNotEmpty){
      final isEmailRegistered = await FirebaseHelper.isEmailRegistered(email);
      if(isEmailRegistered){
        EasyLoading.showToast("Email is already registered");
        return;
      }
    }

    final result = await FirebaseHelper.addMember(name, email, phone, uid: user?.uid);
    if(result) {
      fetchData(isRefresh: true);
      Get.back();
      EasyLoading.showToast("Member added successfully");
    }
  }
}