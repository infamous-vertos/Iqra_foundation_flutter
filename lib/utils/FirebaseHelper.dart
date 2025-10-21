import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iqra/models/transaction_model.dart';
import 'package:iqra/models/user_model.dart';

import '../models/total_model.dart';

class FirebaseHelper{
  static DatabaseReference rootRef = FirebaseDatabase.instance.ref();
  static DatabaseReference membersRef = FirebaseDatabase.instance.ref("members");
  static DatabaseReference bankingRef = FirebaseDatabase.instance.ref("banking");
  static DatabaseReference adminRef = FirebaseDatabase.instance.ref("admins");
  static DatabaseReference totalRef = bankingRef.child("total");
  static DatabaseReference balanceRef = totalRef.child("balance");
  static DatabaseReference expenseRef = totalRef.child("expense");
  static DatabaseReference transactionsRef = bankingRef.child("transactions");

  static FirebaseAuth auth = FirebaseAuth.instance;

  //Check for admins
  static bool? _isAdminMember;

  static Future<bool> isAdmin() async {
    try{
      if(_isAdminMember != null) {
        return _isAdminMember!;
      }

      final uid = getUserId();
      if(uid == null) {
        return false;
      }

      final result = await adminRef.child(uid).get();
      if(result.exists && result.value == true){
        _isAdminMember = true;
        return true;
      }
      _isAdminMember = false;
      return false;
    }catch(e,s){
      debugPrintStack(stackTrace: s);
      return false;
    }
  }

  //Transaction related Ops
  static final transactionLimit = 20;
  static String? lastKey;
  static Future<List<TransactionModel>?> getTransactions({bool isRefresh = false}) async {
    try{
      var query = transactionsRef
          .orderByKey();

      if(!isRefresh && lastKey != null){
        query = query.endBefore(lastKey);
      }

      query = query.limitToLast(transactionLimit);

      final data = await query.get();

      if(data.children.isNotEmpty){
        lastKey = data.children.first.key;
        debugPrint("LastKey - $lastKey");
      }
      debugPrint("Data Length - ${data.children.length}");
      if(data.exists){
        return data.children.map((e) => TransactionModel.fromJson(e.value as Map)).toList();
      }else{
        return null;
      }
    }catch(e,s){
      debugPrintStack(stackTrace: s);
      return null;
    }
  }

  static final userTransactionLimit = 10;
  static String? userLastKey;
  static Future<List<TransactionModel>?> getUserTransactions({bool isRefresh = false}) async {
    try{
      final userId = getUserId();

      var query = transactionsRef
          .orderByChild("by/uid")
          .equalTo(userId);

      if(!isRefresh && userLastKey != null){
        query = query.endBefore(userLastKey);
      }

      query = query.limitToLast(userTransactionLimit);

      final data = await query.get();

      if(data.children.isNotEmpty){
        userLastKey = data.children.first.key;
        debugPrint("LastKey - $userLastKey");
      }
      debugPrint("Data Length - ${data.children.length}");
      if(data.exists){
        return data.children.map((e) => TransactionModel.fromJson(e.value as Map)).toList();
      }else{
        return null;
      }
    }catch(e,s){
      debugPrintStack(stackTrace: s);
      return null;
    }
  }

  static Future<TotalModel?> getTotal() async {
    try{
      final data = await totalRef.get();
      if(data.exists){
        return TotalModel.fromJson(data.value as Map);
      }else{
        return null;
      }
    }catch(e,s){
      debugPrintStack(stackTrace: s);
      return null;
    }
  }

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

  static Future<bool> updateUserData({required UserModel oldModel}) async {
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
        final newModel = UserModel(
            user.uid,
            oldModel.name,
            email: user.email,
            photoUrl: user.photoURL,
            phone: oldModel.phone,
            joinedOn: oldModel.joinedOn,
          status: UserStatus.VERIFIED,
          oldUid: oldModel.uid
        );
        await getUserRef().set(newModel.toJson());
        await membersRef.child(oldModel.uid).remove();
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

  static Future<UserModel?> getRegisteredUserModel(String email) async {
    try{
      if(!await checkConnectivity()){
        return null;
      }
      final query = membersRef
          .orderByChild("email")
          .equalTo(email);
      final data = await query.get();
      debugPrint("isEmailRegisteredCalled - ${data.children}");
      if(data.exists && data.children.isNotEmpty){
        return UserModel.fromJson(data.children.first.value as Map);
      }
      return null;
    }on FirebaseException catch (e) {
      if (e.code == 'network-error') {
        debugPrint('No internet connection: ${e.message}');
      } else {
        debugPrint('Firebase error: ${e.code} - ${e.message}');
      }
      return null;
    } catch(e,s){
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

  static Future<bool> addMember(String name, String email, String phone, { String? uid }) async {
    try{
      if(!await checkConnectivity()){
        return false;
      }

      final ref = uid != null ? membersRef.child(uid) : membersRef.push();
      if(uid != null){
        await ref.update({
          "name": name,
          "email": email.isNotEmpty ? email : null,
          "phone": phone.isNotEmpty ? phone : null
        });
      }else{
        final user = UserModel(
            ref.key!,
            name,
            email: email.isNotEmpty ? email : null,
            phone: phone.isNotEmpty ? phone : null,
            joinedOn: DateTime.now().millisecondsSinceEpoch
        );
        await ref.set(user.toJson());
      }
      return true;
    }catch(e,s){
      debugPrintStack(stackTrace: s);
      return false;
    }
  }

  static final limit = 20;
  static final limitForSearch = 5;
  static int lastChildrenCount = 0;
  static String? lastName;
  static Future<List<UserModel>> getMembers({bool isRefresh = false, String? searchText, int? tempLimit}) async{
    try{
      debugPrint("Search - $searchText, isRefresh - $isRefresh");
      debugPrint("lasName - $lastName");
      if(isRefresh){
        lastChildrenCount = 0;
        lastName = null;
      }
      searchText = searchText?.capitalize;
      if(!await checkConnectivity()){
        return [];
      }

      if(searchText == null && !isRefresh && lastName != null && (lastChildrenCount < limit || lastChildrenCount % limit != 0)) {
        return [];
      }

      var query = membersRef
          .orderByChild("name");

      if(searchText != null){
        query = query.startAt(searchText)
            .endAt("$searchText\uf8ff");
      }else if(lastName != null){
        query = query.startAfter(lastName);
      }

      query = query.limitToFirst(tempLimit ?? (searchText != null ? limitForSearch : limit));

      final data = await query.get();

      if(searchText == null){
        lastChildrenCount = data.children.length;
        if(data.children.isNotEmpty){
          lastName = UserModel.fromJson(data.children.last.value as Map).name;
        }
      }

      debugPrint("getMembersCalled - ${data.children.length}");
      debugPrint("lastKey - ${data.children.last.value}");
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