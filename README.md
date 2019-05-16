# [fluttertoast](https://pub.dartlang.org/packages/fluttertoast)

Android and iOS Toast Library for Flutter

> Supported Platforms
>
> - Android
> - IOS

If you dont want to use androidx then use `fluttertoast` version `2.2.11`

## How to Use

```yaml
# add this line to your dependencies
fluttertoast: ^3.1.0
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
        textColor: Colors.white,
        fontSize: 16.0
    );
```

| property        | description                                                        |
| --------------- | ------------------------------------------------------------------ |
| msg             | String (Not Null)(required)                                        |
| toastLength     | Toast.LENGTH_SHORT or Toast.LENGTH_LONG (optional)                 |
| gravity         | ToastGravity.TOP (or) ToastGravity.CENTER (or) ToastGravity.BOTTOM |
| timeInSecForIos | int (only for ios)                                                 |
| bgcolor         | Colors.red                                                         |
| textcolor       | Colors.white                                                       |
| fontSize        | 16.0 (float)                                                       |

### To cancel all the toasts call

```dart
Fluttertoast.cancel()
```

## Preview Images

<img src="https://raw.githubusercontent.com/PonnamKarthik/FlutterToast/master/screenshot/1.png" width="320px" />
<img src="https://raw.githubusercontent.com/PonnamKarthik/FlutterToast/master/screenshot/2.png" width="320px" />
<img src="https://raw.githubusercontent.com/PonnamKarthik/FlutterToast/master/screenshot/3.png" width="320px" />
<img src="https://raw.githubusercontent.com/PonnamKarthik/FlutterToast/master/screenshot/4.png" width="320px" />

## If you need any features suggest
