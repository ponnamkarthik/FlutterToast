import 'package:flutter/services.dart';


enum Toast {
  LENGTH_SHORT,
  LENGTH_LONG
}


class Fluttertoast {

  static const MethodChannel _channel =
      const MethodChannel('PonnamKarthik/fluttertoast');

  static void showToast(String msg, Toast toastLength) {
    String toast = "short";
    if(toastLength == Toast.LENGTH_LONG) {
      toast = "long";
    }
    final Map<String, dynamic> params = <String, dynamic> {
      'msg': msg,
      'length': toast
    };
    _channel.invokeMethod('showToast', params);
  }

}

