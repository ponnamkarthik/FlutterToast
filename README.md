# [fluttertoast](https://pub.dartlang.org/packages/fluttertoast)


Android Toast Library for Flutter

> Supported  Platforms
> * Android
> * IOS

## How to Use

```yaml
# add this line to your dependencies
fluttertoast: ^2.2.0
```

```dart
import 'package:fluttertoast/fluttertoast.dart';
```

```dart
Fluttertoast.showToast(
        msg: "This is Center Short Toast",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white
    );
```

property | description
--------|------------
msg | String (Not Null)(required)
toastLength| Toast.LENGTH_SHORT or Toast.LENGTH_LONG (optional)
gravity | ToastGravity.TOP (or) ToastGravity.CENTER (or) ToastGravity.BOTTOM
timeInSecForIos | int (only for ios)
bgcolor | Colors.red
textcolor| Colors.white


## Preview Images

<img src="https://raw.githubusercontent.com/PonnamKarthik/FlutterToast/master/screenshot/1.png" width="320px" />
<img src="https://raw.githubusercontent.com/PonnamKarthik/FlutterToast/master/screenshot/2.png" width="320px" />
<img src="https://raw.githubusercontent.com/PonnamKarthik/FlutterToast/master/screenshot/3.png" width="320px" />
<img src="https://raw.githubusercontent.com/PonnamKarthik/FlutterToast/master/screenshot/4.png" width="320px" />
