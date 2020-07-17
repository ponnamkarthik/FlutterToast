import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum Toast { LENGTH_SHORT, LENGTH_LONG }

enum ToastGravity { TOP, BOTTOM, CENTER, TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT, CENTER_LEFT, CENTER_RIGHT }

class Fluttertoast {
  static const MethodChannel _channel = const MethodChannel('PonnamKarthik/fluttertoast');

  static Future<bool> cancel() async {
    bool res = await _channel.invokeMethod("cancel");
    return res;
  }

  static Future<bool> showToast(
      {@required String msg,
      Toast toastLength,
      int timeInSecForIosWeb = 1,
      double fontSize = 16.0,
      ToastGravity gravity,
      Color backgroundColor,
      Color textColor,
      bool webShowClose = false,
      webBgColor: "linear-gradient(to right, #00b09b, #96c93d)",
      webPosition: "right"
      // Function(bool) didTap,
      }) async {
    // this.didTap = didTap;
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

    if (backgroundColor == null && defaultTargetPlatform == TargetPlatform.iOS) {
      backgroundColor = Colors.black;
    }
    if (textColor == null && defaultTargetPlatform == TargetPlatform.iOS) {
      textColor = Colors.white;
    }
    final Map<String, dynamic> params = <String, dynamic>{
      'msg': msg,
      'length': toast,
      'time': timeInSecForIosWeb,
      'gravity': gravityToast,
      'bgcolor': backgroundColor != null ? backgroundColor.value : null,
      'textcolor': textColor != null ? textColor.value : null,
      'fontSize': fontSize,
      'webShowClose': webShowClose,
      'webBgColor': webBgColor,
      'webPosition': webPosition
    };

    bool res = await _channel.invokeMethod('showToast', params);
    return res;
  }
}

class FToast {
  BuildContext context;

  static final FToast _instance = FToast._internal();

  factory FToast(BuildContext context) {
    _instance.context = context;
    return _instance;
  }

  FToast._internal();

  OverlayEntry _entry;
  List<_ToastEntry> _overlayQueue = List();
  Timer _timer;

  _showOverlay() {
    if (_overlayQueue.length == 0) {
      _entry = null;
      return;
    }
    _ToastEntry _toastEntry = _overlayQueue.removeAt(0);
    _entry = _toastEntry.entry;
    if (context == null) throw ("Error: Context is null");
    Overlay.of(context).insert(_entry);

    _timer = Timer(_toastEntry.duration, () {
      removeCustomToast();
    });
  }

  removeCustomToast() {
    _timer?.cancel();
    _timer = null;
    if (_entry != null) _entry.remove();
    _showOverlay();
  }

  removeQueuedCustomToasts() {
    _timer?.cancel();
    _timer = null;
    _overlayQueue.clear();
    if (_entry != null) _entry.remove();
    _entry = null;
  }

  void showToast({
    @required Widget child,
    Duration toastDuration,
    ToastGravity gravity,
  }) {
    OverlayEntry newEntry = OverlayEntry(builder: (context) {
      return _getPostionWidgetBasedOnGravity(child, gravity);
    });
    _overlayQueue.add(_ToastEntry(entry: newEntry, duration: toastDuration ?? Duration(seconds: 2)));
    if (_timer == null) _showOverlay();
  }

  _getPostionWidgetBasedOnGravity(Widget child, ToastGravity gravity) {
    Widget newChild = Center(
      child: Material(
        color: Colors.transparent,
        child: child,
      ),
    );
    switch (gravity) {
      case ToastGravity.TOP:
        return Positioned(top: 100.0, left: 24.0, right: 24.0, child: newChild);
        break;
      case ToastGravity.TOP_LEFT:
        return Positioned(top: 100.0, left: 24.0, child: newChild);
        break;
      case ToastGravity.TOP_RIGHT:
        return Positioned(top: 100.0, right: 24.0, child: newChild);
        break;
      case ToastGravity.CENTER:
        return Positioned(top: 50.0, bottom: 50.0, left: 24.0, right: 24.0, child: newChild);
        break;
      case ToastGravity.CENTER_LEFT:
        return Positioned(top: 50.0, bottom: 50.0, left: 24.0, child: newChild);
        break;
      case ToastGravity.CENTER_RIGHT:
        return Positioned(top: 50.0, bottom: 50.0, right: 24.0, child: newChild);
        break;
      case ToastGravity.BOTTOM_LEFT:
        return Positioned(bottom: 50.0, left: 24.0, child: newChild);
        break;
      case ToastGravity.BOTTOM_RIGHT:
        return Positioned(bottom: 50.0, right: 24.0, child: newChild);
        break;
      case ToastGravity.BOTTOM:
      default:
        return Positioned(bottom: 50.0, left: 24.0, right: 24.0, child: newChild);
    }
  }
}

class _ToastEntry {
  final OverlayEntry entry;
  final Duration duration;

  _ToastEntry({this.entry, this.duration});
}
