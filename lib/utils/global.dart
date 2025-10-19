import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Global{
  static final dateFormatFull = DateFormat('yyyy-MM-dd HH:mm:ss');
  static final dateFormatOnlyDate = DateFormat('dd MMM yyy');
  static final dateFormatOnlyTime = DateFormat('hh:mm a');

  static void hideKeyboard(){
    try{
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }catch(e){
      debugPrint("hideKeyboardError -> $e");
    }
  }
}