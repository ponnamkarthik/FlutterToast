import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Signature for a function that defines custom position mapping for a toast
///
/// [child] is the toast widget to be positioned.
/// [gravity] is the gravity option for the toast which can be used to determine the position.
/// The function should return a [Widget] that defines the position of the toast.
/// If the position is not handled by the custom logic, return `null` to fall back to default logic.
typedef ToastPositionMapping = Widget? Function(
    Widget child, ToastGravity? gravity);

/// Toast Length
/// Only for Android Platform
enum Toast {
  /// Show Short toast for 1 sec
  LENGTH_SHORT,

  /// Show Long toast for 5 sec
  LENGTH_LONG
}

/// ToastGravity
/// Used to define the position of the Toast on the screen
enum ToastGravity {
  TOP,
  BOTTOM,
  CENTER,
  TOP_LEFT,
  TOP_RIGHT,
  BOTTOM_LEFT,
  BOTTOM_RIGHT,
  CENTER_LEFT,
  CENTER_RIGHT,
  SNACKBAR,
  NONE
}

/// Plugin to show a toast message on screen
/// Only for android, ios and Web platforms
class Fluttertoast {
  /// [MethodChannel] used to communicate with the platform side.
  static const MethodChannel _channel =
      const MethodChannel('PonnamKarthik/fluttertoast');

  /// Boolean to track if a toast is currently being shown
  static bool isCurrentlyShowingToast = false;

  /// Let say you have an active show
  /// Use this method to hide the toast immediately
  static Future<bool?> cancel() async {
    bool? res = await _channel.invokeMethod("cancel");
    isCurrentlyShowingToast = false;  // Update variable
    return res;
  }

  /// Show the [msg] via native platform's toast.
  ///
  /// On Android uses Toast.
  /// On iOS uses https://github.com/scalessec/Toast plugin.
  /// On web uses https://github.com/apvarun/toastify-js library.
  ///
  /// Parameter [msg] is required and all remaining are optional.
  ///
  /// The [fontAsset] is the path to your Flutter asset to use in toast.
  /// If not specified platform's default font will be used.
  static Future<bool?> showToast({
    required String msg,
    Toast? toastLength,
    int timeInSecForIosWeb = 1,
    double? fontSize,
    String? fontAsset,
    ToastGravity? gravity,
    Color? backgroundColor,
    Color? textColor,
    bool webShowClose = false,
    webBgColor = "linear-gradient(to right, #00b09b, #96c93d)",
    webPosition = "right",
  }) async {
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

    if (backgroundColor == null && !kIsWeb && Platform.isIOS) {
      backgroundColor = Colors.black;
    }
    if (textColor == null && !kIsWeb && Platform.isIOS) {
      textColor = Colors.white;
    }
    final Map<String, dynamic> params = <String, dynamic>{
      'msg': msg,
      'length': toast,
      'time': timeInSecForIosWeb,
      'gravity': gravityToast,
      'bgcolor': backgroundColor?.value,
      'iosBgcolor': backgroundColor?.value,
      'textcolor': textColor?.value,
      'iosTextcolor': textColor?.value,
      'fontSize': fontSize,
      'fontAsset': fontAsset,
      'webShowClose': webShowClose,
      'webBgColor': webBgColor,
      'webPosition': webPosition
    };

    isCurrentlyShowingToast = true;  // Update variable

    bool? res = await _channel.invokeMethod('showToast', params);

    // Assuming the platform will invoke 'cancel' method after showing toast
    Future.delayed(Duration(seconds: timeInSecForIosWeb), () {
      isCurrentlyShowingToast = false;
    });

    return res;
  }
}

/// Signature for a function to buildCustom Toast
typedef PositionedToastBuilder = Widget Function(
    BuildContext context, Widget child, ToastGravity? gravity);

/// Runs on dart side this has no interaction with the Native Side
/// Works with all platforms just in two lines of code
/// final fToast = FToast().init(context)
/// fToast.showToast(child)
///
class FToast {
  BuildContext? context;

  static final FToast _instance = FToast._internal();

  /// Prmary Constructor for FToast
  factory FToast() {
    return _instance;
  }

  /// Take users Context and saves to avariable
  FToast init(BuildContext context) {
    _instance.context = context;
    return _instance;
  }

