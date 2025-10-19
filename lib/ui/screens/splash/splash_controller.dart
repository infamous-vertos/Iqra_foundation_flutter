import 'package:get/get.dart';
import 'package:iqra/ui/navigation/routes.dart';
import 'package:iqra/utils/FirebaseHelper.dart';
import 'package:iqra/utils/sign_in_helper.dart';

class SplashController extends GetxController{
  final isLoading = false.obs;
  final _signInHelper = SignInHelper();

  @override
  void onReady() {
    super.onReady();
    if(FirebaseHelper.getUserId() != null){
      Get.offNamed(Routes.home);
    }
  }

  onTap() async {
    final account = await _signInHelper.signInWithGoogle();
    if(account != null){
      Get.offNamed(Routes.home);
    }
  }
}