# [fluttertoast](https://pub.dartlang.org/packages/fluttertoast)

Android and iOS Toast Library for Flutter

> Supported Platforms
>
> - Android
> - IOS
> - Web (Uses [Toastify-JS](https://github.com/apvarun/toastify-js))

If you dont want to use androidx then use `fluttertoast` version `2.2.11`

## How to Use

```yaml
# add this line to your dependencies
fluttertoast: ^4.0.0
```

```dart
import 'package:fluttertoast/fluttertoast.dart';
```

```dart
Fluttertoast.showToast(
        msg: "This is Center Short Toast",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
```

| property        | description                                                        | default    |
| --------------- | ------------------------------------------------------------------ |------------|
| msg             | String (Not Null)(required)                                        |required    |
| toastLength     | Toast.LENGTH_SHORT or Toast.LENGTH_LONG (optional)                 |Toast.LENGTH_SHORT  |
| gravity         | ToastGravity.TOP (or) ToastGravity.CENTER (or) ToastGravity.BOTTOM (Web Only supports top, bottom) | ToastGravity.BOTTOM    |
| timeInSecForIosWeb | int (only for ios)                                                 | 1       |
| bgcolor         | Colors.red                                                         |Colors.black    |
| textcolor       | Colors.white                                                       |Colors.white    |
| fontSize        | 16.0 (float)                                                       | 16.0       |
| webShowClose    | false (bool)                                                       | false      |
| webBgColor      | String (hex Color)                                                 | linear-gradient(to right, #00b09b, #96c93d) |
| webPosition     | String (`left`, `center` or `right`)                                | right     |

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