  FToast._internal();

  OverlayEntry? _entry;
  List<_ToastEntry> _overlayQueue = [];
  Timer? _timer;
  Timer? _fadeTimer;

  /// Internal function which handles the adding
  /// the overlay to the screen
  ///
  _showOverlay() {
    if (_overlayQueue.isEmpty) {
      _entry = null;
      Fluttertoast.isCurrentlyShowingToast = false;  // Update variable
      return;
    }
    if (context == null) {
      /// Need to clear queue
      removeQueuedCustomToasts();
      throw ("Error: Context is null, Please call init(context) before showing toast.");
    }

    // To prevent exception "Looking up a deactivated widget's ancestor is unsafe."
    // which can be thrown if context was unmounted (e.g. screen with given context was popped)
    if (context?.mounted != true) {
      if (kDebugMode) {
        print(
            'FToast: Context was unmuted, can not show ${_overlayQueue.length} toast.');
      }

      // We should also clear the queue
      removeQueuedCustomToasts();
      return;
    }
    OverlayState? _overlay;
    try {
      _overlay = Overlay.of(context!);
    } catch (err) {
      removeQueuedCustomToasts();
      throw ("""Error: Overlay is null. 
      Please don't use top of the widget tree context (such as Navigator or MaterialApp) or 
      create overlay manually in MaterialApp builder.
      More information 
        - https://github.com/ponnamkarthik/FlutterToast/issues/393
        - https://github.com/ponnamkarthik/FlutterToast/issues/234""");
    }

    /// Create entry only after all checks
    _ToastEntry _toastEntry = _overlayQueue.removeAt(0);
    _entry = _toastEntry.entry;
    _overlay.insert(_entry!);

    _timer = Timer(_toastEntry.duration, () {
      _fadeTimer = Timer(_toastEntry.fadeDuration, () {
        removeCustomToast();
      });
    });

    Fluttertoast.isCurrentlyShowingToast = true;  // Update variable
  }

  /// If any active toast present
  /// call removeCustomToast to hide the toast immediately
  removeCustomToast() {
    _timer?.cancel();
    _fadeTimer?.cancel();
    _timer = null;
    _fadeTimer = null;
    _entry?.remove();
    _entry = null;
    _showOverlay();
  }

  /// FToast maintains a queue for every toast
  /// if we called showToast for 3 times we all to queue
  /// and show them one after another
  ///
  /// call removeCustomToast to hide the toast immediately
  removeQueuedCustomToasts() {
    _timer?.cancel();
    _fadeTimer?.cancel();
    _timer = null;
    _fadeTimer = null;
    _overlayQueue.clear();
    _entry?.remove();
    _entry = null;
    Fluttertoast.isCurrentlyShowingToast = false;  // Update variable
  }

  /// showToast accepts all the required paramenters and prepares the child
  /// calls _showOverlay to display toast
  ///
  /// Paramenter [child] is requried
  /// toastDuration default is 2 seconds
  /// fadeDuration default is 350 milliseconds
  void showToast({
    required Widget child,
    PositionedToastBuilder? positionedToastBuilder,
    Duration toastDuration = const Duration(seconds: 2),
    ToastGravity? gravity,
    Duration fadeDuration = const Duration(milliseconds: 350),
    bool ignorePointer = false,
    bool isDismissible = false,
  }) {
    if (context == null)
      throw ("Error: Context is null, Please call init(context) before showing toast.");
    Widget newChild = _ToastStateFul(
        child,
        toastDuration,
        fadeDuration,
        ignorePointer,
        !isDismissible
            ? null
            : () {
                removeCustomToast();
              });

    /// Check for keyboard open
    /// If open will ignore the gravity bottom and change it to center
    if (gravity == ToastGravity.BOTTOM) {
      if (MediaQuery.of(context!).viewInsets.bottom != 0) {
        gravity = ToastGravity.CENTER;
      }
    }

    OverlayEntry newEntry = OverlayEntry(builder: (context) {
      if (positionedToastBuilder != null)
        return positionedToastBuilder(context, newChild, gravity);

      return _getPositionWidgetBasedOnGravity(newChild, gravity);
    });
    _overlayQueue.add(_ToastEntry(
        entry: newEntry, duration: toastDuration, fadeDuration: fadeDuration));
    if (_timer == null) _showOverlay();
  }

