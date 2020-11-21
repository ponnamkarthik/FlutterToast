import 'package:FlutterToast_example/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastContext extends StatefulWidget {
  @override
  _ToastContextState createState() => _ToastContextState();
}

class _ToastContextState extends State<ToastContext> {
  FToast fToast;

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.greenAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check),
        SizedBox(
          width: 12.0,
        ),
        Text("This is a Custom Toast"),
      ],
    ),
  );

  _showToast() {
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  _showBuilderToast() {
    fToast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: 16.0,
            left: 16.0,
          );
        });
  }

  _showToastCancel() {
    Widget toastWithButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              "This is a Custom Toast This is a Custom Toast This is a Custom Toast This is a Custom Toast This is a Custom Toast This is a Custom Toast",
              softWrap: true,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
            ),
            color: Colors.white,
            onPressed: () {
              fToast.removeCustomToast();
            },
          )
        ],
      ),
    );
    fToast.showToast(
      child: toastWithButton,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 50),
    );
  }

  _queueToasts() {
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 2),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 2),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
  }

  _removeToast() {
    fToast.removeCustomToast();
  }

  _removeAllQueuedToasts() {
    fToast.removeQueuedCustomToasts();
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(globalKey.currentState.context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Toasts"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 24.0,
          ),
          RaisedButton(
            child: Text("Show Custom Toast"),
            onPressed: () {
              _showToast();
            },
          ),
          RaisedButton(
            child: Text("Show Custom Toast via PositionedToastBuilder"),
            onPressed: () {
              _showBuilderToast();
            },
          ),
          SizedBox(
            height: 24.0,
          ),
          RaisedButton(
            child: Text("Custom Toast With Close Button"),
            onPressed: () {
              _showToastCancel();
            },
          ),
          SizedBox(
            height: 24.0,
          ),
          RaisedButton(
            child: Text("Queue Toasts"),
            onPressed: () {
              _queueToasts();
            },
          ),
          SizedBox(
            height: 24.0,
          ),
          RaisedButton(
            child: Text("Cancel Toast"),
            onPressed: () {
              _removeToast();
            },
          ),
          SizedBox(
            height: 24.0,
          ),
          RaisedButton(
            child: Text("Remove Queued Toasts"),
            onPressed: () {
              _removeAllQueuedToasts();
            },
          ),
        ],
      ),
    );
  }
}
