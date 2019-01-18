import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';

enum Toast { LENGTH_SHORT, LENGTH_LONG }

enum ToastGravity { TOP, BOTTOM, CENTER }

class Fluttertoast {
  static const MethodChannel _channel =
      const MethodChannel('PonnamKarthik/fluttertoast');

  Fluttertoast _instance;

  Fluttertoast get instance {
    if (_instance == null) {

    }
  }



  Fluttertoast(){
    _channel.setMethodCallHandler(_handleMethod);
  }


  Function(bool) didTap;

  Future<String> showToast({
    @required String msg,
    Toast toastLength,
    int timeInSecForIos = 1,
    ToastGravity gravity,
    Color backgroundColor,
    Color textColor,
    Function(bool) didTap,
  }) async {
    this.didTap = didTap;
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

    if(backgroundColor == null && defaultTargetPlatform == TargetPlatform.iOS) {
      backgroundColor = Colors.black;
    }
    if(textColor == null && defaultTargetPlatform == TargetPlatform.iOS) {
      textColor = Colors.white;
    }
    final Map<String, dynamic> params = <String, dynamic>{
      'msg': msg,
      'length': toast,
      'time': timeInSecForIos,
      'gravity': gravityToast,
      'bgcolor': backgroundColor != null ? backgroundColor.value : null,
      'textcolor': textColor != null ? textColor.value: null,
    };

    String res = await _channel.invokeMethod('showToast', params);
    return res;
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
  switch(call.method) {
    case "onTap":

      didTap(true);
      
      return new Future.value("");
  }
}
}
