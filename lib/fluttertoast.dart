import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

enum Toast { LENGTH_SHORT, LENGTH_LONG }

enum ToastGravity { TOP, BOTTOM, CENTER, TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT, CENTER_LEFT, CENTER_RIGHT }

@Deprecated("Will be removed in further release")
class Fluttertoast {
  @Deprecated("Will be removed in further release")
  static void showToast(BuildContext context, {ToastGravity gravity = ToastGravity.BOTTOM, String msg, int toastDuration = 3}) {
    FlutterToast flutterToast = FlutterToast(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Color.fromRGBO(61, 61, 61, .7),
      ),
      child: Text(
        msg,
        style: TextStyle(color: Colors.white),
      ),
    );

    flutterToast.showToast(
      child: toast,
      gravity: gravity,
      toastDuration: Duration(seconds: toastDuration),
    );
  }
}

class FlutterToast {
  BuildContext context;

  static final FlutterToast _instance = FlutterToast._internal();

  factory FlutterToast(BuildContext context) {
    _instance.context = context;
    return _instance;
  }

  FlutterToast._internal();

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
