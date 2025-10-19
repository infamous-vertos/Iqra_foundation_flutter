import 'dart:ffi';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iqra/models/transaction_model.dart';
import 'package:iqra/models/user_model.dart';

import '../models/total_model.dart';

class FirebaseHelper{
  static DatabaseReference rootRef = FirebaseDatabase.instance.ref();
  static DatabaseReference membersRef = FirebaseDatabase.instance.ref("members");
  static DatabaseReference bankingRef = FirebaseDatabase.instance.ref("banking");
  static DatabaseReference totalRef = bankingRef.child("total");
  static DatabaseReference balanceRef = totalRef.child("balance");
  static DatabaseReference expenseRef = totalRef.child("expense");
  static DatabaseReference transactionsRef = bankingRef.child("transactions");

  static FirebaseAuth auth = FirebaseAuth.instance;
  static final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  //Transaction related Ops
  static Future<bool> deposit(TransactionModel model) async{
    try{
      if(!await checkConnectivity()){
        return false;
      }
      TotalModel? totalModel;
      final result = await totalRef.runTransaction((data){
        if(data == null) return Transaction.abort();

        totalModel = TotalModel.fromJson(data as Map);

        debugPrint("Balance - $totalModel");
        final newModel = TotalModel(
            balance: totalModel!.balance + model.amount,
            expense: totalModel!.expense
        );

        return Transaction.success(newModel.toJson());
      });

      if(result.committed){
        model.totalBefore = totalModel;
        await transactionsRef.child(model.time.toString()).set(model.toJson());
      }else{
        return false;
      }
      return true;
    }catch(e,s){
      debugPrintStack(stackTrace: s);
      debugPrint("Deposit Error - $e");
      return false;
    }
  }

  static Future<bool> expense(TransactionModel model) async{
    try{
      if(!await checkConnectivity()){
        return false;
      }
      TotalModel? totalModel;
      final result = await totalRef.runTransaction((data){
        if(data == null) return Transaction.abort();

        totalModel = TotalModel.fromJson(data as Map);

        debugPrint("Balance - $totalModel");
        final newModel = TotalModel(
            balance: totalModel!.balance - model.amount,
            expense: totalModel!.expense + model.amount
        );

        return Transaction.success(newModel.toJson());
      });

      if(result.committed){
        model.totalBefore = totalModel;
        await transactionsRef.child(model.time.toString()).set(model.toJson());
      }else{
        return false;
      }
      return true;
    }catch(e,s){
      debugPrintStack(stackTrace: s);
      debugPrint("Deposit Error - $e");
      return false;
    }
  }

  //User or Member related Ops

  static Future<bool> updateUserData() async {
    try{
      if(!await checkConnectivity()){
        return false;
      }

      final user = auth.currentUser;
      if(user != null){
        final data = await getUserRef().get();
        if(data.exists) {
            return true;
        }
        final model = UserModel(
            user.uid,
            user.displayName ?? "NA",
            email: user.email ?? "NA",
            photoUrl: user.photoURL ?? "NA",
            phone: user.phoneNumber ?? "NA",
            joinedOn: DateTime.now().millisecondsSinceEpoch
        );
        getUserRef().update(model.toJson());
      }
      return true;
    }catch(e,s){
      debugPrintStack(stackTrace: s);
      return false;
    }
  }

  static String? getUserId() {
    final user = auth.currentUser;
    return user?.uid;
  }

  static DatabaseReference getUserRef(){
    final user = auth.currentUser;
    return membersRef.child(user!.uid);
  }

  static Future<UserModel?> getUserModel() async {
    try{
      final data = await getUserRef().get();
      if(data.exists){
        return UserModel.fromJson(data.value as Map);
      }else{
        return null;
      }
    }catch(e,s){
      debugPrintStack(stackTrace: s);
      return null;
    }
  }

  static Future<bool> isEmailRegistered(String email) async {
    try{
      if(!await checkConnectivity()){
        return true;
      }

      final query = membersRef
          .orderByChild("email")
          .equalTo(email);
      final data = await query.get();
      debugPrint("isEmailRegisteredCalled - ${data.children}");
      if(data.exists && data.children.isNotEmpty){
        return true;
      }
      return false;
    }on FirebaseException catch (e) {
      if (e.code == 'network-error') {
        debugPrint('No internet connection: ${e.message}');
      } else {
        debugPrint('Firebase error: ${e.code} - ${e.message}');
      }
      return false;
    } catch(e,s){
      debugPrintStack(stackTrace: s);
      return false;
    }
  }

  static Future<bool> addMember(String name, String email, String phone) async {
    try{
      if(!await checkConnectivity()){
        return false;
      }

      final ref = membersRef.push();
      final user = UserModel(
        ref.key!,
        name,
        email: email.isNotEmpty ? email : null,
        phone: phone.isNotEmpty ? phone : null,
        joinedOn: DateTime.now().millisecondsSinceEpoch
      );
      await ref.set(user.toJson());
      return true;
    }catch(e,s){
      debugPrintStack(stackTrace: s);
      return false;
    }
  }

  static final limit = 20;
  static final limitForSearch = 2;
  static int lastChildrenCount = 0;
  static String? lastKey;
  static Future<List<UserModel>> getMembers({bool isRefresh = false, String? searchText}) async{
    try{
      debugPrint("Search - $searchText");
      searchText = searchText?.capitalize;
      if(!await checkConnectivity()){
        return [];
      }

      if(searchText == null && !isRefresh && lastKey != null && (lastChildrenCount < limit || lastChildrenCount % limit != 0)) {
        return [];
      }

      var query = membersRef
          .orderByChild("name");

      if(searchText != null){
        query = query.startAt(searchText)
            .endAt("$searchText\uf8ff");
      }else if(lastKey != null){
        query = query.startAfter(lastKey);
      }

      query = query.limitToFirst(searchText != null ? limitForSearch : limit);

      final data = await query.get();

      if(searchText == null){
        lastChildrenCount = data.children.length;
        if(data.children.isNotEmpty){
          lastKey = data.children.last.key;
        }
      }

      debugPrint("getMembersCalled - ${data.children.length}");
      return data.children.map((e) => UserModel.fromJson(e.value as Map)).toList();
    }catch(e,s){
      debugPrintStack(stackTrace: s);
      return [];
    }
  }

  static Future<bool> checkConnectivity() async{
    final connectivityResult = await Connectivity().checkConnectivity();
    debugPrint("Result - $connectivityResult");
    if (connectivityResult.contains(ConnectivityResult.none)) {
      EasyLoading.showToast("No Internet");
      return false;
    } else {
      return true;
    }
  }

}