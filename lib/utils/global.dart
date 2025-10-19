import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Global{
  static void hideKeyboard(){
    try{
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }catch(e){
      debugPrint("hideKeyboardError -> $e");
    }
  }
}