import 'dart:io';

///Author-Pushkar Srivastava
///Date-07/10/22

class Constants {
  static const helpShiftDomain = 'ravi-demo.helpshift.com';
  static helpShiftApiKey() {
    if (Platform.isAndroid) {
      return '166b4bd08f4a62fbb91f6dc965d81bf1';
    } else if (Platform.isIOS) {
      return "166b4bd08f4a62fbb91f6dc965d81bf1";
    } else {
      return "";
    }
  }

  static helpShiftAppId() {
    if (Platform.isAndroid) {
      return 'ravi-demo_platform_20220331005029798-1e2a4b59980151a';
    } else if (Platform.isIOS) {
      return "ravi-demo_platform_20220331005029716-39b80be81e0cfb1";
    } else {
      return "";
    }
  }
}
