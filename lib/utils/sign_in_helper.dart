import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iqra/utils/FirebaseHelper.dart';

class SignInHelper{
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  SignInHelper(){
    _googleSignIn.initialize();
  }

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      // authenticate() throws exceptions instead of returning null
      final GoogleSignInAccount account = await _googleSignIn.authenticate(
        scopeHint: ['email'],  // Specify required scopes
      );

      final GoogleSignInAuthentication auth = account.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
        // accessToken: auth.accessToken, // Access token is available here
      );
      await FirebaseHelper.auth.signInWithCredential(credential);
      // final isUpdated = await FirebaseHelper.updateUserData();
      // if(!isUpdated) {
      //   FirebaseHelper.auth.signOut();
      //   return null;
      // }
      debugPrint("SignIn Successfully");
      return account;
    } on GoogleSignInException catch (e) {
      debugPrint("Sign-in error: $e");
      return null;
    } catch (e) {
      debugPrint("Unexpected error: $e");
      return null;
    }
  }
}