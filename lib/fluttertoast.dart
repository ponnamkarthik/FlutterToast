import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

enum Toast { LENGTH_SHORT, LENGTH_LONG }

enum ToastGravity { TOP, BOTTOM, CENTER }

class Fluttertoast {
  static const MethodChannel _channel =
      const MethodChannel('PonnamKarthik/fluttertoast');

  static Future<String> showToast({
    @required String msg,
    Toast toastLength,
    int timeInSecForIos = 1,
    ToastGravity gravity,
    Color backgroundColor = const Color.fromARGB(255, 0, 0, 0),
    Color textColor = const Color.fromARGB(255, 255, 255, 255),
  }) async {
    String toast = "short";
    if (toastLength == Toast.LENGTH_LONG) {
      toast = "long";
    }

    String gravityToast = "bottom";
    if (gravity == ToastGravity.TOP) {
      gravityToast = "top";
    } else if (gravity == ToastGravity.CENTER) {
      gravityToast = "center";
    } else {
      gravityToast = "bottom";
    }

    final Map<String, dynamic> params = <String, dynamic>{
      'msg': msg,
      'length': toast,
      'time': timeInSecForIos,
      'gravity': gravityToast,
      'bgcolor': backgroundColor.value,
      'textcolor': textColor.value,
    };
    String res = await _channel.invokeMethod('showToast', params);
    return res;
  }
}
