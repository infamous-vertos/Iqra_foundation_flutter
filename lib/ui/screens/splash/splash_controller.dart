import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iqra/models/user_model.dart';
import 'package:iqra/ui/navigation/routes.dart';
import 'package:iqra/utils/FirebaseHelper.dart';
import 'package:iqra/utils/sign_in_helper.dart';

class SplashController extends GetxController{
  final isLoading = false.obs;
  final _signInHelper = SignInHelper();
  final error = "".obs;

  @override
  Future<void> onReady() async {
    super.onReady();
    if(FirebaseHelper.getUserId() != null){
      Get.offNamed(Routes.home);
    }
  }

  onTap() async {
    isLoading.value = true;
    final account = await _signInHelper.signInWithGoogle();
    if(account != null){
      final userModel = await FirebaseHelper.getRegisteredUserModel(account.email);
      if(userModel != null){
        if(userModel.status == UserStatus.VERIFIED){
          Get.offNamed(Routes.home);
        }else{
          final result = await FirebaseHelper.updateUserData(oldModel: userModel);
          if(result){
            Get.offNamed(Routes.home);
          }else{
            error.value = "Something went wrong";
          }
        }
      }else{
        await FirebaseHelper.auth.signOut();
        error.value = "You are not authorised\nPlease contact admin!";
      }
    }else{
      EasyLoading.showToast("Something went wrong");
    }
    isLoading.value = false;
  }
}