# [fluttertoast](https://pub.dartlang.org/packages/fluttertoast)


Android Toast Library for Flutter

> Supported  Platforms
> * Android
> * IOS

## How to Use

```yaml
# add this line to your dependencies
fluttertoast: ^2.0.9
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
        bgcolor: "#e74c3c",
        textcolor: '#ffffff'
    );
```

property | description
--------|------------
msg | String (Not Null)(required)
toastLength| Toast.LENGTH_SHORT or Toast.LENGTH_LONG (optional)
gravity | ToastGravity.TOP (or) ToastGravity.CENTER (or) ToastGravity.BOTTOM
timeInSecForIos | int (only for ios)
bgcolor | string (color in hex format)
textcolor| '#ffffff'


## Preview Images

<img src="https://raw.githubusercontent.com/PonnamKarthik/FlutterToast/master/screenshot/1.png" width="320px" />
<img src="https://raw.githubusercontent.com/PonnamKarthik/FlutterToast/master/screenshot/2.png" width="320px" />
<img src="https://raw.githubusercontent.com/PonnamKarthik/FlutterToast/master/screenshot/3.png" width="320px" />
<img src="https://raw.githubusercontent.com/PonnamKarthik/FlutterToast/master/screenshot/4.png" width="320px" />
