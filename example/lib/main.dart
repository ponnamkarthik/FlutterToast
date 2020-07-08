import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(
      MaterialApp(
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterToast flutterToast;

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
    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
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
              flutterToast.removeCustomToast();
            },
          )
        ],
      ),
    );
    flutterToast.showToast(
      child: toastWithButton,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 50),
    );
  }

  _queueToasts() {
    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 2),
    );
    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 2),
    );
    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
  }

  _removeToast() {
    flutterToast.removeCustomToast();
  }

  _removeAllQueuedToasts() {
    flutterToast.removeQueuedCustomToasts();
  }

  @override
  void initState() {
    super.initState();
    flutterToast = FlutterToast(context);
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
