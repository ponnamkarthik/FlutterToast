# [fluttertoast](https://pub.dartlang.org/packages/fluttertoast)


Android Toast Library for Flutter

> Supported  Platforms
> * Android
> * IOS

## How to Use

```yaml
# add this line to your dependencies
fluttertoast: ^2.0.3
```

```dart
Fluttertoast.showToast(
        msg: "This is Center Short Toast",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1
    );
```

property | description
--------|------------
msg | String (Not Null)(required)
toastLength| Toast.LENGTH_SHORT or Toast.LENGTH_LONG (optional)
gravity | ToastGravity.TOP (or) ToastGravity.CENTER (or) ToastGravity.BOTTOM
timeInSecForIos | int (only for ios)