  /// _getPositionWidgetBasedOnGravity generates [Positioned] [Widget]
  /// based on the gravity  [ToastGravity] provided by the user in
  /// [showToast]
  _getPositionWidgetBasedOnGravity(Widget child, ToastGravity? gravity) {
    switch (gravity) {
      case ToastGravity.TOP:
        return Positioned(top: 100.0, left: 24.0, right: 24.0, child: child);
      case ToastGravity.TOP_LEFT:
        return Positioned(top: 100.0, left: 24.0, child: child);
      case ToastGravity.TOP_RIGHT:
        return Positioned(top: 100.0, right: 24.0, child: child);
      case ToastGravity.CENTER:
        return Positioned(
            top: 50.0, bottom: 50.0, left: 24.0, right: 24.0, child: child);
      case ToastGravity.CENTER_LEFT:
        return Positioned(top: 50.0, bottom: 50.0, left: 24.0, child: child);
      case ToastGravity.CENTER_RIGHT:
        return Positioned(top: 50.0, bottom: 50.0, right: 24.0, child: child);
      case ToastGravity.BOTTOM_LEFT:
        return Positioned(bottom: 50.0, left: 24.0, child: child);
      case ToastGravity.BOTTOM_RIGHT:
        return Positioned(bottom: 50.0, right: 24.0, child: child);
      case ToastGravity.SNACKBAR:
        return Positioned(
            bottom: MediaQuery.of(context!).viewInsets.bottom,
            left: 0,
            right: 0,
            child: child);
      case ToastGravity.NONE:
        return Positioned.fill(child: child);
      case ToastGravity.BOTTOM:
      default:
        return Positioned(bottom: 50.0, left: 24.0, right: 24.0, child: child);
    }
  }
}

/// Simple builder method to create a [TransitionBuilder]
/// and for the use in MaterialApp builder method
// ignore: non_constant_identifier_names
TransitionBuilder FToastBuilder() {
  return (context, child) {
    return _FToastHolder(
      child: child!,
    );
  };
}

/// Simple StatelessWidget which holds the child
/// and creates an [Overlay] to display the toast
class _FToastHolder extends StatelessWidget {
  const _FToastHolder({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(
          builder: (BuildContext ctx) {
            return child;
          },
        ),
      ],
    );
  }
}

/// internal class [_ToastEntry] which maintains
/// each [OverlayEntry] and [Duration] for every toast user
/// triggered
class _ToastEntry {
  final OverlayEntry entry;
  final Duration duration;
  final Duration fadeDuration;

  _ToastEntry({
    required this.entry,
    required this.duration,
    required this.fadeDuration,
  });
}

/// internal [StatefulWidget] which handles the show and hide
/// animations for [FToast]
class _ToastStateFul extends StatefulWidget {
  _ToastStateFul(this.child, this.duration, this.fadeDuration,
      this.ignorePointer, this.onDismiss,
      {Key? key})
      : super(key: key);

  final Widget child;
  final Duration duration;
  final Duration fadeDuration;
  final bool ignorePointer;
  final VoidCallback? onDismiss;

  @override
  ToastStateFulState createState() => ToastStateFulState();
}

/// State for [_ToastStateFul]
class ToastStateFulState extends State<_ToastStateFul>
    with SingleTickerProviderStateMixin {
  /// Start the showing animations for the toast
  showIt() {
    _animationController!.forward();
  }

  /// Start the hidding animations for the toast
  hideIt() {
    _animationController!.reverse();
    _timer?.cancel();
  }

  /// Controller to start and hide the animation
  AnimationController? _animationController;
  late Animation _fadeAnimation;

  Timer? _timer;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.fadeDuration,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController!, curve: Curves.easeIn);
    super.initState();

    showIt();
    _timer = Timer(widget.duration, () {
      hideIt();
    });
  }

  @override
  void deactivate() {
    _timer?.cancel();
    _animationController!.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss == null ? null : () => widget.onDismiss!(),
      behavior: HitTestBehavior.translucent,
      child: IgnorePointer(
        ignoring: widget.ignorePointer,
        child: FadeTransition(
          opacity: _fadeAnimation as Animation<double>,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
