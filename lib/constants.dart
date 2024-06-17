import 'dart:io';

///Author-Pushkar Srivastava
///Date-07/10/22

class Constants {
  static const helpShiftDomain = 'ravi-demo.helpshift.com';
  static helpShiftApiKey() {
    if (Platform.isAndroid) {
      return '16f1';
    } else if (Platform.isIOS) {
      return "16f1";
    } else {
      return "";
    }
  }

  static helpShiftAppId() {
    if (Platform.isAndroid) {
      return 'ravi-demo_pl51a';
    } else if (Platform.isIOS) {
      return "ravi-demo_plfb1";
    } else {
      return "";
    }
  }
}
