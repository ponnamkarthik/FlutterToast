
# [fluttertoast](https://pub.dartlang.org/packages/fluttertoast)  
  
Flutter Toast Library for Flutter  
  
> Supported Platforms  
>  
> - ALL
  
## Notice

This update has changes complete plugin to new one

Previously this plugin used to interact with native platform which now removed.

## Features

1 - Full Controll of the Toast
2 - Toasts will be queued
3 - Remove a toast
4 - Clear the queue
  
## How to Use  
  
```yaml  
# add this line to your dependencies  
fluttertoast: ^6.0.0
```  
  
```dart  
import 'package:fluttertoast/fluttertoast.dart';  
```  
  
```dart 
FlutterToast flutterToast;

@override
void initState() {
    super.initState();
    flutterToast = FlutterToast(context);
}

_showToast() {
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


    flutterToast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
    );
}

```  

Now Call `_showToast()`

For more details check `example` project
  
| property        | description                                                        | default    |  
| --------------- | ------------------------------------------------------------------ |------------|  
| child             | Widget (Not Null)(required)                                        |required    |  
| toastDuration     | Duration (optional)                                                 |  |
| gravity         | ToastGravity.*    |  |
### To cancel all the toasts call  
  
```dart  
// To remove present shwoing toast
flutterToast.removeCustomToast()  

// To clear the queue
flutterToast.removeQueuedCustomToasts();
```  
  
## Preview Images  
  
<img src="https://raw.githubusercontent.com/PonnamKarthik/FlutterToast/master/screenshot/1.png" width="320px" /> 


## If you need any features suggest